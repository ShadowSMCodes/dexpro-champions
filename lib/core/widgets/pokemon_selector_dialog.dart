import 'dart:math' as math;

import 'package:dexpro/app/routing/app_navigation.dart';
import 'package:dexpro/core/models/pokemon.dart' as dex;
import 'package:dexpro/core/models/pokemon_list_item.dart';
import 'package:dexpro/core/providers/app_details_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<PokemonListItem> buildSelectablePokemonEntries({
  bool includeMegas = true,
}) {
  final List<PokemonListItem> entries =
      dex.pokemonList.entries
          .expand(
            (MapEntry<String, dex.Pokemon> entry) => _expandPokemonEntries(
              PokemonListItem(slug: entry.key, pokemon: entry.value),
              includeMegas: includeMegas,
            ),
          )
          .toList(growable: false)
        ..sort(
          (PokemonListItem a, PokemonListItem b) =>
              a.displayName.compareTo(b.displayName),
        );

  return entries;
}

List<PokemonListItem> _expandPokemonEntries(
  PokemonListItem baseEntry, {
  required bool includeMegas,
}) {
  return <PokemonListItem>[
    baseEntry,
    if (includeMegas && baseEntry.pokemon.mega != null)
      baseEntry.variant(baseEntry.pokemon.mega!),
    if (includeMegas && baseEntry.pokemon.mega2 != null)
      baseEntry.variant(baseEntry.pokemon.mega2!),
  ];
}

Future<PokemonListItem?> showPokemonSelectorDialog(
  BuildContext context, {
  required List<PokemonListItem> pokemon,
  String title = 'Select Pokémon',
}) {
  return showDialog<PokemonListItem>(
    context: context,
    builder: (BuildContext context) {
      return PokemonSelectorDialog(title: title, pokemon: pokemon);
    },
  );
}

class PokemonSelectorDialog extends StatefulWidget {
  const PokemonSelectorDialog({
    super.key,
    required this.title,
    required this.pokemon,
  });

  final String title;
  final List<PokemonListItem> pokemon;

  @override
  State<PokemonSelectorDialog> createState() => _PokemonSelectorDialogState();
}

class _PokemonSelectorDialogState extends State<PokemonSelectorDialog> {
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;
  String _query = '';
  String? _autoSelectedSlug;

  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode();
    _searchController = TextEditingController()
      ..addListener(() {
        setState(() {
          _query = _searchController.text.trim().toLowerCase();
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _maybeAutoSelectSingleResult();
        });
      });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _searchFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isCompact = context.watch<AppDetailsProvider>().isCompact;
    final List<PokemonListItem> filteredPokemon = _filteredPokemon;
    final Size screenSize = MediaQuery.sizeOf(context);
    final double dialogWidth = math.min(screenSize.width * 0.94, 1240);
    final double dialogHeight = math.min(screenSize.height * 0.9, 780);

    return Dialog(
      child: SizedBox(
        width: dialogWidth,
        height: dialogHeight,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontFamily: 'RobotoCondensed',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                    tooltip: 'Close',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.42,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.shadow.withValues(alpha: 0.08),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: SearchBar(
                    focusNode: _searchFocusNode,
                    controller: _searchController,
                    hintText: 'Search Pokémon',
                    leading: const Icon(Icons.search_rounded),
                    trailing: <Widget>[
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          onPressed: _searchController.clear,
                          icon: const Icon(Icons.close_rounded),
                        ),
                    ],
                    backgroundColor: WidgetStatePropertyAll<Color>(
                      theme.colorScheme.surface.withValues(alpha: 0.72),
                    ),
                    elevation: const WidgetStatePropertyAll<double>(0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    const double spacing = 12;
                    final double targetTileWidth = isCompact ? 104 : 132;
                    final int crossAxisCount = math.max(
                      1,
                      (constraints.maxWidth / targetTileWidth).floor(),
                    );
                    final double tileWidth =
                        (constraints.maxWidth -
                            ((crossAxisCount - 1) * spacing)) /
                        crossAxisCount;

                    return GridView.builder(
                      itemCount: filteredPokemon.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: spacing,
                        mainAxisSpacing: spacing,
                        mainAxisExtent: tileWidth,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        final PokemonListItem entry = filteredPokemon[index];

                        return Material(
                          color: theme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.32),
                          borderRadius: BorderRadius.circular(18),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(18),
                            onTap: () => Navigator.of(context).pop(entry),
                            onLongPress: () {
                              Navigator.of(context).pop();
                              openPokemonDetails(context, entry);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Image.asset(
                                      '${entry.assetImagePath}.png',
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (
                                            BuildContext context,
                                            Object error,
                                            StackTrace? stackTrace,
                                          ) => Icon(
                                            Icons.catching_pokemon_rounded,
                                            size: 38,
                                            color: theme.colorScheme.primary,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    entry.displayName,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'RobotoCondensed',
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<PokemonListItem> get _filteredPokemon => widget.pokemon
      .where(
        (PokemonListItem entry) =>
            _query.isEmpty ||
            entry.displayName.toLowerCase().contains(_query) ||
            entry.pokemon.id.toString().contains(_query),
      )
      .toList(growable: false);

  void _maybeAutoSelectSingleResult() {
    if (!mounted || _query.isEmpty) {
      return;
    }

    final List<PokemonListItem> filteredPokemon = _filteredPokemon;
    if (filteredPokemon.length != 1) {
      _autoSelectedSlug = null;
      return;
    }

    final PokemonListItem match = filteredPokemon.first;
    if (_autoSelectedSlug == match.slug) {
      return;
    }

    _autoSelectedSlug = match.slug;
    Navigator.of(context).pop(match);
  }
}
