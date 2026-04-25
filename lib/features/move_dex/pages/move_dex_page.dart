import 'package:dexpro/app/routing/app_navigation.dart';
import 'package:dexpro/core/models/move.dart';
import 'package:dexpro/core/models/pokemon.dart' as dex;
import 'package:dexpro/core/models/pokemon_list_item.dart';
import 'package:dexpro/core/models/type.dart' as dex_type;
import 'package:flutter/material.dart';

const String _allTypesValue = '__all_types__';
const String _allCategoriesValue = '__all_categories__';
const double _typeColumnWidth = 58;
const double _categoryColumnWidth = 116;
const double _powerColumnWidth = 72;
const double _accuracyColumnWidth = 88;
const double _ppColumnWidth = 58;
const double _arrowColumnWidth = 52;
const double _minMoveDexWidth = 840;

class MoveDexPage extends StatefulWidget {
  const MoveDexPage({super.key});

  @override
  State<MoveDexPage> createState() => _MoveDexPageState();
}

class _MoveDexPageState extends State<MoveDexPage> {
  late final TextEditingController _searchController;
  String _query = '';
  dex_type.Type? _selectedType;
  MoveCategory? _selectedCategory;
  _MoveDexSortColumn _sortColumn = _MoveDexSortColumn.name;
  bool _sortAscending = true;
  final Set<String> _expandedMoves = <String>{};

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
    final List<_MoveDexEntry> moveEntries = _buildMoveEntries();
    final List<_MoveDexEntry> filteredMoves =
        moveEntries.where(_matchesFilters).toList()..sort(_compareMoves);

    if (!_sortAscending) {
      filteredMoves.replaceRange(
        0,
        filteredMoves.length,
        filteredMoves.reversed,
      );
    }

