# Jobs to be Done — Stockerly

> The 6 JTBDs that justify Stockerly's existence as of 2026-05-14.
> Each JTBD here is the **expansion** of the lines that appear in [`audience.md`](./audience.md).
> A new feature in the backlog must map to one of these (or propose a new JTBD via an edit to this file).

---

## Structure of each JTBD

```
**Statement** — the canonical phrase "When X, I want Y, so that Z"
**Required data** — what must exist in DB/gateways
**App surface** — where the user sees it
**Triggers** — what proactively surfaces it (if applicable)
**Usage metric** — how we'll know the JTBD is fulfilled
**Blocked by** — current debt that prevents fulfillment
**Current status** — how close it is today
```

---

## JTBD #1 — Consolidated patrimony in MXN

**Statement:** *When I review my portfolio over the weekend, I want to see my total patrimony consolidated in MXN, so I can know whether I'm up or down since last time.*

**Required data:**
- Current positions (`positions` table)
- Current prices (gateways: Polygon equities, CoinGecko crypto, Banxico CETES)
- Current USD→MXN FX rate (FxRatesGateway or Banxico)
- USD→MXN FX rate at the moment of each purchase (**blocker**: doesn't exist today)
- Historical snapshots (`portfolio_snapshots`) for chronological comparison

**App surface:**
- Main dashboard — "Total Patrimony" KPI in MXN (with visible USD→MXN conversion)
- Portfolio page — consolidated totals at the top

**Triggers:** none. It's data always visible when opening the app.

**Usage metric:** Adrian opens the dashboard ≥1 time per week on weekends. If it drops below 1/month, the JTBD is not being fulfilled.

**Blocked by:** `currency: "USD"` hardcoded in `app/contexts/trading/use_cases/execute_trade.rb:39,60`. Until this is resolved, consolidated patrimony in MXN is fiction. **Absolute P0.**

**Current status:** UI implemented; math broken by the P0 bug. Friends cannot be invited to beta until this is fixed.

---

## JTBD #2 — Position drawdown from average cost in MXN

**Statement:** *When my position drops X% from average cost (in MXN), I want to know, so I can decide whether to average down or exit.*

**Required data:**
- `position.avg_cost` in the currency of acquisition
- `position.cost_basis_mxn` computed with historical FX (**blocker**: doesn't exist)
- Current price (USD for equities, MXN for CETES)
- Current FX rate
- Threshold X (user-configurable; suggested default: -10% for warning, -15% for alert)

**App surface:**
- Portfolio page — badge on each position that crossed the threshold
- Dashboard — "Notable observations" section if there are positions below threshold
- Alerts — in-app notification when a position first crosses the threshold (mandatory cooldown)

**Triggers:** EOD job reviews all positions, fires alert when one crosses the threshold downward (no spam if already below).

**Usage metric:** Adrian opens the alert/badge within 24h of generation (proxy: click event). If he consistently ignores them, the JTBD isn't working.

**Blocked by:** same P0 as JTBD #1. Without correct cost basis in MXN, the computed percentage lies.

**Current status:** AlertRule exists with `price_below_pct` nearby; needs an "X% from MXN cost basis" variant and the currency fix.

---

## JTBD #3 — CETE about to mature

**Statement:** *When a CETE is about to mature, I want to know with 7 days of lead time, so I can decide whether to reinvest.*

**Required data:**
- `asset.maturity_date` for asset_type CETE
- Active positions in CETE-type assets
- Calendar (Banxico business days for accuracy)

**App surface:**
- Dashboard sidebar — "Upcoming events" listing CETES near maturity
- Asset detail of each CETE — visible countdown
- Alerts — notification at 7d, 3d, 1d before

**Triggers:** Daily cron job; check positions against maturity_date.

**Usage metric:** Adrian reinvests (or explicitly chooses not to) within 48h after maturity. Proxy: new trade or explicit alert dismissal.

**Blocked by:** nothing structural blocks. CETES have been modeled since Phase 13.1 with the Mexican `YieldCalculator`.

**Current status:** CETES listing exists, maturity alerts partially implemented. Verify in the code audit (Step 6) what's missing.

---

## JTBD #4 — Earnings on held assets

**Statement:** *When an earnings event is coming for something I hold, I want to know 2 days ahead, so I don't find out after the fact.*

**Required data:**
- Earnings calendar (Polygon gateway, exists)
- User's current holdings (active positions)
- Match between holding tickers and tickers in earnings calendar

**App surface:**
- Dashboard "Upcoming events" — earnings on holdings with BMO/AMC + EPS estimate
- Earnings page filtered by my holdings
- Notification — 2d, 1d before (with details)

**Triggers:** `NotifyEarningsJob` daily, 7am. Matches holdings vs upcoming earnings, deduplicated with `last_triggered_at` per event.

**Usage metric:** Adrian opens the asset detail of the ticker with upcoming earnings before the event. Proxy: page view of the asset between alert and earnings.

**Blocked by:** nothing. Implemented since Phase 14.4 (`Earnings::NotifyApproaching`).

**Current status:** Working. Validate in the audit that the notification copy doesn't lapse into prescriptive language.

---

## JTBD #5 — Fast trade capture

**Statement:** *When I add a new trade, I want to capture it in under 30 seconds, so I don't abandon the recording out of laziness.*

**Required form data:**
- Ticker (with autocomplete against `assets`)
- Shares
- Price (in native currency)
- **Currency (auto-detected from the asset)** — today hardcoded to USD ❌
- Date (default: today; max: today; min: ¿1 year back?)
- FX rate at the time of the trade (**missing**: auto-capture from Banxico if currency = USD)
- Optional notes, optional labels

**App surface:**
- Portfolio page — "+ Add Trade" button opens inline form (Turbo Frame)
- Dashboard — quick action "Add Trade"

**Friction points (to measure and reduce):**
1. Ticker search — should be <300ms with debounce
2. FX capture — should be automatic, not manual
3. Currency decision — should be auto from the asset
4. Reasonable-price validation — immediate feedback if very different from current price

**Usage metric:** time from "open form" to "submitted". Target: P50 < 30s, P95 < 60s.

**Blocked by:** the hardcoded currency from the P0 affects this JTBD too. Without FX-at-execution, the form omits that critical field.

**Current status:** Form exists, works, but captures hardcoded currency and doesn't capture FX rate. Needs rework as part of the P0 fix.

---

## JTBD #6 — Position in notable technical zone

**Statement:** *When one of my positions (or a watchlist asset) enters a notable technical zone (oversold/overbought per RSI, Bollinger Bands breakout, moving-average crossover), I want to see it described in context, so I can factor it into my weekly portfolio reflection.*

**Required data:**
- Historical daily prices ≥200 days (exists via `price_histories`)
- Per-asset computed indicators (RSI(14), MACD, BB, MA50, MA200, EMA9/21)
- TrendScore 5-factor (already exists)
- User holdings + watchlist

**App surface:**
- Asset detail — "Technical analysis" section with current indicators + descriptive interpretation
- Dashboard — "Notable observations" section when ≥1 relevant asset enters a zone
- Market listings — hover/click reveals TrendScore breakdown (exists since Phase 21.1)

**Triggers:**
- Daily EOD job: recompute indicators, detect transitions (asset entered oversold today / crossed MA50 today)
- Generate "observation" when a transition occurs, associated with user's holding/watchlist
- Dedup: one observation per asset/zone/week (cooldown)

**Required language (ADR-001):**
- ✅ *"AAPL appears oversold per RSI(14) = 28"*
- ✅ *"NVDA crossed below its MA200"*
- ❌ *"Consider buying AAPL"*

**Usage metric:** Adrian opens ≥1 asset detail per week from a surfaced notable observation. If he ignores them, the JTBD isn't working or the observations are too noisy.

**Blocked by:** nothing directly (indicators are already computed). Missing: descriptive copy, surfacing as "notable observations", and threshold tuning to avoid noise.

**Current status:** Indicators computed (Phase 21.1). Missing descriptive surface + dedup + dedicated UI.

---

## How a new JTBD gets added

1. Documented personal trigger: *"On [date] I encountered [specific situation], and [information/action] wasn't available in Stockerly"*.
2. Statement in canonical format: *"When X, I want Y, so that Z"*.
3. Data, surface, triggers, metric, blockers — fill in the 6 sections.
4. Edit `audience.md` and vision's `README.md` to reflect the new JTBD count.
5. Commit with message *"docs(vision): add JTBD #N — [brief statement]"*.

## How a JTBD gets retired

If after 90 days of being implemented:
- The usage metric isn't met (Adrian doesn't use it with expected frequency)
- Or Adrian explicitly admits it doesn't serve him

→ retro flags it for retirement. Backlog issue: *"Retire JTBD #N: reason"*. The associated features are evaluated case by case (some may stay as observable infra, others get de-implemented).
