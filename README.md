# UTAW at DeepMind — gdmunion.co.uk

A [Zola](https://www.getzola.org/) static site with a single page, the homepage (`/`). Every push to `main` is built and deployed by
GitHub Actions (`.github/workflows/deploy.yml`) to `www.gdmunion.co.uk`. Zola
writes the build to `public/`, which is gitignored.

Run locally with `zola serve`.

**Most edits are text changes, and the text lives in `content/` and `data/`,
not in the templates.**

## Where to edit

| What you want to change | Edit this |
|---|---|
| Hero title, mission quote, summary, CTA label | `content/_index.md` → `hero_*` (`hero_summary` is the text under the quote) |
| "How to Join" section | `content/_index.md` → `join` |
| "Who We Are" text | `content/_index.md` → `who_we_are_intro` (left column), `who_we_are` (right column), `who_we_are_cta` (link to the join page, left) |
| The demand cards | `data/demands.toml` (`[[demand]]`: `label`, `summary`, `points`, `details` — `details` is optional; without it the card has no "Read the full demand" button) |
| "Can we negotiate…?" intro | `content/_index.md` → `negotiate_intro` |
| Precedent flip-cards ("wins") | `data/precedents.toml` (`headline`, `text`, `image`, `focus`, `union`); images go in `static/precedents/` |
| "Story So Far" timeline / "What Next?" steps | `data/story.toml` (`[[event]]`: `date`, `title`, `text`, `now`; `[[next]]`: `title`, `text`); the "What Next?" intro line is `content/_index.md` → `story_next_intro` |
| FAQ | `data/faqs.toml` (`question`, `topic`, `answer`, optional `id` for links); the topic groups and their order are `topics` at the top of that file |
| "Why We're Doing This" carousel slides | `data/articles.toml` (`title`, `summary`, `url`, `source`, `date`, `image`, `focus`); images go in `static/articles/`. The order is a deliberate story, not chronological. |
| Carousel heading and intro paragraph | Hardcoded in `templates/index.html` (the `.why-static` block) |
| Footer tagline | `content/_index.md` → `footer_tagline`; the default is in `templates/partials/footer.html` |
| Nav links | `templates/partials/nav.html` |
| Join URL | `config.toml` → `extra.join_url` (used by the nav, hero and footer) |
| Contact email | `config.toml` → `extra.contact_email` (shown in the footer; write `{contact_email}` in `data/demands.toml` to insert it) |
| Site title, description, base URL | `config.toml` |

Markdown works in the multi-line `"""` fields and in FAQ answers and demand text.

## Templates (layout and markup)

- **`templates/index.html`**: the homepage. Its sections, in order: hero →
  `#why` carousel → `#who-we-are` → `#demands` (demand cards and precedent
  cards) → `#story-so-far` → `#join` → `#faq` → footer. The `<head>` meta, OG
  and Twitter tags are also here.
- **`templates/partials/nav.html`** and **`footer.html`**: the shared nav and
  footer.
- **`templates/404.html`**: a bare page that doesn't use the shared nav or styles.

## Styling and scripts

- **`static/style.css`**: all global styles, in numbered sections:
  1 variables/colours → 5 nav → 6 hero → 7–9 sections and typography →
  10–11 demands and pop-up → 12 precedent cards → 13 carousel → 14 FAQ →
  15 footer → 16–17 accessibility and motion → 18 responsive.
  Brand colours are custom properties in section 1. The stylesheet is
  cache-busted automatically by a hash in the `<link>` tag.
- **`static/demands.js`**: opens each demand's full text in a `<dialog>`
  pop-up. Without JS the full text is shown inline.
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