    return Column(
      key: const ValueKey('move-dex-page'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Move Dex',
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w800,
            fontFamily: 'RobotoCondensed',
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Search every learnable move, filter by type or category, and open the Pokemon that can learn it.',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontFamily: 'RobotoCondensed',
          ),
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool stackFilters = constraints.maxWidth < 720;

            final Widget searchBar = SizedBox(
              width: double.infinity,
              child: SearchBar(
                controller: _searchController,
                hintText: 'Search moves or descriptions',
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
            );

            final Widget filters = _MoveDexFilters(
              selectedType: _selectedType,
              selectedCategory: _selectedCategory,
              onTypeChanged: (dex_type.Type? type) {
                setState(() => _selectedType = type);
              },
              onCategoryChanged: (MoveCategory? category) {
                setState(() => _selectedCategory = category);
              },
            );

            if (stackFilters) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  searchBar,
                  const SizedBox(height: 12),
                  Align(alignment: Alignment.centerRight, child: filters),
                ],
              );
            }

            return Row(
              children: [
                Expanded(child: searchBar),
                const SizedBox(width: 14),
                filters,
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        Expanded(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double tableWidth = constraints.maxWidth < _minMoveDexWidth
                  ? _minMoveDexWidth
                  : constraints.maxWidth;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: tableWidth,
                  child: Column(
                    children: [
                      _MoveDexHeaderRow(
                        sortColumn: _sortColumn,
                        sortAscending: _sortAscending,
                        onSort: _setSort,
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.separated(
                          itemCount: filteredMoves.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(height: 10),
                          itemBuilder: (BuildContext context, int index) {
                            final _MoveDexEntry entry = filteredMoves[index];
                            final bool isExpanded = _expandedMoves.contains(
                              entry.key,
                            );

                            return _MoveDexTile(
                              entry: entry,
                              isExpanded: isExpanded,
                              onToggle: () {
                                setState(() {
                                  if (isExpanded) {
                                    _expandedMoves.remove(entry.key);
                                  } else {
                                    _expandedMoves.add(entry.key);
                                  }
                                });
                              },
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

  List<_MoveDexEntry> _buildMoveEntries() {
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

    final Map<String, _MoveDexEntryBuilder> entries =
        <String, _MoveDexEntryBuilder>{};

    for (final PokemonListItem pokemon in allPokemon) {
      for (final Move move in pokemon.pokemon.moves) {
        final String key = move.name.toLowerCase();
        entries.putIfAbsent(key, () => _MoveDexEntryBuilder(move: move));
        entries[key]!.addPokemon(pokemon);
      }
    }

    return entries.values
        .map((_MoveDexEntryBuilder builder) => builder.build())
        .toList(growable: false);
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

  bool _matchesFilters(_MoveDexEntry entry) {
    if (_query.isNotEmpty &&
        !entry.name.toLowerCase().contains(_query) &&
        !entry.description.toLowerCase().contains(_query)) {
      return false;
    }

    if (_selectedType != null && entry.move.type != _selectedType) {
      return false;
    }

    if (_selectedCategory != null && entry.move.category != _selectedCategory) {
      return false;
    }

    return true;
  }

  int _compareMoves(_MoveDexEntry a, _MoveDexEntry b) {
    return switch (_sortColumn) {
      _MoveDexSortColumn.name => a.name.compareTo(b.name),
      _MoveDexSortColumn.type => a.move.type.displayName.compareTo(
        b.move.type.displayName,
      ),
      _MoveDexSortColumn.category => _moveCategoryLabel(
        a.move.category,
      ).compareTo(_moveCategoryLabel(b.move.category)),
      _MoveDexSortColumn.power => a.move.power.compareTo(b.move.power),
      _MoveDexSortColumn.accuracy => a.move.accuracy.compareTo(b.move.accuracy),
      _MoveDexSortColumn.pp => a.pp.compareTo(b.pp),
      _MoveDexSortColumn.pokemon => a.matchingPokemon.length.compareTo(
        b.matchingPokemon.length,
      ),
    };
  }

  void _setSort(_MoveDexSortColumn column) {
    setState(() {
      if (_sortColumn == column) {
        _sortAscending = !_sortAscending;
        return;
      }

      _sortColumn = column;
      _sortAscending = true;
    });
  }
}

class _MoveDexFilters extends StatelessWidget {
  const _MoveDexFilters({
    required this.selectedType,
    required this.selectedCategory,
    required this.onTypeChanged,
    required this.onCategoryChanged,
  });

  final dex_type.Type? selectedType;
  final MoveCategory? selectedCategory;
  final ValueChanged<dex_type.Type?> onTypeChanged;
  final ValueChanged<MoveCategory?> onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _TypeFilterButton(selectedType: selectedType, onChanged: onTypeChanged),
        _CategoryFilterButton(
          selectedCategory: selectedCategory,
          onChanged: onCategoryChanged,
        ),
      ],
    );
  }
}

class _TypeFilterButton extends StatelessWidget {
  const _TypeFilterButton({
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
            : Image.asset(selectedType!.imageURL, width: 20, height: 20),
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

class _CategoryFilterButton extends StatelessWidget {
  const _CategoryFilterButton({
    required this.selectedCategory,
    required this.onChanged,
  });

  final MoveCategory? selectedCategory;
  final ValueChanged<MoveCategory?> onChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Filter by category',
      onSelected: (String value) {
        onChanged(
          value == _allCategoriesValue
              ? null
              : MoveCategory.values.byName(value),
        );
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        _categoryMenuItem(null, selectedCategory == null),
        ...MoveCategory.values.map(
          (MoveCategory category) =>
              _categoryMenuItem(category, selectedCategory == category),
        ),
      ],
      child: _FilterButtonShell(
        icon: Icon(
          _categoryIcon(selectedCategory),
          size: 18,
          color: selectedCategory == null
              ? null
              : _categoryColor(selectedCategory!),
        ),
        label: selectedCategory == null
            ? 'All Categories'
            : _moveCategoryLabel(selectedCategory!),
      ),
    );
  }

  PopupMenuItem<String> _categoryMenuItem(
    MoveCategory? category,
    bool selected,
  ) {
    return PopupMenuItem<String>(
      value: category?.name ?? _allCategoriesValue,
      child: Row(
        children: [
          Icon(
            _categoryIcon(category),
            size: 18,
            color: category == null ? null : _categoryColor(category),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              category == null
                  ? 'All Categories'
                  : _moveCategoryLabel(category),
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

class _MoveDexHeaderRow extends StatelessWidget {
  const _MoveDexHeaderRow({
    required this.sortColumn,
    required this.sortAscending,
    required this.onSort,
  });

  final _MoveDexSortColumn sortColumn;
  final bool sortAscending;
  final ValueChanged<_MoveDexSortColumn> onSort;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      ),
      child: Row(
        children: [
          _HeaderCell(
            width: _typeColumnWidth,
            label: 'Type',
            column: _MoveDexSortColumn.type,
            sortColumn: sortColumn,
            sortAscending: sortAscending,
            onSort: onSort,
          ),
          Expanded(
            child: _HeaderCell(
              label: 'Move',
              column: _MoveDexSortColumn.name,
              sortColumn: sortColumn,
              sortAscending: sortAscending,
              onSort: onSort,
            ),
          ),
          _HeaderCell(
            width: _categoryColumnWidth,
            label: 'Category',
            column: _MoveDexSortColumn.category,
            sortColumn: sortColumn,
            sortAscending: sortAscending,
            onSort: onSort,
          ),
          _HeaderCell(
            width: _powerColumnWidth,
            label: 'Power',
            column: _MoveDexSortColumn.power,
            sortColumn: sortColumn,
            sortAscending: sortAscending,
            onSort: onSort,
          ),
          _HeaderCell(
            width: _accuracyColumnWidth,
            label: 'Accuracy',
            column: _MoveDexSortColumn.accuracy,
            sortColumn: sortColumn,
            sortAscending: sortAscending,
            onSort: onSort,
          ),
          _HeaderCell(
            width: _ppColumnWidth,
            label: 'PP',
            column: _MoveDexSortColumn.pp,
            sortColumn: sortColumn,
            sortAscending: sortAscending,
            onSort: onSort,
          ),
          _HeaderCell(
            width: _arrowColumnWidth,
            label: '',
            column: _MoveDexSortColumn.pokemon,
            sortColumn: sortColumn,
            sortAscending: sortAscending,
            onSort: onSort,
          ),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell({
    required this.label,
    required this.column,
    required this.sortColumn,
    required this.sortAscending,
    required this.onSort,
    this.width,
  });

  final String label;
  final _MoveDexSortColumn column;
  final _MoveDexSortColumn sortColumn;
  final bool sortAscending;
  final ValueChanged<_MoveDexSortColumn> onSort;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool selected = sortColumn == column;

    final Widget child = InkWell(
      onTap: () => onSort(column),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: label.isEmpty
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            Text(
              label.isEmpty ? '#' : label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontFamily: 'RobotoCondensed',
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
            if (selected) ...[
              const SizedBox(width: 4),
              Icon(
                sortAscending
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                size: 14,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ],
        ),
      ),
    );

    if (width == null) {
      return child;
    }

    return SizedBox(width: width, child: child);
  }
}

class _MoveDexTile extends StatelessWidget {
  const _MoveDexTile({
    required this.entry,
    required this.isExpanded,
    required this.onToggle,
  });

  final _MoveDexEntry entry;
  final bool isExpanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showMoveDetailsDialog(context, entry),
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.36,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: _typeColumnWidth,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Tooltip(
                        message: entry.move.type.displayName,
                        child: Image.asset(
                          entry.move.type.imageURL,
                          width: 32,
                          height: 32,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontFamily: 'RobotoCondensed',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          entry.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.25,
                            fontFamily: 'RobotoCondensed',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: _categoryColumnWidth,
                    child: _MoveCategoryCell(category: entry.move.category),
                  ),
                  SizedBox(
                    width: _powerColumnWidth,
                    child: _MoveStatCell(_formatStat(entry.move.power)),
                  ),
                  SizedBox(
                    width: _accuracyColumnWidth,
                    child: _MoveStatCell(_formatAccuracy(entry.move.accuracy)),
                  ),
                  SizedBox(
                    width: _ppColumnWidth,
                    child: _MoveStatCell(entry.pp.toString()),
                  ),
                  SizedBox(
                    width: _arrowColumnWidth,
                    child: IconButton(
                      onPressed: onToggle,
                      tooltip: isExpanded
                          ? 'Hide Pokemon'
                          : 'Show Pokemon with ${entry.name}',
                      icon: AnimatedRotation(
                        duration: const Duration(milliseconds: 180),
                        turns: isExpanded ? 0.5 : 0,
                        child: const Icon(Icons.keyboard_arrow_down_rounded),
                      ),
                    ),
                  ),
                ],
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox(width: double.infinity),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: entry.matchingPokemon.isEmpty
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'No Pokemon currently have this move.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontFamily: 'RobotoCondensed',
                            ),
                          ),
                        )
                      : SizedBox(
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
                              return _MovePokemonTile(entry: pokemon);
                            },
                          ),
                        ),
                ),
                crossFadeState: isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 180),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showMoveDetailsDialog(BuildContext context, _MoveDexEntry entry) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) => _MoveDetailsDialog(entry: entry),
  );
}

class _MoveDetailsDialog extends StatelessWidget {
  const _MoveDetailsDialog({required this.entry});

  final _MoveDexEntry entry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Tooltip(
                    message: entry.move.type.displayName,
                    child: Image.asset(
                      entry.move.type.imageURL,
                      width: 48,
                      height: 48,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          entry.name,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            fontFamily: 'RobotoCondensed',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            _MoveCategoryCell(category: entry.move.category),
                            _MoveDetailChip(
                              label: 'Power',
                              value: _formatStat(entry.move.power),
                            ),
                            _MoveDetailChip(
                              label: 'Accuracy',
                              value: _formatAccuracy(entry.move.accuracy),
                            ),
                            _MoveDetailChip(
                              label: 'PP',
                              value: entry.pp.toString(),
                            ),
                            _MoveDetailChip(
                              label: 'Pokemon',
                              value: entry.matchingPokemon.length.toString(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                    tooltip: 'Close',
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Text(
                'Description',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontFamily: 'RobotoCondensed',
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: SingleChildScrollView(
                  child: Text(
                    entry.description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.45,
                      fontFamily: 'RobotoCondensed',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoveDetailChip extends StatelessWidget {
  const _MoveDetailChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Text(
        '$label: $value',
        style: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w800,
          fontFamily: 'RobotoCondensed',
        ),
      ),
    );
  }
}

class _MoveCategoryCell extends StatelessWidget {
  const _MoveCategoryCell({required this.category});

  final MoveCategory category;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color = _categoryColor(category);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(_categoryIcon(category), size: 18, color: color),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            _moveCategoryLabel(category),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w800,
              fontFamily: 'RobotoCondensed',
            ),
          ),
        ),
      ],
    );
  }
}

class _MoveStatCell extends StatelessWidget {
  const _MoveStatCell(this.value);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w800,
        fontFamily: 'RobotoCondensed',
      ),
    );
  }
}

