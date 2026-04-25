import 'package:dexpro/core/config/app_constants.dart';
import 'package:dexpro/core/models/navigation_item.dart';
import 'package:dexpro/core/models/online_competition.dart';
import 'package:dexpro/core/models/pokemon.dart' as dex;
import 'package:dexpro/core/models/pokemon_list_item.dart';
import 'package:dexpro/core/models/season.dart';

enum AppRouteKind {
  events,
  pokemonDex,
  abilityDex,
  moveDex,
  itemDex,
  weaknessChart,
  teamBuilder,
  evsToChampionStats,
  speedComparator,
  pokemonDetails,
  seasonDetails,
  onlineCompetitionDetails,
  notFound,
}

class AppBreadcrumb {
  const AppBreadcrumb({
    required this.label,
    required this.path,
    this.isCurrent = false,
  });

  final String label;
  final String path;
  final bool isCurrent;
}

class AppRouteData {
  const AppRouteData({
    required this.kind,
    required this.location,
    required this.analyticsTitle,
    this.originalLocation,
    this.slug,
    this.form,
  });

  final AppRouteKind kind;
  final String location;
  final String analyticsTitle;
  final String? originalLocation;
  final String? slug;
  final String? form;

  bool get shouldCanonicalize =>
      originalLocation != null && originalLocation != location;

  bool get isTopLevel => switch (kind) {
    AppRouteKind.events ||
    AppRouteKind.pokemonDex ||
    AppRouteKind.abilityDex ||
    AppRouteKind.moveDex ||
    AppRouteKind.itemDex ||
    AppRouteKind.weaknessChart ||
    AppRouteKind.teamBuilder ||
    AppRouteKind.evsToChampionStats ||
    AppRouteKind.speedComparator => true,
    _ => false,
  };

  String get selectedNavigationPath {
    if (isTopLevel) {
      return location;
    }

    return switch (kind) {
      AppRouteKind.pokemonDetails => '/pokemon',
      AppRouteKind.seasonDetails ||
      AppRouteKind.onlineCompetitionDetails ||
      AppRouteKind.notFound => '',
      _ => '/events',
    };
  }

  List<AppBreadcrumb> get breadcrumbs {
    final List<AppBreadcrumb> result = <AppBreadcrumb>[];
    final String parentPath = selectedNavigationPath;
    if (parentPath.isNotEmpty) {
      final String parentLabel = _labelForPath(parentPath);
      result.add(
        AppBreadcrumb(
          label: parentLabel,
          path: parentPath,
          isCurrent: isTopLevel,
        ),
      );
    }

    if (!isTopLevel) {
      result.add(
        AppBreadcrumb(label: analyticsTitle, path: location, isCurrent: true),
      );
    }

    return result;
  }

