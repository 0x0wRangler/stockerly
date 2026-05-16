# Stockerly Brand Kit · v1.0

> **Palette:** Lumen &middot; **Logo:** Concept 03 — Focal frame
> Closed beta · self-hosted · 2026.05.14

Portable single-file version of the brand kit, kept as a copy-pasteable artifact for external visual AI tools (Claude Design, Stitch, Figma AI, v0). The split-file canonical sources live at [`brand.md`](./brand.md), [`tokens.md`](./tokens.md), and [`components.md`](./components.md). Keep this file in sync when those change — diff against the internal docs at sprint close.

See [`claude-design-setup.md`](./claude-design-setup.md) for the 8-step bundle that operationalizes this content.

---

## 1. Color Tokens

### 1.1 Token table

| Token | Light | Dark |
|---|---|---|
| `color.primary` | `#5B6CFF` | `#7B89FF` |
| `color.primary.hover` | `#4757E3` | `#9098FF` |
| `color.primary.muted` | `#EEF0FF` | `#2A2E55` |
| `color.bg.canvas` | `#FAFAF7` | `#1A1B23` |
| `color.bg.surface` | `#FFFFFF` | `#23242E` |
| `color.bg.muted` | `#F4F2EC` | `#2B2D38` |
| `color.fg.default` | `#0F172A` | `#F8FAFC` |
| `color.fg.subtle` | `#64748B` | `#94A3B8` |
| `color.fg.inverse` | `#FFFFFF` | `#0F172A` |
| `color.border.default` | `#E7E3D9` | `#33353F` |
| `color.border.strong` | `#D6D1C4` | `#3E414C` |
| `color.positive` | `#10B981` | `#34D399` |
| `color.positive.bg` | `#ECFDF5` | `#0F2E25` |
| `color.negative` | `#F43F5E` | `#FB7185` |
| `color.negative.bg` | `#FFF1F3` | `#3A1620` |
| `color.warning` | `#F59E0B` | `#FBBF24` |
| `color.warning.bg` | `#FFFBEB` | `#3A2A0C` |
| `color.info` | `#5B6CFF` | `#7B89FF` |
| `color.info.bg` | `#EEF0FF` | `#2A2E55` |

Notes:
- `primary` is lifted to `#7B89FF` in dark mode to maintain ≥4.5:1 contrast against `bg.canvas`.
- `positive.bg` / `negative.bg` / `warning.bg` in dark mode are deep, low-chroma fills — not just the light value inverted — so that `.bg` swatches don't glow against `surface`.
- `info` is aliased to `primary` — Stockerly only has one accent. Aliased so consumer code can stay semantically clear.

### 1.2 Tailwind CSS 4 `@theme` block

```css
@import "tailwindcss";

/* Stockerly · Lumen — light is the default theme. */
@theme {
  --color-primary:           #5B6CFF;
  --color-primary-hover:     #4757E3;
  --color-primary-muted:     #EEF0FF;

  --color-bg-canvas:         #FAFAF7;
  --color-bg-surface:        #FFFFFF;
  --color-bg-muted:          #F4F2EC;

  --color-fg-default:        #0F172A;
  --color-fg-subtle:         #64748B;
  --color-fg-inverse:        #FFFFFF;

  --color-border-default:    #E7E3D9;
  --color-border-strong:     #D6D1C4;

  --color-positive:          #10B981;
  --color-positive-bg:       #ECFDF5;
  --color-negative:          #F43F5E;
  --color-negative-bg:       #FFF1F3;
  --color-warning:           #F59E0B;
  --color-warning-bg:        #FFFBEB;
  --color-info:              #5B6CFF;
  --color-info-bg:           #EEF0FF;
}

/* Dark mode overrides — toggled via `html.dark` (Tailwind 4 darkMode: class). */
@layer base {
  :where(html.dark, [data-theme="dark"]) {
    --color-primary:        #7B89FF;
    --color-primary-hover:  #9098FF;
    --color-primary-muted:  #2A2E55;

    --color-bg-canvas:      #1A1B23;
    --color-bg-surface:     #23242E;
    --color-bg-muted:       #2B2D38;

    --color-fg-default:     #F8FAFC;
    --color-fg-subtle:      #94A3B8;
    --color-fg-inverse:     #0F172A;

    --color-border-default: #33353F;
    --color-border-strong:  #3E414C;

    --color-positive:       #34D399;
    --color-positive-bg:    #0F2E25;
    --color-negative:       #FB7185;
    --color-negative-bg:    #3A1620;
    --color-warning:        #FBBF24;
    --color-warning-bg:     #3A2A0C;
    --color-info:           #7B89FF;
    --color-info-bg:        #2A2E55;
  }
}
```

