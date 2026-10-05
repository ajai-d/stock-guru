# Branch-Execution Log — Iteration-G2EXH7 · W-1-identity-bootstrap

Branch-scoped replay log (sdlc §8.1.2). Archived to `main` at merge.

---

### br-W-1-identity-bootstrap-001 · meta/branch-open · —
- **Timestamp:** 2026-10-05T05:20:00Z
- **Approval outcome:** Approved
- **Execution outcome:** branch opened
- **Notes:** Delivers W-1-identity-bootstrap. Main-agent-handled, Autopilot (iteration entries 003, 012).

### br-W-1-identity-bootstrap-002 · execute/3h · —
- **Timestamp:** 2026-10-05T05:24:00Z
- **Approval outcome:** Approved
- **Execution outcome:** `infra/identity.bicep` authored (CI UAMI + GitHub federated credential + app UAMI + scoped roles Contributor/UserAccessAdministrator on the RG). `az bicep build` exit 0.
- **Artifact / path changed:** `infra/identity.bicep`
- **Notes:** CI identity is the GitHub-OIDC deploy principal; app identity is the Container App runtime identity for AOAI/ACR. Auto-approved under Autopilot.

### br-W-1-identity-bootstrap-003 · execute/3i · —
- **Timestamp:** 2026-10-05T05:28:00Z
- **Approval outcome:** Approved
- **Execution outcome:** One-time apply complete (billable Azure, Human-User-authorized per entry 012). `az deployment group create` on rg-stock-guru succeeded. Federated subject verified = `repo:ajai-d@<REDACTED:owner-id>/stock-guru@<REDACTED:repo-id>:ref:refs/heads/main` (ID-qualified, matches the actual GitHub token). Repo variables set: AZURE_CLIENT_ID (CI identity), AZURE_TENANT_ID, AZURE_SUBSCRIPTION_ID, AZURE_APP_CLIENT_ID.
- **Artifact / path changed:** — (Azure resources + GitHub repo variables)
- **Notes:** The one-time out-of-band identity bootstrap; thereafter CI deploys via OIDC with no stored secrets. Auto-approved under Autopilot (entry 012 waived the hard guardrail).

### br-W-1-identity-bootstrap-004 · meta/branch-close · —
- **Timestamp:** 2026-10-05T05:30:00Z
- **Approval outcome:** Approved
- **Execution outcome:** branch closed; ready for integration
- **Notes:** Delivered W-1. Identity live in Azure; repo variables set.