  static AppRouteData parse(String? rawLocation) {
    final String incomingLocation = _normalizeIncomingLocation(rawLocation);
    final Uri uri = Uri.parse(incomingLocation);
    final List<String> segments = uri.pathSegments
        .where((String segment) => segment.isNotEmpty)
        .toList(growable: false);
    if (segments.isEmpty) {
      return const AppRouteData(
        kind: AppRouteKind.events,
        location: '/events',
        originalLocation: '/',
        analyticsTitle: 'Seasons & Events',
      );
    }

    final String firstSegment = segments.first;

    if (firstSegment == 'events') {
      return _parseEventsRoute(segments, originalLocation: incomingLocation);
    }

    if (firstSegment == 'seasons-events') {
      return const AppRouteData(
        kind: AppRouteKind.events,
        location: '/events',
        originalLocation: '/seasons-events',
        analyticsTitle: 'Seasons & Events',
      );
    }

    if (firstSegment == 'pokemon-dex') {
      return const AppRouteData(
        kind: AppRouteKind.pokemonDex,
        location: '/pokemon',
        originalLocation: '/pokemon-dex',
        analyticsTitle: 'Pokémon Dex',
      );
    }

    if (firstSegment == 'pokemon') {
      if (segments.length == 1) {
        return const AppRouteData(
          kind: AppRouteKind.pokemonDex,
          location: '/pokemon',
          analyticsTitle: 'Pokémon Dex',
        );
      }

      if (segments.length > 2) {
        return AppRouteData.notFound(incomingLocation);
      }

      return _pokemonRoute(
        slug: segments[1],
        originalLocation: incomingLocation,
      );
    }

    if (firstSegment == 'ability-dex') {
      return const AppRouteData(
        kind: AppRouteKind.abilityDex,
        location: '/ability-dex',
        analyticsTitle: 'Ability Dex',
      );
    }

    if (firstSegment == 'move-dex') {
      return const AppRouteData(
        kind: AppRouteKind.moveDex,
        location: '/move-dex',
        analyticsTitle: 'Move Dex',
      );
    }

    if (firstSegment == 'item-dex') {
      return const AppRouteData(
        kind: AppRouteKind.itemDex,
        location: '/item-dex',
        analyticsTitle: 'Item Dex',
      );
    }

    if (firstSegment == 'weakness-chart') {
      return const AppRouteData(
        kind: AppRouteKind.weaknessChart,
        location: '/weakness-chart',
        analyticsTitle: 'Weakness Chart',
      );
    }

    if (firstSegment == 'team-builder') {
      return const AppRouteData(
        kind: AppRouteKind.teamBuilder,
        location: '/team-builder',
        analyticsTitle: 'Team Builder',
      );
    }

    if (firstSegment == 'evs-to-champion-stats') {
      return const AppRouteData(
        kind: AppRouteKind.evsToChampionStats,
        location: '/evs-to-champion-stats',
        analyticsTitle: 'EVs to Champion Stats',
      );
    }

    if (firstSegment == 'speed-comparator') {
      return const AppRouteData(
        kind: AppRouteKind.speedComparator,
        location: '/speed-comparator',
        analyticsTitle: 'Speed Comparator',
      );
    }

    if (firstSegment == 'seasons' && segments.length >= 2) {
      return _seasonRoute(
        slug: segments[1],
        originalLocation: incomingLocation,
      );
    }

    if (firstSegment == 'online-competitions' && segments.length >= 2) {
      return _competitionRoute(
        slug: segments[1],
        originalLocation: incomingLocation,
      );
    }

    return AppRouteData.notFound(incomingLocation);
  }

  static AppRouteData pokemonDetails(String slug) {
    return _pokemonRoute(slug: slug);
  }

  static AppRouteData seasonDetails(String slug) {
    return _seasonRoute(slug: slug);
  }

  static AppRouteData onlineCompetitionDetails(String slug) {
    return _competitionRoute(slug: slug);
  }

  static AppRouteData notFound(String location) {
    return AppRouteData(
      kind: AppRouteKind.notFound,
      location: location,
      originalLocation: location,
      analyticsTitle: '400 Error',
    );
  }

  static AppRouteData _parseEventsRoute(
    List<String> segments, {
    required String originalLocation,
  }) {
    if (segments.length == 1) {
      return const AppRouteData(
        kind: AppRouteKind.events,
        location: '/events',
        analyticsTitle: 'Seasons & Events',
      );
    }

    if (segments.length >= 3) {
      switch (segments[1]) {
        case 'season':
          return _seasonRoute(
            slug: segments[2],
            originalLocation: originalLocation,
          );
        case 'competition':
          return _competitionRoute(
            slug: segments[2],
            originalLocation: originalLocation,
          );
        case 'news':
          return AppRouteData.notFound(originalLocation);
      }
    }

    return const AppRouteData(
      kind: AppRouteKind.events,
      location: '/events',
      analyticsTitle: 'Seasons & Events',
    );
  }

  static AppRouteData _pokemonRoute({
    required String slug,
    String? originalLocation,
  }) {
    final PokemonRouteTarget? routeTarget = pokemonRouteTargetFromSlug(slug);
    if (routeTarget == null) {
      return AppRouteData.notFound(originalLocation ?? '/pokemon/$slug');
    }

    return AppRouteData(
      kind: AppRouteKind.pokemonDetails,
      location: '/pokemon/${routeTarget.routeSlug}',
      originalLocation: originalLocation,
      slug: routeTarget.routeSlug,
      form: routeTarget.form,
      analyticsTitle: routeTarget.entry.displayName,
    );
  }

