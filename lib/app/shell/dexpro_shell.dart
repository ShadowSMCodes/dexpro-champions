import 'package:dexpro/core/config/app_constants.dart';
import 'package:dexpro/core/models/navigation_item.dart';
import 'package:dexpro/core/models/online_competition.dart';
import 'package:dexpro/core/models/pokemon_list_item.dart';
import 'package:dexpro/core/models/season.dart';
import 'package:dexpro/core/providers/app_details_provider.dart';
import 'package:dexpro/core/providers/theme_provider.dart';
import 'package:dexpro/core/widgets/route_error_page.dart';
import 'package:dexpro/core/utils/analytics_service.dart';
import 'package:dexpro/core/utils/external_link_opener.dart';
import 'package:dexpro/app/routing/app_navigation.dart';
import 'package:dexpro/app/routing/app_route_data.dart';
import 'package:dexpro/features/ability_dex/pages/ability_dex_page.dart';
import 'package:dexpro/features/events/pages/events_page.dart';
import 'package:dexpro/features/events/pages/online_competition_details_page.dart';
import 'package:dexpro/features/item_dex/pages/item_dex_page.dart';
import 'package:dexpro/features/move_dex/pages/move_dex_page.dart';
import 'package:dexpro/features/pokemon_dex/pages/pokemon_details_page.dart';
import 'package:dexpro/features/pokemon_dex/pages/pokemon_list_page.dart';
import 'package:dexpro/features/seasons/pages/season_details_page.dart';
import 'package:dexpro/features/team_builder/pages/team_builder_page.dart';
import 'package:dexpro/features/tools/pages/evs_to_champion_stats_page.dart';
import 'package:dexpro/features/tools/pages/speed_comparator_page.dart';
import 'package:dexpro/features/weakness_chart/pages/weakness_chart_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DexProShell extends StatefulWidget {
  const DexProShell({super.key, required this.routeData});

  final AppRouteData routeData;

  @override
  State<DexProShell> createState() => _DexProShellState();
}

class _DexProShellState extends State<DexProShell> {
  static const List<int> _visibleNavigationIndexes = <int>[
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
  ];

  static final Uri _discordUri = Uri.parse('https://discord.gg/HSfTA4BDCF');
  static final Uri _supportUri = Uri.parse('https://ko-fi.com/shadow_sm');
  String? _lastTrackedPagePath;

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = context.watch<ThemeProvider>();
    final AppDetailsProvider appDetailsProvider = context
        .read<AppDetailsProvider>();
    final AppRouteData routeData = widget.routeData;
    final bool viewportCompact = MediaQuery.sizeOf(context).width < 900;