---

## 2. Typography Scale

| Role | Family | Weight | Size | Line-height | Letter-spacing |
|---|---|---|---|---|---|
| Display | Plus Jakarta Sans | 700 | 40px / 2.5rem | 1.1 | -0.030em |
| H1 | Plus Jakarta Sans | 700 | 28px / 1.75rem | 1.15 | -0.025em |
| H2 | Plus Jakarta Sans | 600 | 22px / 1.375rem | 1.2 | -0.020em |
| H3 | Plus Jakarta Sans | 600 | 18px / 1.125rem | 1.3 | -0.015em |
| Body | Inter | 400 | 14px / 0.875rem | 1.55 | -0.005em |
| Body strong | Inter | 500 | 14px / 0.875rem | 1.55 | -0.005em |
| Caption | Inter | 400 | 12px / 0.75rem | 1.50 | 0 |
| Numeric | JetBrains Mono | 500 | 14px / 0.875rem | 1.40 | -0.005em |

Font loading:

```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
  rel="stylesheet"
  href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@500;600;700&family=Inter:wght@400;500;600&family=JetBrains+Mono:wght@400;500&display=swap"
>
```

CSS family tokens (Tailwind 4):

```css
@theme {
  --font-display: "Plus Jakarta Sans", ui-sans-serif, system-ui, sans-serif;
  --font-sans:    "Inter", ui-sans-serif, system-ui, sans-serif;
  --font-mono:    "JetBrains Mono", ui-monospace, SFMono-Regular, monospace;
}
```

---

## 3. Other Design Tokens

### 3.1 Border radius

| Token | px |
|---|---|
| `radius.sm` | 6 |
| `radius.md` | 9 |
| `radius.lg` | 12 |
| `radius.xl` | 16 |
| `radius.full` | 9999 |

### 3.2 Shadow scale

| Token | Light | Dark |
|---|---|---|
| `shadow.sm` | `0 1px 2px rgba(20, 18, 12, 0.05)` | `0 0 0 1px rgba(255, 255, 255, 0.03), 0 2px 6px rgba(0, 0, 0, 0.40)` |
| `shadow.md` | `0 1px 2px rgba(20, 18, 12, 0.04), 0 8px 24px rgba(20, 18, 12, 0.05)` | `inset 0 1px 0 rgba(255, 255, 255, 0.03), 0 12px 32px rgba(0, 0, 0, 0.45)` |
| `shadow.lg` | `0 4px 12px rgba(20, 18, 12, 0.06), 0 24px 48px rgba(20, 18, 12, 0.08)` | `inset 0 1px 0 rgba(255, 255, 255, 0.04), 0 24px 60px rgba(0, 0, 0, 0.55)` |

### 3.3 Spacing scale

**Tailwind defaults.** (`spacing[0..96]`, base unit `0.25rem`). No custom additions.

---

## 4. Logo SVGs

