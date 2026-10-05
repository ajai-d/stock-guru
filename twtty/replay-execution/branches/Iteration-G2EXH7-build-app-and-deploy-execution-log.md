# Branch-Execution Log — Iteration-G2EXH7 · build-app-and-deploy

Branch-scoped replay log (sdlc §8.1.2) for EXECUTE work items W-2 through W-8, bundled on one branch (bundle-by-default, sdlc §5.1) under Autopilot (iteration entries 003, 012). Archived to `main` at merge.

---

### br-build-app-and-deploy-001 · meta/branch-open · —
- **Timestamp:** 2026-10-05T05:35:00Z
- **Approval outcome:** Approved
- **Execution outcome:** branch opened
- **Notes:** Delivers W-2-infra, W-3-movers, W-4-eval, W-5-agent, W-6-api, W-7-ui, W-8-cicd. Main-agent-handled, Sequential; W-1-identity-bootstrap already integrated (PR #1). Eval-first honored: W-4-eval precedes W-5-agent.

### br-build-app-and-deploy-002 · execute/3b · —  (W-3-movers)
- **Timestamp:** 2026-10-05T05:38:00Z
- **Approval outcome:** Approved
- **Execution outcome:** W-3-movers — `MoversProvider` + `SeededMoversProvider` (25-ticker fixture) + MCP server exposing `get_market_movers` (T-1). Unit tests `tests/test_movers.py`.
- **Artifact / path changed:** `src/app/models.py`, `src/app/config.py`, `src/app/movers.py`, `src/app/mcp_server.py`, `data/movers_seed.json`, `tests/test_movers.py`
- **Notes:** T-1 output schema per spec §9.1. Auto-approved under Autopilot.

### br-build-app-and-deploy-003 · execute/3f · —  (W-4-eval, eval-first)
- **Timestamp:** 2026-10-05T05:41:00Z
- **Approval outcome:** Approved
- **Execution outcome:** W-4-eval — evaluation harness `tests/eval/run.py` scoring DIM-1 (grounding), DIM-2 (schema), DIM-3 (disclaimer), DIM-4 (rationale) over `tests/eval/data/cases.jsonl` (20 cases) → report under `reports/eval/`; safety tests `tests/safety/`. The `W-<n>-eval` item; implements every §10 dimension (dataset, scorer, report).
- **Artifact / path changed:** `tests/eval/run.py`, `tests/eval/data/cases.jsonl`, `tests/safety/run.py`, `tests/safety/prompts.jsonl`
- **Notes:** Sequenced before W-5-agent (agentic addendum §3.2 eval-first). Auto-approved under Autopilot.

### br-build-app-and-deploy-004 · execute/3b · —  (W-5-agent)
- **Timestamp:** 2026-10-05T05:44:00Z
- **Approval outcome:** Approved
- **Execution outcome:** W-5-agent — T-2 `recommend` on **Microsoft Agent Framework** (`agent_framework.azure.AzureOpenAIChatClient` + `create_agent`) via app **managed identity** (no keys); post-response grounding (drop ungrounded tickers), schema validation (3-5 items, confidence in [0,1]), cost metering + fail-closed, disclaimer at the boundary; deterministic stub for offline/CI. Unit tests `tests/test_agent.py`.
- **Artifact / path changed:** `src/app/agent.py`
- **Notes:** LLM-driven behavior; depends on W-4-eval (br-003) and W-3-movers (br-002). Auto-approved under Autopilot.

### br-build-app-and-deploy-005 · execute/3b · —  (W-6-api)
- **Timestamp:** 2026-10-05T05:46:00Z
- **Approval outcome:** Approved
- **Execution outcome:** W-6-api — FastAPI `/healthz`, `/api/movers`, `/api/recommend` per spec §15 (422/429/503 error semantics; disclaimer always present). Unit tests `tests/test_api.py`.
- **Artifact / path changed:** `src/app/main.py`, `tests/test_api.py`, `conftest.py`
- **Notes:** Auto-approved under Autopilot.

### br-build-app-and-deploy-006 · execute/3b · —  (W-7-ui)
- **Timestamp:** 2026-10-05T05:48:00Z
- **Approval outcome:** Approved
- **Execution outcome:** W-7-ui — accessible single-page dashboard (`frontend/index.html`): profile form (risk radio + sector checkboxes), recommendation cards with labeled confidence meter + expandable reasoning, persistent "not financial advice" disclaimer, empty/loading/error states. Impeccable-guided design system (light theme, system fonts, one accent, AA contrast).
- **Artifact / path changed:** `frontend/index.html`
- **Notes:** UX mode Delegated; realizes spec §13. Auto-approved under Autopilot.

### br-build-app-and-deploy-007 · execute/3h · —  (W-2-infra)
- **Timestamp:** 2026-10-05T05:50:00Z
- **Approval outcome:** Approved
- **Execution outcome:** W-2-infra — `infra/main.bicep`: a NEW Azure OpenAI (Azure AI Foundry) account + `gpt-4o-mini` deployment, Azure Container Registry, Log Analytics, Container Apps environment + app (app managed identity), with role assignments (app identity → Cognitive Services OpenAI User on AOAI, AcrPull on ACR). `az bicep build` exit 0. IaC-only; least-privilege RBAC in IaC.
- **Artifact / path changed:** `infra/main.bicep`
- **Notes:** Auto-approved under Autopilot (billable provisioning authorized, entry 012).

### br-build-app-and-deploy-008 · execute/3g · —  (W-8-cicd)
- **Timestamp:** 2026-10-05T05:52:00Z
- **Approval outcome:** Approved
- **Execution outcome:** W-8-cicd — `Dockerfile` (gunicorn/uvicorn) + `.dockerignore` + `.github/workflows/deploy.yml`: test (pytest + eval + safety) → OIDC login (no secrets) → Bicep provision → `az acr build` → `az containerapp update` → smoke `/healthz`. No `environment:` on the deploy job so the OIDC subject matches the `ref:refs/heads/main` federated credential.
- **Artifact / path changed:** `Dockerfile`, `.dockerignore`, `.github/workflows/deploy.yml`
- **Notes:** Auto-approved under Autopilot.

### br-build-app-and-deploy-009 · execute/3f · —  (validation)
- **Timestamp:** 2026-10-05T05:55:00Z
- **Approval outcome:** Approved
- **Execution outcome:** Local validation: **9/9 unit tests pass**; evaluation **DIM-1 100%, DIM-2 100%, DIM-3 100%, DIM-4 100%** (thresholds 100/100/100/≥80); **safety pass** (disclaimer always present, no invented tickers, schema held). Per-recommendation cost metered + logged (stub: 0; real path: tokens + est cost to `reports/usage/usage.jsonl`). `agent-framework` installs clean; both Bicep templates valid.
- **Artifact / path changed:** `reports/eval/local.json` (gitignored)
- **Notes:** Satisfies spec AC-1..AC-9 locally; AC-10 (live deploy) pending integration. Agentic EXECUTE-EXIT condition 7 (eval scores) and 8 (cost metering) evidence recorded here. DIM-4 offline uses the deterministic heuristic judge; the live LLM-judge runs against the deployed model.

### br-build-app-and-deploy-010 · meta/branch-close · —
- **Timestamp:** 2026-10-05T05:57:00Z
- **Approval outcome:** Approved
- **Execution outcome:** branch closed; ready for integration
- **Notes:** Delivered W-2..W-8. Validation br-009. Delivery evidence: br-002..br-009. Live deploy (AC-10) runs on integration to `main`.
