import 'package:dexpro/app/routing/app_route_data.dart';
import 'package:dexpro/core/models/online_competition.dart';
import 'package:dexpro/core/models/pokemon_list_item.dart';
import 'package:dexpro/core/models/season.dart';
import 'package:dexpro/core/providers/app_details_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

AppRouteData currentRoute(BuildContext context) {
  return context.read<AppDetailsProvider>().routeData;
}

void navigateToTopLevel(BuildContext context, String path) {
  final AppDetailsProvider appDetailsProvider = context
      .read<AppDetailsProvider>();
  if (appDetailsProvider.routeData.location == path) {
    return;
  }

  appDetailsProvider.navigateToPath(path);
}

void openPokemonDetails(BuildContext context, PokemonListItem entry) {
  final AppDetailsProvider appDetailsProvider = context
      .read<AppDetailsProvider>();
  final AppRouteData target = AppRouteData.pokemonDetails(
    pokemonRouteSlugForEntry(entry),
  );

  if (appDetailsProvider.routeData.location == target.location) {
    return;
  }

  appDetailsProvider.navigateTo(target);
}

void openSeasonDetails(BuildContext context, Season season) {
  final AppDetailsProvider appDetailsProvider = context
      .read<AppDetailsProvider>();
  final AppRouteData target = AppRouteData.seasonDetails(slugify(season.name));
  if (appDetailsProvider.routeData.location == target.location) {
    return;
  }
  appDetailsProvider.navigateTo(target);
}

void openOnlineCompetitionDetails(
  BuildContext context,
  OnlineCompetition competition,
) {
  final AppDetailsProvider appDetailsProvider = context
      .read<AppDetailsProvider>();
  final AppRouteData target = AppRouteData.onlineCompetitionDetails(
    slugify(competition.name),
  );
  if (appDetailsProvider.routeData.location == target.location) {
    return;
  }
  appDetailsProvider.navigateTo(target);
}

void goBackOrReplace(BuildContext context, String fallbackPath) {
  context.read<AppDetailsProvider>().navigateToPath(fallbackPath);
}
