# Discovery Transcript — Iteration-G2EXH7

Discovery mode: **Delegated** (the AI Agent decided and disclosed each non-trivial binding; the Human User approves the resulting spec at SPEC-EXIT). SPEC stage is Interactive; PLAN/EXECUTE are Autopilot (entry 003).

## Three upfront questions (asked of the Human User before any elicitation — front-of-1a precondition)

The Spec Agent put all three upfront questions to the Human User as the first action of `spec/1a`, before reading beyond the seeds or drafting any content. The Human User's answers:

- **Discovery mode:** **Delegated** — explicitly chosen by the Human User (not inferred). The AI Agent drafts each of the four rounds and discloses its choices; the Human User approves/refines/rejects.
- **UX mode:** **Delegated** (applies — the app ships a web dashboard) — explicitly chosen by the Human User. The AI Agent decides the UX requirements and discloses them; the bound Impeccable skill guides the design.
- **API mode:** **Delegated** (applies — MCP tool surface + HTTP API) — explicitly chosen by the Human User. The AI Agent decides the API/MCP contract obligations and discloses them.

(The earlier execution-mode authorization — Autopilot for PLAN/EXECUTE — is a separate axis and was NOT treated as an answer to any of these.)

## Resolved capability bindings (config interview)

| Binding | Resolved value | Rationale |
|---|---|---|
| `harness` | GitHub Copilot (default) | shipped default |
| `devtools` | GitHub (repo + Actions) | remote bootstrapped at SEED; CI/CD via Actions |
| `cloud` | Azure | required by seed (deploy to Azure) |
| `Runtime target` | **Azure Container Apps** (backend container) + **Azure OpenAI** (model endpoint) | agentic web app with a model dependency; Container Apps is the L2 serverless container host; AOAI accessed via **managed identity** (no keys) |
| `risk-calibration` | default ladder, **Level 2** + cloud target | confirmed at SEED (entry 001) |
| `reusable-assets.skills` | Impeccable (UX) when UI work is in scope | UX mode applies |
| `tokenomics/build` | none | prototype |
| Product runtime cost | **bounded + logged per recommendation** | agentic cost control (sdlc-for-agentic-apps §11); seed requires it |
| `escalation` | Human User | default |

## Identity / deploy (per config/cloud/azure.md — proven in isolated test)
CI-to-cloud and app-runtime auth use a **user-assigned managed identity + GitHub OIDC federated credential** (no Entra app, no stored secrets). A `W-<n>-identity-bootstrap` work item is sequenced first in PLAN. The federated-credential **subject must match the ACTUAL token GitHub presents** (may be ID-qualified `repo:<owner>@<id>/<repo>@<id>:ref:refs/heads/main`); determined at bootstrap via the `AADSTS700213` feedback loop. AOAI access uses the app's managed identity (Cognitive Services OpenAI User role, declared in IaC).

## Mismatch check
No mismatch — the seed is clearly LLM-driven (an agent producing reasoned recommendations), aligning with `sdlc-for-agentic-apps`.
