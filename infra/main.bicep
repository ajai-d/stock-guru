// infra/main.bicep — W-2 infrastructure (resource-group scope). Deployed by CI via OIDC.
// Creates a NEW Azure OpenAI (Azure AI Foundry) account + gpt-4o-mini deployment, ACR,
// Log Analytics, Container Apps environment + app. Role assignments bind the app managed
// identity to the model (OpenAI User) and registry (AcrPull). No keys anywhere.

@description('Location.')
param location string = resourceGroup().location

@description('Container App / base name.')
param appName string = 'stock-guru'

@description('Model deployment name + model.')
param modelName string = 'gpt-4o-mini'
param modelVersion string = '2024-07-18'

@description('Container image (CI passes the real ACR image; placeholder for first apply).')
param image string = 'mcr.microsoft.com/k8se/quickstart:latest'

var suffix = uniqueString(resourceGroup().id)
var acrName = 'acr${suffix}'
var aoaiName = 'aoai-${appName}-${suffix}'

// App runtime identity (created in identity.bicep).
resource appUami 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name: 'id-stock-guru-app'
}

resource law 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: 'law-${appName}'
  location: location
  properties: {
    sku: { name: 'PerGB2018' }
    retentionInDays: 30
  }
}

resource acr 'Microsoft.ContainerRegistry/registries@2023-11-01-preview' = {
  name: acrName
  location: location
  sku: { name: 'Basic' }
  properties: { adminUserEnabled: false }
}

resource aoai 'Microsoft.CognitiveServices/accounts@2024-10-01' = {
  name: aoaiName
  location: location
  kind: 'OpenAI'
  sku: { name: 'S0' }
  properties: {
    customSubDomainName: aoaiName
    publicNetworkAccess: 'Enabled'
    disableLocalAuth: true
  }
}

resource model 'Microsoft.CognitiveServices/accounts/deployments@2024-10-01' = {
  parent: aoai
  name: modelName
  sku: { name: 'Standard', capacity: 10 }
  properties: {
    model: { format: 'OpenAI', name: modelName, version: modelVersion }
  }
}

resource env 'Microsoft.App/managedEnvironments@2024-03-01' = {
  name: 'cae-${appName}'
  location: location
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: law.properties.customerId
        sharedKey: law.listKeys().primarySharedKey
      }
    }
  }
}

resource app 'Microsoft.App/containerApps@2024-03-01' = {
  name: appName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: { '${appUami.id}': {} }
  }
  properties: {
    managedEnvironmentId: env.id
    configuration: {
      ingress: { external: true, targetPort: 8000, transport: 'auto' }
      registries: [
        { server: acr.properties.loginServer, identity: appUami.id }
      ]
    }
    template: {
      containers: [
        {
          name: appName
          image: image
          resources: { cpu: json('0.5'), memory: '1Gi' }
          env: [
            { name: 'AOAI_ENDPOINT', value: aoai.properties.endpoint }
            { name: 'AOAI_DEPLOYMENT', value: modelName }
            { name: 'AZURE_CLIENT_ID', value: appUami.properties.clientId }
          ]
        }
      ]
      scale: { minReplicas: 0, maxReplicas: 2 }
    }
  }
}

// App identity -> Cognitive Services OpenAI User on the AOAI account.
resource openaiUser 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(aoai.id, appUami.id, 'openai-user')
  scope: aoai
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5e0bd9bd-7b93-4f28-af87-19fc36ad61bd')
    principalId: appUami.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

// App identity -> AcrPull on the registry.
resource acrPull 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(acr.id, appUami.id, 'acrpull')
  scope: acr
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
    principalId: appUami.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

output acrName string = acr.name
output acrLoginServer string = acr.properties.loginServer
output aoaiEndpoint string = aoai.properties.endpoint
output appClientId string = appUami.properties.clientId
output appFqdn string = app.properties.configuration.ingress.fqdn
output appResourceName string = app.name
