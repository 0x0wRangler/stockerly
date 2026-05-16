# Claude Design Setup — Stockerly Bundle

> Checklist to (re)configure [Claude Design](https://claude.ai/design) — or any external visual AI tool (Stitch, Figma AI, v0) — so it generates mockups consistent with the Stockerly design system. Built 2026-05-16.

**Anchor decision:** the Lumen indigo spec from [`tokens.md`](./tokens.md) wins. The pre-Lumen `#005A98` in `app/assets/tailwind/application.css` is migration-pending and must NOT be fed to visual tools — it would contaminate mockups with the old palette.

---

## 1. Company name and blurb

Paste exactly:

```
Stockerly — open-source personal portfolio tracker for Mexican investors with mixed MXN+USD holdings (CETES, BMV equities, US stocks, crypto). Self-hosted, closed beta (≤20 invited friends). Not a trading platform, not enterprise SaaS — a quiet, dense, dependable weekend tool. Voice is descriptive, never prescriptive. UI copy is es-MX. Palette: Lumen (warm cream + indigo accent). Logo: Focal frame (four L-bracket corners + observation dot).
```

## 2. Link code on GitHub

```
https://github.com/rodacato/stockerly
```

## 3. Link code from your computer

Drag the single folder: [`docs/design/`](.)

Contains `brand.md`, `tokens.md`, `components.md` + canonical SVGs. Do NOT drag `app/views/` or `app/assets/tailwind/application.css` — the current CSS has the pre-Lumen palette and would contaminate mockups. The GitHub link covers ERB partial context if needed.

## 4. Upload a .fig file

Skip. No Figma source exists.

## 5. Add fonts, logos and assets

Drag (in order):

- [`docs/design/wordmark.svg`](./wordmark.svg)
- [`docs/design/glyph.svg`](./glyph.svg)
- [`docs/design/glyph_thick.svg`](./glyph_thick.svg)

> Do **not** upload the `public/*.svg` icons (`favicon`, `icon-192`, `icon-512`, `logo_light`, `logo_dark`). They are pre-Lumen and will be re-synced from the canonical SVGs above as a separate task before beta. Uploading them now would feed contradictory logo assets to the visual tool.

**Fonts: do NOT upload.** Plus Jakarta Sans + Inter + JetBrains Mono are Google Fonts; loading instructions live in the Notes field below.

## 6. Any other notes? — paste verbatim

```
SOURCE OF TRUTH: The Lumen brand kit in docs/design/ is the authoritative spec.
The currently-deployed Tailwind theme in app/assets/tailwind/application.css
is mid-migration and still uses pre-Lumen values (#005A98). IGNORE those —
always generate mockups with the Lumen tokens listed below.

PALETTE (Lumen — light / dark):
- primary: #5B6CFF / #7B89FF (the only chrome accent)
- bg.canvas: #FAFAF7 / #1A1B23 (warm cream, never pure white; warm dark, never slate)
- bg.surface: #FFFFFF / #23242E (cards, modals)
- fg.default: #0F172A / #F8FAFC | fg.subtle: #64748B / #94A3B8
- border.default: #E7E3D9 / #33353F
- positive: #10B981 / #34D399 (gains only)
- negative: #F43F5E / #FB7185 (losses only)
- warning: #F59E0B / #FBBF24
- info ≡ primary (one accent, semantic alias)

TYPOGRAPHY (Google Fonts):
- Display + headings: Plus Jakarta Sans (600, 700)
- Body + UI: Inter (400, 500)
- All numbers (prices, %, KPIs, table cells): JetBrains Mono (500) — NON-NEGOTIABLE
  for column alignment in dense tables

LOGO: Focal frame — four L-bracket corners around a weighted dot. Square viewBox.
Uses currentColor so it inherits CSS color for light/dark. Never restack vertically.

VOICE — DESCRIPTIVE, NEVER PRESCRIPTIVE:
- ✅ "AAPL appears oversold per RSI(14)" / "CETE 28D matures in 5 days"
- ❌ "Buy AAPL now" / "Consider selling" / "Smart investors choose..."
Applies to buttons, empty states, errors, chart annotations.

UI COPY: es-MX, sober, no exclamation marks. Examples:
- Greeting: "Buenas tardes, <nombre>." (NEVER "Hola!" or "Welcome back")
- Open positions: "Posiciones abiertas" | Closed: "Posiciones cerradas"
- Empty (no positions): "Aún no hay posiciones registradas."
- Empty (no alerts): "Sin alertas activas."
- Loading: "Sincronizando..."
- Error retryable: "No pudimos cargar esta sección. Reintentar."
- Delete confirm: "Eliminar esta posición de forma permanente." (statement, not question)
- Currency MXN: "MXN 47,210.45" (ISO + space, no $ symbol on tables)
- Currency USD: "USD 2,418.30"
- Missing value: "—" (em dash, NEVER "0.00" or "N/A")
- Date stamp: "MIÉ · 14 MAY 2026 · 14:08 CDMX"

VISUAL PRINCIPLES:
- Data before decoration. Numbers/charts get focal weight; chrome stays quiet.
- Generous whitespace, dense data tables (the contrast is intentional).
- Sharp typography, soft shadows. shadow.sm on cards is enough; nothing glows.
- Light AND dark are first-class. Always render both — light is the default.
- Both renders required: NEVER show only one mode in a mockup.

DATA REALISM IN MOCKUPS — use real symbology:
- MX: WALMEX.MX, GMEXICOB.MX, CEMEXCPO.MX, FEMSAUBD.MX, IVVPESO.MX
- US: AAPL, NVDA, MSFT, GOOGL, TSLA
- Fixed income MX: CETE28D, CETE91D, CETE182D, CETE364D
- Crypto: BTC, ETH, SOL
- Mixed MXN+USD totals are part of the brand — show both currencies side-by-side

EXPLICITLY AVOID:
- Bloomberg-terminal overwhelm (six-column orange-on-black walls)
- Corporate-bank-blue (saturated navy + gold)
- Fake social proof (imaginary stats, fake testimonials)
- Neon greens (#00FF00) / magentas / saturated accents
- Mascot characters, illustrations, achievement badges, streaks
- Carousels, sticky "buy now" CTAs, animated number tickers
- A third accent color — Lumen has ONE chrome accent (indigo) + 2 semantic (green/red)

DARK MODE: must be genuinely warm-dark (#1A1B23 family), not slate-cold-dark.
Shadows in dark use inset highlight + stronger main shadow for depth without flatness.

COMPONENTS BUILT (use these names when referencing): Button (4 variants:
primary/secondary/ghost/danger), Card, KpiCard, Badge (status/severity/currency/
data-freshness), DataTable (font-mono numeric cells, aria-sort, hover zebra),
EmptyState, Skeleton, Sparkline, DonutChart, FormField.

AUDIENCE: sophisticated MX individual investor reviewing portfolio on a weekend
morning. Reads charts fluently. Skeptical of marketing language. Self-hosting means
they don't trust SaaS with their financial data.
```

---

## 7. Defaults for the per-design questionnaire

Memorize this row — applies to ~90% of sprint prompts:

| Question | Stockerly default |
|---|---|
| ¿Tipo de pieza? | **Nueva pantalla del producto (mockup hi-fi)** |
| ¿Superficie? | **Desktop web** (mobile is a separate audit) |
| ¿Modo? | **Ambos (con toggle)** — always, no exception |
| ¿Cuántas variaciones? | **1 (versión definitiva)** — sprint pace, not exploration |
| ¿Dimensiones a variar? | *N/A when variations=1, leave empty* |
| ¿Apego al sistema? | **Mayormente estricto, una o dos ideas nuevas** |

## 8. Per-design prompt template

Stop pasting full issue bodies into "¿Sobre qué? Cuéntame el caso de uso". Paste this template instead and fill it:

```
Pantalla: <name, e.g. "Watchlist — detail view with sparklines">
Caso de uso (1-2 frases): <what the user does here, in Spanish>
Datos a mostrar: <real MX+USD symbols, e.g. WALMEX.MX, AAPL, CETE28D>
Estado(s) a renderizar: <happy | empty | loading | error | mixed>
Referencia: <issue URL if applicable, e.g. github.com/rodacato/stockerly/issues/77>
```

The brand kit in the Notes field carries the heavy context. The per-design prompt only carries what changes per screen.

---

## When to re-sync the design system in Claude Design

- After any sprint that ships changes to `brand.md`, `tokens.md`, or `components.md` (the spec source of truth).
- When the Lumen migration completes in `app/assets/tailwind/application.css` (the SOURCE OF TRUTH paragraph in §6 notes will need updating — remove the "IGNORE pre-Lumen" warning).
- When new components are promoted into the catalog (per [`components.md`](./components.md) §5 promotion rule).
- When a new logo or palette variant ships (rare; would also require new entries in [`brand.md`](./brand.md) §11).

## When NOT to re-sync

- Per-screen tweaks, single-component bug fixes, color audits — too small to trigger a re-sync. The cost is opportunity cost on next mockup generation.
