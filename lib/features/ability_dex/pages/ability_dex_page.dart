import 'package:dexpro/app/routing/app_navigation.dart';
import 'package:dexpro/core/models/ability.dart';
import 'package:dexpro/core/models/pokemon.dart' as dex;
import 'package:dexpro/core/models/pokemon_list_item.dart';
import 'package:flutter/material.dart';

class AbilityDexPage extends StatefulWidget {
  const AbilityDexPage({super.key});

  @override
  State<AbilityDexPage> createState() => _AbilityDexPageState();
}

class _AbilityDexPageState extends State<AbilityDexPage> {
  late final TextEditingController _searchController;
  String _query = '';
  final Set<Ability> _expandedAbilities = <Ability>{};

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController()
      ..addListener(() {
        setState(() {
          _query = _searchController.text.trim().toLowerCase();
        });
      });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<PokemonListItem> allPokemon =
        dex.pokemonList.entries
            .expand(
              (MapEntry<String, dex.Pokemon> entry) => _expandPokemonEntries(
                PokemonListItem(slug: entry.key, pokemon: entry.value),
              ),
            )
            .toList()
          ..sort(
            (PokemonListItem a, PokemonListItem b) =>
                a.displayName.compareTo(b.displayName),
          );

    final List<_AbilityDexEntry> abilities =
        Ability.values
            .map(
              (Ability ability) => _AbilityDexEntry(
                ability: ability,
                name: _formatAbilityName(ability),
                description: ability.description,
                matchingPokemon: allPokemon
                    .where(
                      (PokemonListItem pokemon) =>
                          pokemon.pokemon.ability == ability ||
                          pokemon.pokemon.ability2 == ability ||
                          pokemon.pokemon.hiddenAbility == ability,
                    )
                    .toList(growable: false),
              ),
            )
            .toList()
          ..sort(
            (_AbilityDexEntry a, _AbilityDexEntry b) =>
                a.name.compareTo(b.name),
          );

    final List<_AbilityDexEntry> filteredAbilities = abilities
        .where(
          (_AbilityDexEntry entry) =>
              _query.isEmpty ||
              entry.name.toLowerCase().contains(_query) ||
              entry.description.toLowerCase().contains(_query),
        )
        .toList(growable: false);

    return Column(
      key: const ValueKey('ability-dex-page'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ability Dex',
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w800,
            fontFamily: 'RobotoCondensed',
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Browse and search every ability by name or description.',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontFamily: 'RobotoCondensed',
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: SearchBar(
            controller: _searchController,
            hintText: 'Search abilities',
            textStyle: WidgetStatePropertyAll<TextStyle?>(
              theme.textTheme.bodyLarge?.copyWith(
                fontFamily: 'RobotoCondensed',
              ),
            ),
            leading: const Icon(Icons.search_rounded),
            trailing: <Widget>[
              IconButton(
                onPressed: _searchController.clear,
                icon: const Icon(Icons.close_rounded),
                tooltip: 'Clear search',
              ),
            ],
            elevation: const WidgetStatePropertyAll<double>(0),
            backgroundColor: WidgetStatePropertyAll<Color>(
              theme.cardTheme.color ??
                  (theme.brightness == Brightness.dark
                      ? const Color(0xFF141414)
                      : Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.separated(
            itemCount: filteredAbilities.length,
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 14),
            itemBuilder: (BuildContext context, int index) {
              final _AbilityDexEntry entry = filteredAbilities[index];
              final bool isExpanded = _expandedAbilities.contains(
                entry.ability,
              );

              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.36,
                  ),
                ),
                child: Theme(
                  data: theme.copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    onExpansionChanged: (bool expanded) {
                      setState(() {
                        if (expanded) {
                          _expandedAbilities.add(entry.ability);
                        } else {
                          _expandedAbilities.remove(entry.ability);
                        }
                      });
                    },
                    initiallyExpanded: isExpanded,
                    title: Text(
                      entry.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontFamily: 'RobotoCondensed',
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        entry.description,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.45,
                          fontFamily: 'RobotoCondensed',
                        ),
                      ),
                    ),
                    children: [
                      if (entry.matchingPokemon.isEmpty)
                        Text(
                          'No Pokemon currently use this ability.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontFamily: 'RobotoCondensed',
                          ),
                        )
                      else
                        SizedBox(
                          height: 126,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: entry.matchingPokemon.length,
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const SizedBox(width: 12),
                            itemBuilder: (BuildContext context, int index) {
                              final PokemonListItem pokemon =
                                  entry.matchingPokemon[index];

                              return _AbilityPokemonTile(
                                entry: pokemon,
                                onTap: () =>
                                    openPokemonDetails(context, pokemon),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatAbilityName(Ability ability) {
    return ability.name
        .split(RegExp(r'(?=[A-Z])|_'))
        .where((String part) => part.isNotEmpty)
        .map((String part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }

  List<PokemonListItem> _expandPokemonEntries(PokemonListItem baseEntry) {
    return <PokemonListItem>[
      baseEntry,
      if (baseEntry.pokemon.mega != null)
        baseEntry.variant(baseEntry.pokemon.mega!),
      if (baseEntry.pokemon.mega2 != null)
        baseEntry.variant(baseEntry.pokemon.mega2!),
    ];
  }
}

class _AbilityDexEntry {
  const _AbilityDexEntry({
    required this.ability,
    required this.name,
    required this.description,
    required this.matchingPokemon,
  });

  final Ability ability;
  final String name;
  final String description;
  final List<PokemonListItem> matchingPokemon;
}

class _AbilityPokemonTile extends StatelessWidget {
  const _AbilityPokemonTile({required this.entry, required this.onTap});

  final PokemonListItem entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 108,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: theme.colorScheme.surface.withValues(alpha: 0.72),
        ),
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
                    ) {
                      return Icon(
                        Icons.catching_pokemon_rounded,
                        size: 36,
                        color: theme.colorScheme.primary,
                      );
                    },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              entry.displayName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