    if (routeData.shouldCanonicalize) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<AppDetailsProvider>().navigateTo(
            AppRouteData.parse(routeData.location),
          );
        }
      });
    }

    if (appDetailsProvider.isCompact != viewportCompact) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<AppDetailsProvider>().updateIsCompact(viewportCompact);
        }
      });
    }

    final _AnalyticsPage analyticsPage = _AnalyticsPage(
      path: routeData.location,
      title: routeData.analyticsTitle,
    );

    if (_lastTrackedPagePath != analyticsPage.path) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _lastTrackedPagePath == analyticsPage.path) {
          return;
        }

        _lastTrackedPagePath = analyticsPage.path;
        trackPageView(
          pagePath: analyticsPage.path,
          pageTitle: analyticsPage.title,
        );
      });
    }

    return Scaffold(
      appBar: viewportCompact ? AppBar() : null,
      drawer: viewportCompact ? _buildDrawer(context) : null,
      body: Container(
        decoration: BoxDecoration(
          gradient: themeProvider.isDarkMode
              ? null
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    themeProvider.accent.lightBackgroundColor,
                    Colors.white,
                  ],
                ),
        ),
        child: Row(
          children: [
            if (!viewportCompact)
              SizedBox(
                width: 250,
                child: _DesktopNavigationPane(shellState: this),
              ),
            Expanded(
              child: _ShellContentPane(
                routeData: routeData,
                isCompact: viewportCompact,
                currentPage: _buildCurrentPage(routeData),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            _buildDrawerHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  ..._visibleNavigationIndexes.map(
                    (int index) => _buildCompactNavTile(context, index),
                  ),
                ],
              ),
            ),
            _buildSupportTile(context),
            _buildDiscordTile(context),
            _buildThemeToggleTile(context),
            _buildDisclaimerTile(context),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildSideNavigation(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ThemeProvider themeProvider = context.watch<ThemeProvider>();
    final String selectedPath = widget.routeData.selectedNavigationPath;

    return Container(
      decoration: BoxDecoration(
        color: themeProvider.isDarkMode
            ? const Color(0xFF111111)
            : Colors.white,
        border: Border(
          right: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDrawerHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  ..._visibleNavigationIndexes.map(
                    (int index) => _buildExpandedNavTile(
                      context,
                      item: navigationItems[index],
                      selected: selectedPath == navigationItems[index].path,
                      onTap: () => navigateToTopLevel(
                        context,
                        navigationItems[index].path,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildSupportTile(context, compact: false),
            _buildDiscordTile(context, compact: false),
            _buildThemeToggleTile(context, compact: false),
            _buildDisclaimerTile(context, compact: false),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ThemeProvider themeProvider = context.watch<ThemeProvider>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [
              themeProvider.accent.color,
              themeProvider.accent.color.withValues(alpha: 0.72),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/icons/icon.png',
                    width: 36,
                    height: 36,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'DexPro',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'RobotoCondensed',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Tools and Charts for Pokémon Champions',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.88),
                fontFamily: 'RobotoCondensed',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactNavTile(BuildContext context, int index) {
    final NavigationItem item = navigationItems[index];
    return _buildExpandedNavTile(
      context,
      item: item,
      selected: widget.routeData.selectedNavigationPath == item.path,
      onTap: () {
        Navigator.of(context).maybePop();
        navigateToTopLevel(context, item.path);
      },
    );
  }

  Widget _buildExpandedNavTile(
    BuildContext context, {
    required NavigationItem item,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final ThemeProvider themeProvider = context.watch<ThemeProvider>();
    final Color selectedTint = themeProvider.accent.color.withValues(
      alpha: themeProvider.isDarkMode ? 0.28 : 0.16,
    );
    final Color selectedTextColor = themeProvider.isDarkMode
        ? Color.alphaBlend(
            themeProvider.accent.color.withValues(alpha: 0.48),
            Colors.white,
          )
        : Color.alphaBlend(
            Colors.white.withValues(alpha: 0.22),
            themeProvider.accent.color,
          );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        selected: selected,
        selectedTileColor: selectedTint,
        leading: Icon(
          selected ? item.activeIcon : item.icon,
          color: selected ? selectedTextColor : null,
        ),
        title: Text(
          item.label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontSize: 15,
            fontFamily: 'RobotoCondensed',
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? selectedTextColor : null,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildDiscordTile(BuildContext context, {bool compact = true}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(compact ? 12 : 12, 4, compact ? 12 : 16, 4),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        leading: const FaIcon(FontAwesomeIcons.discord, size: 22),
        title: Text(
          'Discord',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontSize: 15,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(Icons.open_in_new_rounded, size: 18),
        onTap: () => _openDiscord(context),
      ),
    );
  }

  Widget _buildSupportTile(BuildContext context, {bool compact = true}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(compact ? 12 : 12, 4, compact ? 12 : 16, 4),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        leading: const Icon(Icons.diamond_rounded),
        title: Text(
          'Support Us!',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontSize: 15,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(Icons.open_in_new_rounded, size: 18),
        onTap: () => _openSupport(context),
      ),
    );
  }

  Widget _buildThemeToggleTile(BuildContext context, {bool compact = true}) {
    final ThemeProvider themeProvider = context.watch<ThemeProvider>();

    return Padding(
      padding: EdgeInsets.fromLTRB(compact ? 12 : 12, 4, compact ? 12 : 16, 4),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        leading: Icon(
          themeProvider.isDarkMode
              ? Icons.light_mode_rounded
              : Icons.dark_mode_rounded,
        ),
        title: Text(
          themeProvider.isDarkMode
              ? 'Turn to Light Theme'
              : 'Turn to Dark Theme',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontSize: 15,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: themeProvider.toggleTheme,
      ),
    );
  }

  Widget _buildDisclaimerTile(BuildContext context, {bool compact = true}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(compact ? 12 : 12, 4, compact ? 12 : 16, 4),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        leading: const Icon(Icons.gavel_rounded),
        title: Text(
          'Disclaimer',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontSize: 15,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: () => _showDisclaimerDialog(context),
      ),
    );
  }

  Widget _buildCurrentPage(AppRouteData routeData) {
    switch (routeData.kind) {
      case AppRouteKind.events:
        return const EventsPage();
      case AppRouteKind.pokemonDex:
        return const PokemonListPage();
      case AppRouteKind.abilityDex:
        return const AbilityDexPage();
      case AppRouteKind.moveDex:
        return const MoveDexPage();
      case AppRouteKind.itemDex:
        return const ItemDexPage();
      case AppRouteKind.weaknessChart:
        return const WeaknessChartPage();
      case AppRouteKind.teamBuilder:
        return const TeamBuilderPage();
      case AppRouteKind.evsToChampionStats:
        return const EvsToChampionStatsPage();
      case AppRouteKind.speedComparator:
        return const SpeedComparatorPage();
      case AppRouteKind.pokemonDetails:
        final PokemonListItem? entry = _pokemonEntryForRoute(routeData);
        if (entry == null) {
          return RouteErrorPage(invalidPath: routeData.location);
        }

        return PokemonDetailsPage(entry: entry);
      case AppRouteKind.seasonDetails:
        final Season? season = routeData.slug == null
            ? null
            : seasonFromSlug(routeData.slug!);
        if (season == null) {
          return RouteErrorPage(invalidPath: routeData.location);
        }

        return SeasonDetailsPage(season: season);
      case AppRouteKind.onlineCompetitionDetails:
        final OnlineCompetition? competition = routeData.slug == null
            ? null
            : onlineCompetitionFromSlug(routeData.slug!);
        if (competition == null) {
          return RouteErrorPage(invalidPath: routeData.location);
        }

        return OnlineCompetitionDetailsPage(competition: competition);
      case AppRouteKind.notFound:
        return RouteErrorPage(invalidPath: routeData.location);
    }
  }

  PokemonListItem? _pokemonEntryForRoute(AppRouteData routeData) {
    final String? slug = routeData.slug;
    if (slug == null) {
      return null;
    }

    return pokemonRouteTargetFromSlug(slug)?.entry;
  }

  Future<void> _openDiscord(BuildContext context) async {
    try {
      final bool launched = await openExternalLink(_discordUri.toString());

      if (!launched && context.mounted) {
        _showDiscordFailure(context);
      }
    } catch (_) {
      if (context.mounted) {
        _showDiscordFailure(context);
      }
    }
  }

  Future<void> _openSupport(BuildContext context) async {
    try {
      final bool launched = await openExternalLink(_supportUri.toString());

      if (!launched && context.mounted) {
        _showThemedSnackBar(context, 'Unable to open support link right now.');
      }
    } catch (_) {
      if (context.mounted) {
        _showThemedSnackBar(context, 'Unable to open support link right now.');
      }
    }
  }

  void _showDiscordFailure(BuildContext context) {
    _showThemedSnackBar(context, 'Unable to open Discord right now.');
  }

  void _showThemedSnackBar(BuildContext context, String message) {
    final ThemeData theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontFamily: 'RobotoCondensed',
          ),
        ),
        duration: const Duration(milliseconds: 1400),
        behavior: SnackBarBehavior.floating,
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Future<void> _showDisclaimerDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      barrierColor: Colors.black87,
      builder: (BuildContext context) {
        final ThemeData theme = Theme.of(context);
        return AlertDialog(
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Text(
              'All Pokémon images, names, characters, and related marks are trademarks and copyright of The Pokémon Company, Nintendo, Game Freak, or Creatures Inc. (“Pokémon Rights Holders”).\n\nDexPro is an unofficial fan site and is not endorsed by or affiliated with Pokémon Rights Holders.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.6,
                fontFamily: 'RobotoCondensed',
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AnalyticsPage {
  const _AnalyticsPage({required this.path, required this.title});

  final String path;
  final String title;
}

class _DesktopNavigationPane extends StatelessWidget {
  const _DesktopNavigationPane({required this.shellState});

  final _DexProShellState shellState;

  @override
  Widget build(BuildContext context) {
    return shellState._buildSideNavigation(context);
  }
}

class _ShellContentPane extends StatelessWidget {
  const _ShellContentPane({
    required this.routeData,
    required this.isCompact,
    required this.currentPage,
  });

  final AppRouteData routeData;
  final bool isCompact;
  final Widget currentPage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.all(isCompact ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BreadcrumbBar(routeData: routeData),
            const SizedBox(height: 12),
            Expanded(child: currentPage),
          ],
        ),
      ),
    );
  }
}

class _BreadcrumbBar extends StatelessWidget {
  const _BreadcrumbBar({required this.routeData});

  final AppRouteData routeData;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<AppBreadcrumb> breadcrumbs = routeData.breadcrumbs;

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4,
      runSpacing: 6,
      children: [
        for (int index = 0; index < breadcrumbs.length; index++) ...[
          if (index > 0)
            Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          if (breadcrumbs[index].isCurrent)
            Text(
              breadcrumbs[index].label,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.onSurfaceVariant,
                fontFamily: 'RobotoCondensed',
              ),
            )
          else
            TextButton(
              onPressed: () =>
                  navigateToTopLevel(context, breadcrumbs[index].path),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                breadcrumbs[index].label,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'RobotoCondensed',
                ),
              ),
            ),
        ],
      ],
    );
  }
}
