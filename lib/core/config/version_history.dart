import 'package:dexpro/core/models/version_history_entry.dart';

const List<VersionHistoryEntry> websiteVersionHistory = <VersionHistoryEntry>[
  VersionHistoryEntry(
    date: '2026-04-24',
    title: 'Website Update',
    updates: <String>[
      'Refined route handling with clean `/pokemon/...` URLs for base forms, regional forms, and Mega forms.',
      'Added an in-shell 400 error page with Mega Dragonite guidance for invalid links.',
      'Improved drawer UX with collapsible desktop navigation and smoother shell-only page changes.',
      'Restored mystery gift cards to popup behavior instead of separate routed pages.',
    ],
  ),
  VersionHistoryEntry(
    date: '2026-04-23',
    title: 'Website Update',
    updates: <String>[
      'Moved the app to route-based shell navigation so pages can be linked directly without losing the shared layout.',
      'Added breadcrumbs, better browser URL support, and GitHub Pages SPA fallback handling.',
      'Expanded SEO metadata and deployment behavior for the live DexPro domain.',
    ],
  ),
  VersionHistoryEntry(
    date: '2026-04-19',
    title: 'Website Update',
    updates: <String>[
      'Aligned production web builds with `dexpro-app.com` and stabilized GitHub Pages deployment output.',
      'Improved meta tags, sitemap, robots rules, and search-facing metadata for DexPro.',
      'Set up the web build to preserve the custom domain and icon assets consistently.',
    ],
  ),
];