### 4.1 Wordmark — light mode

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 40" fill="currentColor" role="img" aria-label="Stockerly"><g transform="translate(2 8) scale(.375)" fill="none" stroke="currentColor" stroke-width="7" stroke-linecap="round" stroke-linejoin="round"><path d="M10 22V10h12"/><path d="M42 10h12v12"/><path d="M10 42v12h12"/><path d="M42 54h12v-12"/><circle cx="32" cy="32" r="5" fill="currentColor" stroke="none"/></g><text x="32" y="27" font-family="Plus Jakarta Sans,system-ui,sans-serif" font-weight="700" font-size="22" letter-spacing="-0.55">stockerly</text></svg>
```

### 4.2 Wordmark — dark mode

Identical to 4.1 — `currentColor` lets the CSS `color` flip the entire mark. Provided here for asset-manifest completeness:

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 40" fill="currentColor" role="img" aria-label="Stockerly"><g transform="translate(2 8) scale(.375)" fill="none" stroke="currentColor" stroke-width="7" stroke-linecap="round" stroke-linejoin="round"><path d="M10 22V10h12"/><path d="M42 10h12v12"/><path d="M10 42v12h12"/><path d="M42 54h12v-12"/><circle cx="32" cy="32" r="5" fill="currentColor" stroke="none"/></g><text x="32" y="27" font-family="Plus Jakarta Sans,system-ui,sans-serif" font-weight="700" font-size="22" letter-spacing="-0.55">stockerly</text></svg>
```

### 4.3 Glyph (favicon-ready, square viewBox) — light mode

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" fill="none" stroke="currentColor" stroke-width="5" stroke-linecap="round" stroke-linejoin="round" role="img" aria-label="Stockerly"><path d="M10 22V10h12"/><path d="M42 10h12v12"/><path d="M10 42v12h12"/><path d="M42 54h12v-12"/><circle cx="32" cy="32" r="5" fill="currentColor" stroke="none"/></svg>
```

### 4.4 Glyph — dark mode

Identical to 4.3 — `currentColor`:

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" fill="none" stroke="currentColor" stroke-width="5" stroke-linecap="round" stroke-linejoin="round" role="img" aria-label="Stockerly"><path d="M10 22V10h12"/><path d="M42 10h12v12"/><path d="M10 42v12h12"/><path d="M42 54h12v-12"/><circle cx="32" cy="32" r="5" fill="currentColor" stroke="none"/></svg>
```

### 4.5 Favicon-thicken variant (16-px stress)

When the glyph above is rasterized below ~24 px, bracket strokes break up. Use this thickened variant for the `<link rel="icon" sizes="16x16">` slot:

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" fill="none" stroke="currentColor" stroke-width="8" stroke-linecap="round" stroke-linejoin="round" role="img" aria-label="Stockerly"><path d="M8 22V8h14"/><path d="M42 8h14v14"/><path d="M8 42v14h14"/><path d="M42 56h14v-14"/><circle cx="32" cy="32" r="9" fill="currentColor" stroke="none"/></svg>
```

Notes on the wordmark:
- The `<text>` element relies on **Plus Jakarta Sans 700** being available at render time. For pipelines that can't guarantee the font (email signatures, social share previews, third-party embeds), convert the text to paths at build time — `npx svgo` won't do this, use `npx oslllo-svg-fixer` or `fontello` outline conversion.
- The lockup is **glyph 24 px tall, 8 px gap, wordmark cap-aligned to top of brackets**. Don't restack vertically — the brackets need horizontal context to read as a frame.
- Minimum clearspace = height of the glyph on all sides.

---

## 5. Naming + Decision Record

**Palette: Lumen.** Warm cream backgrounds + indigo accent. Chosen because the audience is sophisticated MX individual investors, not a trading floor — Lumen sits closer to Mercury / Notion than to Bloomberg, which matches Stockerly's "calm, descriptive" voice. Cipher was a close second and may return for a future "pro mode"; Bourse read too institutional for a self-hosted personal tool.

**Logo: Concept 03 — Focal frame.** Four L-bracket corners around a single weighted point. The metaphor is observation, not transaction — which lines up with the descriptive copy convention ("AAPL appears oversold", never "Buy AAPL"). The mark is the only sub-32-pixel candidate that doesn't collapse into a generic letterform; the geometric monogram lost crispness at 16 px and the doji lockup leaned too pre-IPO-startup.

**Rationale, one line:** Picked Lumen + Focal frame because the combination reads "considered, calm, tracking tool" — never "trading platform" — which is exactly what a closed-beta personal portfolio app for friends needs to communicate.
