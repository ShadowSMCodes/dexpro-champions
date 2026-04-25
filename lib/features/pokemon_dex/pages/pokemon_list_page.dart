import 'package:dexpro/app/routing/app_navigation.dart';
import 'package:dexpro/core/models/pokemon.dart' as dex;
import 'package:dexpro/core/models/pokemon_list_item.dart';
import 'package:dexpro/core/models/type.dart' as dex_type;
import 'package:dexpro/core/providers/app_details_provider.dart';
import 'package:dexpro/features/pokemon_dex/widgets/pokemon_grid_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const String _allTypesValue = '__all_types__';

class PokemonListPage extends StatefulWidget {
  const PokemonListPage({super.key});

  @override
  State<PokemonListPage> createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  late final TextEditingController _searchController;
  String _query = '';
  dex_type.Type? _selectedType;

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
    final AppDetailsProvider appDetailsProvider = context
        .watch<AppDetailsProvider>();
    final ThemeData theme = Theme.of(context);
    final List<PokemonListItem> pokemon = dex.pokemonList.entries
        .map(
          (MapEntry<String, dex.Pokemon> entry) =>
              PokemonListItem(slug: entry.key, pokemon: entry.value),
        )
        .toList(growable: false);

    final List<PokemonListItem> filteredPokemon = pokemon
        .where((PokemonListItem entry) {
          final bool matchesQuery =
              _query.isEmpty ||
              entry.displayName.toLowerCase().contains(_query) ||
              entry.pokemon.id.toString().contains(_query);

          if (!matchesQuery) {
            return false;
          }

          return _selectedType == null ||
              entry.pokemon.type1 == _selectedType ||
              entry.pokemon.type2 == _selectedType;
        })
        .toList(growable: false);

    return Column(
      key: const ValueKey('pokemon-list-page'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pokémon Dex',
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
            fontFamily: 'RobotoCondensed',
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Browse the current Pokémon entries, search by name or number, and expand the roster over time.',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontFamily: 'RobotoCondensed',
          ),
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final Widget searchBar = SizedBox(
              width: double.infinity,
              child: SearchBar(
                controller: _searchController,
                hintText: 'Search Pokémon',
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
                      (_isDarkTheme(context)
                          ? const Color(0xFF141414)
                          : Colors.white),
                ),
              ),
            );

            final Widget typeFilter = _PokemonTypeFilterButton(
              selectedType: _selectedType,
              onChanged: (dex_type.Type? type) {
                setState(() => _selectedType = type);
              },
            );

            if (constraints.maxWidth < 640) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  searchBar,
                  const SizedBox(height: 12),
                  Align(alignment: Alignment.centerRight, child: typeFilter),
                ],
              );
            }

            return Row(
              children: [
                Expanded(child: searchBar),
                const SizedBox(width: 14),
                typeFilter,
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        Expanded(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final int crossAxisCount = switch (constraints.maxWidth) {
                < 500 => 3,
                < 800 => 4,
                < 1100 => 5,
                < 1400 => 6,
                < 1700 => 7,
                < 2000 => 8,
                < 2300 => 9,
                < 2600 => 10,
                < 2900 => 11,
                < 3200 => 12,
                _ => 13,
              };

              return GridView.builder(
                itemCount: filteredPokemon.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: appDetailsProvider.isCompact ? 0.8 : 1,
                ),
                itemBuilder: (BuildContext context, int index) {
                  final PokemonListItem entry = filteredPokemon[index];

                  return PokemonGridCard(
                    entry: entry,
                    onTap: () => openPokemonDetails(context, entry),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PokemonTypeFilterButton extends StatelessWidget {
  const _PokemonTypeFilterButton({
    required this.selectedType,
    required this.onChanged,
  });

  final dex_type.Type? selectedType;
  final ValueChanged<dex_type.Type?> onChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Filter by type',
      onSelected: (String value) {
        onChanged(
          value == _allTypesValue ? null : dex_type.Type.values.byName(value),
        );
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        _typeMenuItem(context, null, selectedType == null),
        ...dex_type.Type.values.map(
          (dex_type.Type type) =>
              _typeMenuItem(context, type, selectedType == type),
        ),
      ],
      child: _FilterButtonShell(
        icon: selectedType == null
            ? const Icon(Icons.category_outlined, size: 18)
            : Image.asset(selectedType!.imageURL, width: 22, height: 22),
        label: selectedType?.displayName ?? 'All Types',
      ),
    );
  }

  PopupMenuItem<String> _typeMenuItem(
    BuildContext context,
    dex_type.Type? type,
    bool selected,
  ) {
    return PopupMenuItem<String>(
      value: type?.name ?? _allTypesValue,
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: type == null
                ? const Icon(Icons.all_inclusive_rounded, size: 18)
                : Image.asset(type.imageURL, fit: BoxFit.contain),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              type?.displayName ?? 'All Types',
              style: const TextStyle(fontFamily: 'RobotoCondensed'),
            ),
          ),
          if (selected) const Icon(Icons.check_rounded, size: 18),
        ],
      ),
    );
  }
}

class _FilterButtonShell extends StatelessWidget {
  const _FilterButtonShell({required this.icon, required this.label});

  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
              fontFamily: 'RobotoCondensed',
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
        ],
      ),
    );
  }
}

bool _isDarkTheme(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}
