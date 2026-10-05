# runtimeconfig — stock-guru

Project-owned binding overrides / resolutions (sdlc §1.1; agentic addendum).
Resolution is per attribute: a value listed here uses the local selection;
anything absent inherits the methodology default.

```yaml
# Baseline bindings
cloud: azure                       # Runtime target: Azure Container Apps + Azure AI Foundry
risk-calibration: level-2          # confirmed at SEED (meta/risk-level)

# Agentic specialization bindings
agentic-stack: default             # Microsoft Agent Framework on Azure AI Foundry, gpt-4o-mini
                                   # (sdlc-for-agentic-apps/config/agentic-stack/default.md)
tokenomics:
  product: bounded                 # per-request cost bounded + logged (spec §11)

reusable-assets:
  skills: impeccable               # UX skill for the dashboard
```

## Resolved agentic stack (pinned for reproducibility)

| Capability | Resolved value |
|------------|----------------|
| Agent framework / SDK | Microsoft Agent Framework (`agent_framework.azure.AzureOpenAIChatClient` + `create_agent`) |
| Model platform | Azure AI Foundry (Azure OpenAI deployment) |
| Model | `gpt-4o-mini` |
| Model auth | app managed identity (no keys), per `config/cloud/azure.md` |
| Orchestration | single-agent |
| Tool ecosystem | MCP (`get_market_movers`) |
| Eval / guardrails | custom harness (DIM-1..4) + post-response grounding/schema enforcement |

The project adopts the bound `agentic-stack` default unchanged; this file records
the resolution so the iteration is reproducible (the `meta/config` replay entry
pins it in the log).