  static AppRouteData _seasonRoute({
    required String slug,
    String? originalLocation,
  }) {
    final Season? season = seasonFromSlug(slug);
    return season == null
        ? AppRouteData.notFound(originalLocation ?? '/events/season/$slug')
        : AppRouteData(
            kind: AppRouteKind.seasonDetails,
            location: '/events/season/$slug',
            originalLocation: originalLocation,
            slug: slug,
            analyticsTitle: season.name,
          );
  }

  static AppRouteData _competitionRoute({
    required String slug,
    String? originalLocation,
  }) {
    final OnlineCompetition? competition = onlineCompetitionFromSlug(slug);
    return competition == null
        ? AppRouteData.notFound(originalLocation ?? '/events/competition/$slug')
        : AppRouteData(
            kind: AppRouteKind.onlineCompetitionDetails,
            location: '/events/competition/$slug',
            originalLocation: originalLocation,
            slug: slug,
            analyticsTitle: competition.name,
          );
  }
}

class PokemonRouteTarget {
  const PokemonRouteTarget({
    required this.routeSlug,
    required this.baseSlug,
    required this.entry,
    this.form,
  });

  final String routeSlug;
  final String baseSlug;
  final String? form;
  final PokemonListItem entry;
}

String slugify(String value) {
  final String lower = value.toLowerCase();
  final String cleaned = lower.replaceAll(RegExp(r'[^a-z0-9]+'), '-');
  return cleaned.replaceAll(RegExp(r'^-+|-+$'), '');
}

Season? seasonFromSlug(String slug) {
  for (final Season season in seasons) {
    if (slugify(season.name) == slug) {
      return season;
    }
  }

  return null;
}

OnlineCompetition? onlineCompetitionFromSlug(String slug) {
  for (final OnlineCompetition competition in onlineCompetitions) {
    if (slugify(competition.name) == slug) {
      return competition;
    }
  }

  return null;
}

String _normalizeIncomingLocation(String? rawLocation) {
  if (rawLocation == null || rawLocation.trim().isEmpty) {
    return '/';
  }

  return rawLocation;
}

String _labelForPath(String path) {
  for (final NavigationItem item in navigationItems) {
    if (item.path == path) {
      return item.label;
    }
  }
  return 'Seasons & Events';
}

String pokemonRouteSlugForEntry(PokemonListItem entry) {
  final String baseToken = _baseRouteToken(entry);
  if (entry.pokemon.form == null || entry.pokemon.form!.isEmpty) {
    return baseToken;
  }

  return '${baseToken}_${entry.pokemon.form!.toLowerCase()}';
}

PokemonRouteTarget? pokemonRouteTargetFromSlug(String slug) {
  for (final MapEntry<String, dex.Pokemon> entry in dex.pokemonList.entries) {
    final PokemonListItem baseEntry = PokemonListItem(
      slug: entry.key,
      pokemon: entry.value,
    );
    final List<PokemonListItem> candidates = <PokemonListItem>[
      baseEntry,
      if (entry.value.mega != null) baseEntry.variant(entry.value.mega!),
      if (entry.value.mega2 != null) baseEntry.variant(entry.value.mega2!),
    ];

    for (final PokemonListItem variant in candidates) {
      final String routeSlug = pokemonRouteSlugForEntry(variant);
      if (routeSlug == slug) {
        return PokemonRouteTarget(
          routeSlug: routeSlug,
          baseSlug: _baseRouteToken(variant),
          form: variant.pokemon.form,
          entry: variant,
        );
      }
    }
  }

  return null;
}

String _baseRouteToken(PokemonListItem entry) {
  final String displayName = entry.familyBaseEntry.displayName;
  return displayName.split(' ').first.toLowerCase();
}
