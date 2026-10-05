## What I want to do

Baseline iteration — build the first working, deployed version of the Daily
Stock Advisor, scoped within the project seed. This iteration delivers the bulk
of the app:

- **MCP server** exposing the day's market movers (top gainers/losers) as a tool,
  backed by a market-data source with a seeded/stubbed feed for offline runs and
  tests.
- **LLM agent** that reads a user's risk profile + sectors and produces a
  watchlist of 3–5 tickers, each with a one-line rationale and a confidence
  score, grounded strictly in the movers data (no invented symbols).
- **Web dashboard**: a profile form (risk tolerance + sectors) and recommendation
  cards with expandable reasoning and a persistent "not financial advice"
  disclaimer.
- **Evaluations**: grounding (recommended ⊆ movers), output-schema validity, and
  disclaimer-always-present.
- **Cost control**: per-recommendation token/cost bounded and logged.
- **Deploy**: provisioned and deployed to Azure via IaC + CI/CD (OIDC, no stored
  secrets), reachable by users outside the team.

## What done looks like

- `GET` movers via the MCP tool returns the day's candidates (live or stubbed).
- The agent returns 3–5 tickers with rationale + confidence, every ticker present
  in the movers input.
- The dashboard lets a user set a profile and view recommendation cards with
  reasoning and the disclaimer.
- Evals pass: grounding, schema validity, disclaimer presence.
- Per-recommendation cost is bounded and logged.
- The service is live on Azure at a public URL; clone-and-run works locally with
  unit tests + evals passing.

> Scope note: this is the baseline iteration and builds the bulk of the app.
> Later iterations build on this spec, plan, and code rather than replacing it.
