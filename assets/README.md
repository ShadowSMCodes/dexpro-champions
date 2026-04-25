# DexPro - Champions

DexPro is an unofficial Pokemon Champions web app built with Flutter for web. It includes a Pokemon Dex, team builder, move and item references, weakness charts, and event tracking.

## Version History

### Website Update - 2026-04-24

- Refined clean route handling with canonical `/pokemon/...` URLs for base forms, regional forms, and Mega forms.
- Added an in-shell 400 error page with Mega Dragonite guidance for invalid links.
- Improved drawer UX with collapsible desktop navigation and smoother shell-only page changes.
- Restored mystery gift cards to popup behavior instead of separate routed pages.
- Added an in-app version history popup from the drawer header.

### Website Update - 2026-04-23

- Moved the app to route-based shell navigation so pages can be linked directly without losing the shared layout.
- Added breadcrumbs, browser-friendly URLs, and GitHub Pages SPA fallback handling.
- Expanded SEO metadata and deployment behavior for the live DexPro domain.

### Website Update - 2026-04-19

- Aligned production web builds with `dexpro-app.com` and stabilized GitHub Pages deployment output.
- Improved meta tags, sitemap, robots rules, and search-facing metadata for DexPro.
- Set up the web build to preserve the custom domain and icon assets consistently.
