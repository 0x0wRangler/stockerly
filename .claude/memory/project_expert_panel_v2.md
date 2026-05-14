---
name: Expert panel v2 (8 Core + 8 Situational with names)
description: Stockerly virtual expert panel inspired by Mi Feria model. 8 Core consulted on relevant work, 8 Situational by explicit trigger. Output is recommendation + risks + fallback. Significant direction changes become ADRs.
type: project
---

**Lives at:** `docs/research/experts.md` (created Sprint 1 Step 4)
**Replaces:** `docs/spec/EXPERTS.md` (flat list of 10, archived at `docs/archive/spec-2026-Q1/EXPERTS-v1.md`)

**Core (8 — consulted on any relevant work):**

| ID | Name | Domain | Activated when |
|---|---|---|---|
| C1 | Lucía Ramírez | Mexican financial domain (CETES, ISR, FX histórico, retención dividendos) | Anything touching Trading, MarketData::Domain, money, currency, fiscal |
| C2 | Hiroto Watanabe | DDD + Hexagonal in Rails monolith | New BC, use case, event handler, boundary change |
| C3 | Sven Kowalski | Rails 8 backend (AR, dry-rb, contracts) | Server-side implementation, migrations, controllers |
| C4 | Marisol Aguirre | Hotwire (Turbo + Stimulus) + Tailwind 4 | Any view, layout, partial, interactivity |
| C5 | Renata Câmara | UX/UI fintech, design tokens, financial copy | Any new or rewritten screen; copy; visual hierarchy |
| C6 | Esther Mwangi | Product strategist (scope discipline) | Before sprint planning; when "would be cool to add..." appears |
| C7 | Fadia Haddad | Security (auth, IDOR, sensitive data, audit logging) | Auth, encryption, sensitive data, new controllers |
| C8 | Bram Hendriks | OSS maintainer + portfolio público | README, CONTRIBUTING, releases, what to expose publicly |

**Situational (8 — invoked by explicit trigger):**

| ID | Name | Domain | Trigger |
|---|---|---|---|
| S1 | Olusegun Adebayo | DevOps (Kamal, GH Actions, observability) | Deploy issues, CI changes, monitoring |
| S2 | Adriana Cienfuegos | Data engineer (gateways, rate limits) | New gateway; provider switch; rate limit issues |
| S3 | Yui Nakashima | Performance (N+1, fragment caching, indices) | Reported slow page; slow query; many snapshots |
| S4 | Camila Ferreyra | Localization MX (es-MX, MXN formats, dates) | New copy; currency formatting; dates; numbers |
| S5 | Ileana Voinea | Legal/Compliance MX (LFPDPPP, SAT, third parties) | New personal data; third-party integration; public release |
| S6 | Kenji Aragaki | Database migrations Rails (zero-downtime, backfill) | Non-trivial migration; column change; backfill |
| S7 | Soo-ah Park | Developer experience (dev loop, tests fast, pre-commit) | Slow dev loop; flakiness; build pipeline; generators |
| S8 | Mehmet Karadeniz | QA / Testing (RSpec, factories, system specs) | New test strategy; coverage drop; flaky specs |

**Operating rules:**
- Panel advises — I (Claude) decide — Adrian has final voice
- Output format for any consultation: **recommended option + key risks + fallback/rollback path**
- Conflicts between experts: check `docs/vision/` and `docs/architecture/adr/`; if unresolved, escalate to Adrian
- Significant direction changes from consultations → must become ADR
- "Disagree openly, decide clearly, document why"

**How to invoke in conversation:**
- "Consultemos a Lucía sobre este modelado de currency"
- "Renata, ¿este copy comunica?"
- "Antes de tocar el schema, S6 Kenji"

**How to apply:**
- Before significant work, identify which experts apply and consult mentally
- For multi-domain decisions, parallelize: spawn sub-agents framed as the experts
- When Adrian asks for review, default to Core panel; situational only on clear trigger
