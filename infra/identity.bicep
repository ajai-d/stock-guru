// infra/identity.bicep — W-1 identity-bootstrap (resource-group scope).
// Applied ONCE out-of-band by the Human User's az login (CI has no credential yet).
// Creates the CI deploy identity (GitHub OIDC federated), the app runtime identity,
// and the scoped roles CI needs to deploy main.bicep (incl. role assignments).

@description('Location for the identities.')
param location string = resourceGroup().location

@description('GitHub OIDC federated-credential subject (actual token subject — may be ID-qualified).')
param ghSubject string

@description('CI deploy user-assigned managed identity name.')
param ciIdentityName string = 'id-stock-guru-ci'

@description('App runtime user-assigned managed identity name.')
param appIdentityName string = 'id-stock-guru-app'

resource ci 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: ciIdentityName
  location: location
}

resource fic 'Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials@2023-01-31' = {
  parent: ci
  name: 'github-main'
  properties: {
    issuer: 'https://token.actions.githubusercontent.com'
    subject: ghSubject
    audiences: [ 'api://AzureADTokenExchange' ]
  }
}

resource app 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: appIdentityName
  location: location
}

// Contributor on this RG — CI can create/update resources.
resource ciContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, ci.id, 'Contributor')
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
    principalId: ci.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

// User Access Administrator on this RG — CI can create the role assignments in main.bicep
// (app identity -> OpenAI User, AcrPull). Scoped to the RG (least-privilege for this prototype).
resource ciUaa 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, ci.id, 'UserAccessAdministrator')
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
    principalId: ci.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

output ciClientId string = ci.properties.clientId
output ciPrincipalId string = ci.properties.principalId
output appIdentityId string = app.id
output appClientId string = app.properties.clientId
output appPrincipalId string = app.properties.principalId
output tenantId string = tenant().tenantId
output subscriptionId string = subscription().subscriptionId