class _MovePokemonTile extends StatelessWidget {
  const _MovePokemonTile({required this.entry});

  final PokemonListItem entry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return InkWell(
      onTap: () => openPokemonDetails(context, entry),
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
                fontFamily: 'RobotoCondensed',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoveDexEntryBuilder {
  _MoveDexEntryBuilder({required this.move});

  final Move move;
  final Map<String, PokemonListItem> _matchingPokemon =
      <String, PokemonListItem>{};
  final Set<int> _ppValues = <int>{};

  void addPokemon(PokemonListItem pokemon) {
    _matchingPokemon[pokemon.slug] = pokemon;
    final Move matchedMove = pokemon.pokemon.moves.firstWhere(
      (Move candidate) => candidate.name == move.name,
      orElse: () => move,
    );
    _ppValues.add(matchedMove.pp);
  }

  _MoveDexEntry build() {
    final List<PokemonListItem> pokemon = _matchingPokemon.values.toList()
      ..sort(
        (PokemonListItem a, PokemonListItem b) =>
            a.displayName.compareTo(b.displayName),
      );
    final List<int> ppValues = _ppValues.toList()..sort();

    return _MoveDexEntry(
      key: move.name.toLowerCase(),
      move: move,
      matchingPokemon: pokemon,
      pp: ppValues.isEmpty ? move.pp : ppValues.last,
    );
  }
}

class _MoveDexEntry {
  const _MoveDexEntry({
    required this.key,
    required this.move,
    required this.matchingPokemon,
    required this.pp,
  });

  final String key;
  final Move move;
  final List<PokemonListItem> matchingPokemon;
  final int pp;

  String get name => move.name;
  String get description => move.description;
}

enum _MoveDexSortColumn { name, type, category, power, accuracy, pp, pokemon }

String _moveCategoryLabel(MoveCategory category) {
  return switch (category) {
    MoveCategory.physical => 'Physical',
    MoveCategory.special => 'Special',
    MoveCategory.status => 'Status',
  };
}

Color _categoryColor(MoveCategory category) {
  return switch (category) {
    MoveCategory.physical => Colors.orange,
    MoveCategory.special => Colors.blue,
    MoveCategory.status => Colors.grey,
  };
}

IconData _categoryIcon(MoveCategory? category) {
  return switch (category) {
    MoveCategory.physical => Icons.fitness_center_rounded,
    MoveCategory.special => Icons.auto_awesome_rounded,
    MoveCategory.status => Icons.shield_rounded,
    null => Icons.tune_rounded,
  };
}

String _formatStat(int value) {
  return value == 0 ? '-' : value.toString();
}

String _formatAccuracy(int value) {
  return value == 0 ? '-' : '$value%';
}
