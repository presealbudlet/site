# UTAW at DeepMind — gdmunion.co.uk

A [Zola](https://www.getzola.org/) static site with two pages: the homepage (`/`)
and the Archive (`/archive/`). Every push to `main` is built and deployed by
GitHub Actions (`.github/workflows/deploy.yml`) to `www.gdmunion.co.uk`. Zola
writes the build to `public/`, which is gitignored.

Run locally with `zola serve`.

**Most edits are text changes, and the text lives in `content/` and `data/`,
not in the templates.**

## Where to edit

| What you want to change | Edit this |
|---|---|
| Hero title, mission quote, CTA label | `content/_index.md` → `hero_*` |
| TL;DR text | `content/_index.md` → `tldr_lead`, `tldr` |
| "Who We Are" text | `content/_index.md` → `who_we_are` |
| Demands intro and status note | `content/_index.md` → `demands_intro`, `demands_note` (the `{join_url}` placeholder gets replaced) |
| The three demand pillars | `data/demands.toml` (`[[demand]]`: `label`, `text`) |
| "Can we negotiate…?" intro | `content/_index.md` → `negotiate_intro` |
| Precedent flip-cards ("wins") | `data/precedents.toml` (`headline`, `text`, `image`, `focus`, `union`); images go in `static/precedents/` |
| "Story So Far" / "What Next?" | `content/_index.md` → `story_intro`, `story_next` |
| FAQ | `content/_index.md` → `faq_intro`; entries in `data/faqs.toml` (`question`, `answer`) |
| "Why We're Doing This" carousel slides | `data/articles.toml` (`title`, `summary`, `url`, `source`, `date`, `image`, `focus`); images go in `static/articles/`. The order is a deliberate story, not chronological. |
| Carousel heading and intro paragraph | Hardcoded in `templates/index.html` (the `.why-static` block) |
| Archive page intro | `content/archive/_index.md` → `intro` |
| Archive table rows | `data/archive.toml` (`date`, `title`, `url`, `source`, `summary`, `theme`, `sev`), kept **newest first** |
| Footer tagline | `content/_index.md` → `footer_tagline`; the default is in `templates/partials/footer.html` |
| Nav links | `templates/partials/nav.html` |
| Join URL | `config.toml` → `extra.join_url` (used by the nav and footer) **and** `content/_index.md` → `join_url` (used by the hero and demands note). Update both. |
| Site title, description, base URL | `config.toml` |

Markdown works in the multi-line `"""` fields and in FAQ answers and demand text.

## Templates (layout and markup)

- **`templates/index.html`**: the homepage. Its sections, in order: hero →
  TL;DR → `#why` carousel → `#who-we-are` → `#demands` (pillars and precedent
  cards) → `#story-so-far` → `#faq` → footer. The `<head>` meta, OG and Twitter
  tags are also here.
- **`templates/archive.html`**: the Archive page. Besides markup, it contains:
  - **inline `<style>`** for the timeline map (`.am-*` classes);
  - **inline `<script>`** that draws the theme timeline from the table rows and
    filters them. The theme names and colours are in the `THEMES` array there.
    If you add a new `theme` value in `archive.toml`, add it to that array too.
    The "Feb 2025 — pledge dropped" marker is also set in that script;
  - placeholder lorem-ipsum summaries, shown for any row without a `summary`.
- **`templates/partials/nav.html`** and **`footer.html`**: shared by both pages.
  Set `nav_current = "archive"` before including the nav to highlight the
  active link.
- **`templates/404.html`**: a bare page that doesn't use the shared nav or styles.

## Styling and scripts

- **`static/style.css`**: all global styles, in numbered sections:
  1 variables/colours → 5 nav → 6 hero → 7–11 sections and typography →
  demands → precedent cards → carousel → 12 FAQ → 13 footer →
  14–15 accessibility and motion → 16 responsive → archive page and table.
  Brand colours are custom properties in section 1. The stylesheet is
  cache-busted automatically by a hash in the `<link>` tag.
- **`static/carousel.js`**: behaviour for the homepage carousel (7s autoplay,
  controls, swipe). It's a progressive enhancement, so the first slide still
  shows without JS.

## Assets and other files

- `static/`: logos, favicons, `og-image.png`, and the `articles/` and
  `precedents/` images.
- `brand/og-image.html`: the source for `og-image.png`. Render it at 1200×630
  to regenerate the image. `brand/utaw-logo.svg` is the source logo.
- `static/robots.txt`, `static/ai.txt` and `static/.well-known/`: these block AI
  crawlers and deliberately *allow* search crawlers so they can see the
  `noindex` tag. The comments in `robots.txt` explain why it shouldn't be
  changed to `Disallow: /`.
- `static/4efff1c7fd/`: redirect stubs from an old URL path to `/`.
- `CNAME` (root, `gdmunion.co.uk`) and `static/CNAME` (`www.gdmunion.co.uk`)
  are for domain setup.

## Not yet wired up

- `data/updates.toml` and `whats_new_intro`: no template uses either, so the
  "What's New" carousel isn't on the page yet.
- `hero_reason` in `content/_index.md`: also not used by any template.
