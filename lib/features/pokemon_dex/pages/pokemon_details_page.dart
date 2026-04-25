import 'dart:math' as math;

import 'package:dexpro/app/routing/app_navigation.dart';
import 'package:dexpro/app/routing/app_route_data.dart';
import 'package:dexpro/core/config/app_constants.dart';
import 'package:dexpro/core/models/ability.dart';
import 'package:dexpro/core/models/move.dart';
import 'package:dexpro/core/models/navigation_item.dart';
import 'package:dexpro/core/models/pokemon.dart';
import 'package:dexpro/core/models/pokemon_list_item.dart';
import 'package:dexpro/core/models/type.dart';
import 'package:dexpro/core/providers/app_details_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PokemonDetailsPage extends StatefulWidget {
  const PokemonDetailsPage({super.key, required this.entry});

  final PokemonListItem entry;

  @override
  State<PokemonDetailsPage> createState() => _PokemonDetailsPageState();
}

class _PokemonDetailsPageState extends State<PokemonDetailsPage> {
  static const int _statMax = 180;
  static const int _bstMax = 650;

  late PokemonListItem _currentEntry;

  @override
  void initState() {
    super.initState();
    _currentEntry = widget.entry;
  }

  @override
  void didUpdateWidget(covariant PokemonDetailsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.entry.slug != widget.entry.slug ||
        oldWidget.entry.pokemon.form != widget.entry.pokemon.form) {
      _currentEntry = widget.entry;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final AppDetailsProvider appDetailsProvider = context
        .watch<AppDetailsProvider>();
    final bool isCompact = appDetailsProvider.isCompact;
    final PokemonListItem entry = _currentEntry;
    final AppRouteData routeData = currentRoute(context);
    final String backLabel = navigationItems
        .firstWhere(
          (NavigationItem item) =>
              item.path == routeData.selectedNavigationPath,
          orElse: () => navigationItems[1],
        )
        .label;
    final List<_AbilityData> abilities = <_AbilityData>[
      _AbilityData(
        name: _formatAbility(entry.pokemon.ability),
        description: entry.pokemon.ability.description,
      ),
      if (entry.pokemon.ability2 != null)
        _AbilityData(
          name: _formatAbility(entry.pokemon.ability2!),
          description: entry.pokemon.ability2!.description,
        ),
    ];
    final _AbilityData? hiddenAbility = entry.pokemon.hiddenAbility == null
        ? null
        : _AbilityData(
            name: _formatAbility(entry.pokemon.hiddenAbility!),
            description: entry.pokemon.hiddenAbility!.description,
          );
    final List<_StatBarData> stats = <_StatBarData>[
      _StatBarData(
        label: 'HP',
        value: entry.pokemon.stats.hp,
        maxValue: _statMax,
        color: const Color(0xFF22C55E),
      ),
      _StatBarData(
        label: 'Attack',
        value: entry.pokemon.stats.att,
        maxValue: _statMax,
        color: const Color(0xFFFACC15),
      ),
      _StatBarData(
        label: 'Defense',
        value: entry.pokemon.stats.def,
        maxValue: _statMax,
        color: const Color(0xFFF97316),
      ),
      _StatBarData(
        label: 'Sp. Atk',
        value: entry.pokemon.stats.spa,
        maxValue: _statMax,
        color: const Color(0xFF38BDF8),
      ),
      _StatBarData(
        label: 'Sp. Def',
        value: entry.pokemon.stats.spd,
        maxValue: _statMax,
        color: const Color(0xFF1D4ED8),
      ),
      _StatBarData(
        label: 'Speed',
        value: entry.pokemon.stats.spe,
        maxValue: _statMax,
        color: const Color(0xFFEC4899),
      ),
      _StatBarData(
        label: 'BST',
        value: entry.pokemon.stats.totalBST,
        maxValue: _bstMax,
        color: const Color(0xFF6B7280),
      ),
    ];
    final List<_VariantButtonData> variantButtons = _buildVariantButtons();
    final List<_TypeMatchupSectionData> matchupSections = _buildMatchupSections(
      entry,
    );

    return SingleChildScrollView(
      key: ValueKey('pokemon-details-${entry.slug}'),
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () =>
                    goBackOrReplace(context, routeData.selectedNavigationPath),
                icon: const Icon(Icons.arrow_back_rounded),
                label: Text('Back to $backLabel'),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      final bool isNarrow = constraints.maxWidth < 780;
                      final Widget artworkGrid = _ArtworkGrid(entry: entry);
                      final Widget detailsContent = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.displayName,
                            style: theme.textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '#${entry.pokemon.id.toString().padLeft(4, '0')}',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              Image.asset(entry.pokemon.type1.imageURL),
                              if (entry.pokemon.type2 != null)
                                Image.asset(entry.pokemon.type2!.imageURL),
                            ],
                          ),
                        ],
                      );

                      if (isNarrow) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            artworkGrid,
                            const SizedBox(height: 24),
                            detailsContent,
                          ],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 320, child: artworkGrid),
                          const SizedBox(width: 24),
                          Expanded(child: detailsContent),
                        ],
                      );
                    },
                  ),
                ),
              ),
              if (variantButtons.isNotEmpty) ...[
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alternate Forms',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _AlternateFormsSection(
                          buttons: variantButtons,
                          selectedSlug: entry.slug,
                          isCompact: isCompact,
                          accentColor: colorScheme.primary,
                          onSelected: (PokemonListItem selectedEntry) {
                            openPokemonDetails(
                              context,
                              selectedEntry,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Abilities',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: abilities
                            .map(
                              (_AbilityData ability) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _AbilityCard(ability: ability),
                              ),
                            )
                            .toList(),
                      ),
                      if (hiddenAbility != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          'Hidden Ability',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _AbilityCard(ability: hiddenAbility),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Base Stats',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: stats
                            .map(
                              (_StatBarData stat) => Padding(
                                padding: const EdgeInsets.only(bottom: 14),
                                child: _StatBarRow(stat: stat),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Learnable Moves',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _LearnableMovesList(moves: entry.pokemon.moves),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Type Matchups',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: matchupSections
                            .map(
                              (_TypeMatchupSectionData section) => Padding(
                                padding: const EdgeInsets.only(bottom: 28),
                                child: _TypeMatchupSection(
                                  section: section,
                                  isCompact: isCompact,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatAbility(Ability ability) {
    return _titleCase(ability.name);
  }

  List<_TypeMatchupSectionData> _buildMatchupSections(PokemonListItem entry) {
    final List<Ability> abilities = <Ability>[
      entry.pokemon.ability,
      if (entry.pokemon.ability2 != null) entry.pokemon.ability2!,
      if (entry.pokemon.hiddenAbility != null) entry.pokemon.hiddenAbility!,
    ];
    final int totalAbilityCount = abilities.length;

    final List<Ability> uniqueModifiers = <Ability>[];
    for (final Ability ability in abilities) {
      if (Type.modifiesDefensiveMultiplier(ability) &&
          !uniqueModifiers.contains(ability)) {
        uniqueModifiers.add(ability);
      }
    }

    if (uniqueModifiers.isEmpty) {
      return <_TypeMatchupSectionData>[
        _TypeMatchupSectionData(items: _buildMatchupData(entry)),
      ];
    }

    if (totalAbilityCount == 1 && uniqueModifiers.length == 1) {
      return <_TypeMatchupSectionData>[
        _TypeMatchupSectionData(
          items: _buildMatchupData(entry, ability: uniqueModifiers.first),
        ),
      ];
    }

    final List<_TypeMatchupSectionData> sections = <_TypeMatchupSectionData>[
      _TypeMatchupSectionData(
        title: 'Without Ability Effects',
        items: _buildMatchupData(entry),
        showTitle: true,
      ),
    ];

    for (final Ability ability in uniqueModifiers) {
      sections.add(
        _TypeMatchupSectionData(
          title: 'With ${_formatAbility(ability)}',
          items: _buildMatchupData(entry, ability: ability),
          showTitle: true,
        ),
      );
    }

    return sections;
  }

  List<_TypeMatchupData> _buildMatchupData(
    PokemonListItem entry, {
    Ability? ability,
  }) {
    final Type? immunityType = ability == null
        ? null
        : Type.immunityTypeFromAbility(ability);

    return Type.values
        .map((Type attacker) {
          final double baseMultiplier = Type.combinedEffectivenessAgainst(
            attacker,
            entry.pokemon.type1,
            entry.pokemon.type2,
          );
          final double multiplier = ability == null
              ? baseMultiplier
              : Type.combinedEffectivenessAgainstWithAbility(
                  attacker,
                  entry.pokemon.type1,
                  entry.pokemon.type2,
                  ability,
                );

          String? tooltip;
          if (attacker == immunityType) {
            tooltip =
                '${_formatAbility(ability!)} makes ${attacker.displayName} attacks deal 0× damage.';
          } else if ((ability == Ability.solidRock ||
                  ability == Ability.filter) &&
              baseMultiplier > 1) {
            tooltip =
                '${_formatAbility(ability!)} reduces super-effective damage for ${attacker.displayName} attacks by 25%.';
          } else if ((ability == Ability.waterBubble ||
                  ability == Ability.heatproof) &&
              attacker == Type.fire) {
            tooltip = '${_formatAbility(ability!)} halves Fire-type damage.';
          }

          return _TypeMatchupData(
            type: attacker,
            multiplier: multiplier,
            tooltip: tooltip,
          );
        })
        .toList(growable: false);
  }

  List<_VariantButtonData> _buildVariantButtons() {
    final List<_VariantButtonData> buttons = <_VariantButtonData>[];
    final PokemonListItem baseEntry = _currentEntry.familyBaseEntry;

    if (baseEntry.pokemon.mega == null && baseEntry.pokemon.mega2 == null) {
      return buttons;
    }

    buttons.add(_VariantButtonData(label: 'Base', entry: baseEntry));

    if (baseEntry.pokemon.mega != null) {
      buttons.add(
        _VariantButtonData(
          label: _variantLabel(baseEntry.pokemon.mega!),
          entry: baseEntry.variant(baseEntry.pokemon.mega!),
        ),
      );
    }

    if (baseEntry.pokemon.mega2 != null) {
      buttons.add(
        _VariantButtonData(
          label: _variantLabel(baseEntry.pokemon.mega2!),
          entry: baseEntry.variant(baseEntry.pokemon.mega2!),
        ),
      );
    }

    return buttons;
  }

  String _variantLabel(Pokemon pokemon) {
    return pokemon.form == null
        ? 'Mega'
        : pokemon.form!.split('_').map(_titleCase).join(' ');
  }

  String _titleCase(String text) {
    return text
        .replaceAll('_', ' ')
        .split(RegExp(r'(?=[A-Z])| '))
        .where((String part) => part.isNotEmpty)
        .map((String part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }
}

class _AbilityData {
  const _AbilityData({required this.name, required this.description});

  final String name;
  final String description;
}

class _TypeMatchupData {
  const _TypeMatchupData({
    required this.type,
    required this.multiplier,
    this.tooltip,
  });

  final Type type;
  final double multiplier;
  final String? tooltip;
}

class _TypeMatchupSectionData {
  const _TypeMatchupSectionData({
    this.title,
    required this.items,
    this.showTitle = false,
  });

  final String? title;
  final List<_TypeMatchupData> items;
  final bool showTitle;
}

class _ArtworkGrid extends StatelessWidget {
  const _ArtworkGrid({required this.entry});

  final PokemonListItem entry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: _ArtworkTile(
            label: 'Standard',
            assetPath: '${entry.assetImagePath}.png',
            accentColor: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ArtworkTile(
            label: 'Shiny',
            assetPath: '${entry.assetShinyImagePath}.png',
            accentColor: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

class _ArtworkTile extends StatelessWidget {
  const _ArtworkTile({
    required this.label,
    required this.assetPath,
    required this.accentColor,
  });

  final String label;
  final String assetPath;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: 172,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: accentColor.withValues(alpha: 0.08),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Center(
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.contain,
                  errorBuilder:
                      (
                        BuildContext context,
                        Object error,
                        StackTrace? stackTrace,
                      ) {
                        return Icon(
                          Icons.catching_pokemon_rounded,
                          size: 56,
                          color: accentColor,
                        );
                      },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlternateFormsSection extends StatelessWidget {
  const _AlternateFormsSection({
    required this.buttons,
    required this.selectedSlug,
    required this.isCompact,
    required this.accentColor,
    required this.onSelected,
  });

  final List<_VariantButtonData> buttons;
  final String selectedSlug;
  final bool isCompact;
  final Color accentColor;
  final ValueChanged<PokemonListItem> onSelected;

  @override
  Widget build(BuildContext context) {
    if (buttons.isEmpty) {
      return Text(
        'No alternate forms available for this Pokemon yet.',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool isNarrow = constraints.maxWidth < 700 && !isCompact;

        if (isNarrow) {
          return Column(
            children: buttons
                .map(
                  (_VariantButtonData button) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _AlternateFormButton(
                      label: button.label,
                      isSelected: selectedSlug == button.entry.slug,
                      accentColor: accentColor,
                      onPressed: () => onSelected(button.entry),
                    ),
                  ),
                )
                .toList(),
          );
        }

        return Row(
          children: buttons
              .map(
                (_VariantButtonData button) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: _AlternateFormButton(
                      label: button.label,
                      isSelected: selectedSlug == button.entry.slug,
                      accentColor: accentColor,
                      onPressed: () => onSelected(button.entry),
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _AlternateFormButton extends StatelessWidget {
  const _AlternateFormButton({
    required this.label,
    required this.isSelected,
    required this.accentColor,
    required this.onPressed,
  });

  final String label;
  final bool isSelected;
  final Color accentColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        side: BorderSide(color: accentColor, width: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        backgroundColor: isSelected
            ? accentColor.withValues(alpha: 0.08)
            : null,
        foregroundColor: accentColor,
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _AbilityCard extends StatelessWidget {
  const _AbilityCard({required this.ability});

  final _AbilityData ability;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.45,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ability.name,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            ability.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeMatchupTile extends StatelessWidget {
  const _TypeMatchupTile({required this.data});

  final _TypeMatchupData data;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color highlightColor = data.multiplier == 4
        ? const Color(0xFF3B82F6)
        : data.multiplier == 0
        ? const Color(0xFFEF4444)
        : data.multiplier < 1
        ? const Color(0xFFFACC15)
        : data.multiplier > 1
        ? const Color(0xFF22C55E)
        : theme.colorScheme.surfaceContainerHighest;

    final Widget tile = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: highlightColor.withValues(
          alpha: data.multiplier == 1 ? 0.42 : 0.26,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(data.type.imageURL, height: 24),
          Text(
            '${Type.formatMultiplier(data.multiplier)}×',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );

    if (data.tooltip == null) {
      return tile;
    }

    return Tooltip(message: data.tooltip!, child: tile);
  }
}

class _TypeMatchupSection extends StatelessWidget {
  const _TypeMatchupSection({required this.section, required this.isCompact});

  final _TypeMatchupSectionData section;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (section.showTitle) ...[
          Text(
            section.title!,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
        ],
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final int crossAxisCount = isCompact
                ? 3
                : constraints.maxWidth < 760
                ? 6
                : 9;
            final double childAspectRatio = isCompact
                ? 2.1
                : constraints.maxWidth < 760
                ? 1.85
                : 1.7;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: section.items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: childAspectRatio,
              ),
              itemBuilder: (BuildContext context, int index) {
                return _TypeMatchupTile(data: section.items[index]);
              },
            );
          },
        ),
      ],
    );
  }
}

const String _allMoveTypesValue = '__all_move_types__';
const String _allMoveCategoriesValue = '__all_move_categories__';
const double _moveTypeColumnWidth = 58;
const double _moveCategoryColumnWidth = 116;
const double _movePowerColumnWidth = 72;
const double _moveAccuracyColumnWidth = 88;
const double _movePpColumnWidth = 58;
const double _minLearnableMoveWidth = 760;

enum _MoveSortColumn { name, type, category, power, accuracy, pp }

class _LearnableMovesList extends StatefulWidget {
  const _LearnableMovesList({required this.moves});

  final List<Move> moves;

  @override
  State<_LearnableMovesList> createState() => _LearnableMovesListState();
}

class _LearnableMovesListState extends State<_LearnableMovesList> {
  late final TextEditingController _searchController;
  String _query = '';
  Type? _selectedType;
  MoveCategory? _selectedCategory;
  _MoveSortColumn _sortColumn = _MoveSortColumn.name;
  bool _sortAscending = true;

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

    if (widget.moves.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
          color: theme.colorScheme.surfaceContainerLowest,
        ),
        child: Text(
          'No learnable moves connected yet.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    List<Move> sortedMoves = widget.moves.where(_matchesFilters).toList()
      ..sort(_compareMoves);
    if (!_sortAscending) {
      sortedMoves = sortedMoves.reversed.toList(growable: false);
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        color: theme.colorScheme.surfaceContainerLowest,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final bool stackFilters = constraints.maxWidth < 680;
                  final Widget searchBar = SearchBar(
                    controller: _searchController,
                    hintText: 'Search moves or descriptions',
                    textStyle: WidgetStatePropertyAll<TextStyle?>(
                      theme.textTheme.bodyMedium?.copyWith(
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
                      theme.colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.5,
                      ),
                    ),
                  );

                  final Widget filters = _LearnableMoveFilters(
                    selectedType: _selectedType,
                    selectedCategory: _selectedCategory,
                    onTypeChanged: (Type? type) {
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
                      const SizedBox(width: 12),
                      filters,
                    ],
                  );
                },
              ),
              const SizedBox(height: 14),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final double tableWidth = math.max(
                    _minLearnableMoveWidth,
                    constraints.maxWidth,
                  );

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: tableWidth,
                      child: Column(
                        children: [
                          _MoveHeaderRow(
                            sortColumn: _sortColumn,
                            sortAscending: _sortAscending,
                            onSort: _setSort,
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 420,
                            child: sortedMoves.isEmpty
                                ? Center(
                                    child: Text(
                                      'No moves match your filters.',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: theme
                                                .colorScheme
                                                .onSurfaceVariant,
                                            fontFamily: 'RobotoCondensed',
                                          ),
                                    ),
                                  )
                                : ListView.separated(
                                    itemCount: sortedMoves.length,
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            const SizedBox(height: 8),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                          return _LearnableMoveTile(
                                            move: sortedMoves[index],
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
            ],
          ),
        ),
      ),
    );
  }

  bool _matchesFilters(Move move) {
    if (_query.isNotEmpty &&
        !move.name.toLowerCase().contains(_query) &&
        !move.description.toLowerCase().contains(_query)) {
      return false;
    }

    if (_selectedType != null && move.type != _selectedType) {
      return false;
    }

    if (_selectedCategory != null && move.category != _selectedCategory) {
      return false;
    }

    return true;
  }

  void _setSort(_MoveSortColumn column) {
    setState(() {
      if (_sortColumn == column) {
        _sortAscending = !_sortAscending;
        return;
      }

      _sortColumn = column;
      _sortAscending = true;
    });
  }

  int _compareMoves(Move a, Move b) {
    return switch (_sortColumn) {
      _MoveSortColumn.name => a.name.compareTo(b.name),
      _MoveSortColumn.type => a.type.displayName.compareTo(b.type.displayName),
      _MoveSortColumn.category => _moveCategoryLabel(
        a.category,
      ).compareTo(_moveCategoryLabel(b.category)),
      _MoveSortColumn.power => a.power.compareTo(b.power),
      _MoveSortColumn.accuracy => a.accuracy.compareTo(b.accuracy),
      _MoveSortColumn.pp => a.pp.compareTo(b.pp),
    };
  }
}

class _MoveHeaderRow extends StatelessWidget {
  const _MoveHeaderRow({
    required this.sortColumn,
    required this.sortAscending,
    required this.onSort,
  });

  final _MoveSortColumn sortColumn;
  final bool sortAscending;
  final ValueChanged<_MoveSortColumn> onSort;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      ),
      child: Row(
        children: [
          _MoveHeaderCell(
            label: 'Type',
            column: _MoveSortColumn.type,
            activeColumn: sortColumn,
            sortAscending: sortAscending,
            width: _moveTypeColumnWidth,
            onSort: onSort,
          ),
          Expanded(
            child: _MoveHeaderCell(
              label: 'Move',
              column: _MoveSortColumn.name,
              activeColumn: sortColumn,
              sortAscending: sortAscending,
              // width: moveColumnWidth,
              onSort: onSort,
            ),
          ),
          _MoveHeaderCell(
            label: 'Category',
            column: _MoveSortColumn.category,
            activeColumn: sortColumn,
            sortAscending: sortAscending,
            width: _moveCategoryColumnWidth,
            onSort: onSort,
          ),
          _MoveHeaderCell(
            label: 'Power',
            column: _MoveSortColumn.power,
            activeColumn: sortColumn,
            sortAscending: sortAscending,
            width: _movePowerColumnWidth,
            alignment: Alignment.center,
            onSort: onSort,
          ),
          _MoveHeaderCell(
            label: 'Accuracy',
            column: _MoveSortColumn.accuracy,
            activeColumn: sortColumn,
            sortAscending: sortAscending,
            width: _moveAccuracyColumnWidth,
            alignment: Alignment.center,
            onSort: onSort,
          ),
          _MoveHeaderCell(
            label: 'PP',
            column: _MoveSortColumn.pp,
            activeColumn: sortColumn,
            sortAscending: sortAscending,
            width: _movePpColumnWidth,
            alignment: Alignment.center,
            onSort: onSort,
          ),
        ],
      ),
    );
  }
}

class _LearnableMoveFilters extends StatelessWidget {
  const _LearnableMoveFilters({
    required this.selectedType,
    required this.selectedCategory,
    required this.onTypeChanged,
    required this.onCategoryChanged,
  });

  final Type? selectedType;
  final MoveCategory? selectedCategory;
  final ValueChanged<Type?> onTypeChanged;
  final ValueChanged<MoveCategory?> onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _LearnableTypeFilterButton(
          selectedType: selectedType,
          onChanged: onTypeChanged,
        ),
        _LearnableCategoryFilterButton(
          selectedCategory: selectedCategory,
          onChanged: onCategoryChanged,
        ),
      ],
    );
  }
}

class _LearnableTypeFilterButton extends StatelessWidget {
  const _LearnableTypeFilterButton({
    required this.selectedType,
    required this.onChanged,
  });

  final Type? selectedType;
  final ValueChanged<Type?> onChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Filter by type',
      onSelected: (String value) {
        onChanged(
          value == _allMoveTypesValue ? null : Type.values.byName(value),
        );
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        _typeMenuItem(null, selectedType == null),
        ...Type.values.map(
          (Type type) => _typeMenuItem(type, selectedType == type),
        ),
      ],
      child: _LearnableFilterButtonShell(
        icon: selectedType == null
            ? const Icon(Icons.category_outlined, size: 18)
            : Image.asset(selectedType!.imageURL, width: 20, height: 20),
        label: selectedType?.displayName ?? 'All Types',
      ),
    );
  }

  PopupMenuItem<String> _typeMenuItem(Type? type, bool selected) {
    return PopupMenuItem<String>(
      value: type?.name ?? _allMoveTypesValue,
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

class _LearnableCategoryFilterButton extends StatelessWidget {
  const _LearnableCategoryFilterButton({
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
          value == _allMoveCategoriesValue
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
      child: _LearnableFilterButtonShell(
        icon: Icon(
          _moveCategoryIcon(selectedCategory),
          size: 18,
          color: selectedCategory == null
              ? null
              : _moveCategoryColor(selectedCategory!),
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
      value: category?.name ?? _allMoveCategoriesValue,
      child: Row(
        children: [
          Icon(
            _moveCategoryIcon(category),
            size: 18,
            color: category == null ? null : _moveCategoryColor(category),
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

class _LearnableFilterButtonShell extends StatelessWidget {
  const _LearnableFilterButtonShell({required this.icon, required this.label});

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

class _MoveHeaderCell extends StatelessWidget {
  const _MoveHeaderCell({
    required this.label,
    required this.column,
    required this.activeColumn,
    required this.sortAscending,
    this.width,
    required this.onSort,
    this.alignment = Alignment.centerLeft,
  });

  final String label;
  final _MoveSortColumn column;
  final _MoveSortColumn activeColumn;
  final bool sortAscending;
  final double? width;
  final Alignment alignment;
  final ValueChanged<_MoveSortColumn> onSort;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool active = column == activeColumn;

    return SizedBox(
      width: width,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => onSort(column),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Align(
            alignment: alignment,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: active
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  active
                      ? sortAscending
                            ? Icons.arrow_upward_rounded
                            : Icons.arrow_downward_rounded
                      : Icons.unfold_more_rounded,
                  size: 15,
                  color: active
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LearnableMoveTile extends StatelessWidget {
  const _LearnableMoveTile({required this.move});

  final Move move;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      ),
      child: Row(
        children: [
          SizedBox(
            width: _moveTypeColumnWidth,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Tooltip(
                message: move.type.displayName,
                child: Image.asset(move.type.imageURL, width: 30, height: 30),
              ),
            ),
          ),
          Expanded(
            child: Text(
              move.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                fontFamily: 'RobotoCondensed',
              ),
            ),
          ),
          SizedBox(
            width: _moveCategoryColumnWidth,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _MoveCategoryCell(category: move.category),
            ),
          ),
          _MoveStat(
            width: _movePowerColumnWidth,
            value: move.power == 0 ? '-' : '${move.power}',
          ),
          _MoveStat(
            width: _moveAccuracyColumnWidth,
            value: move.accuracy == 0 ? '-' : '${move.accuracy}%',
          ),
          _MoveStat(width: _movePpColumnWidth, value: '${move.pp}'),
        ],
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
    final Color color = _moveCategoryColor(category);

    return Row(
      children: [
        Icon(_moveCategoryIcon(category), size: 18, color: color),
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

class _MoveStat extends StatelessWidget {
  const _MoveStat({required this.width, required this.value});

  final double width;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SizedBox(
      width: width,
      child: Text(
        value,
        textAlign: TextAlign.center,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w800,
          fontFamily: 'RobotoCondensed',
        ),
      ),
    );
  }
}

String _moveCategoryLabel(MoveCategory category) {
  return switch (category) {
    MoveCategory.physical => 'Physical',
    MoveCategory.special => 'Special',
    MoveCategory.status => 'Status',
  };
}

Color _moveCategoryColor(MoveCategory category) {
  return switch (category) {
    MoveCategory.physical => Colors.orange,
    MoveCategory.special => Colors.blue,
    MoveCategory.status => Colors.grey,
  };
}

IconData _moveCategoryIcon(MoveCategory? category) {
  return switch (category) {
    MoveCategory.physical => Icons.fitness_center_rounded,
    MoveCategory.special => Icons.auto_awesome_rounded,
    MoveCategory.status => Icons.shield_rounded,
    null => Icons.tune_rounded,
  };
}

class _VariantButtonData {
  const _VariantButtonData({required this.label, required this.entry});

  final String label;
  final PokemonListItem entry;
}

class _StatBarData {
  const _StatBarData({
    required this.label,
    required this.value,
    required this.maxValue,
    required this.color,
  });

  final String label;
  final int value;
  final int maxValue;
  final Color color;
}

class _StatBarRow extends StatelessWidget {
  const _StatBarRow({required this.stat});

  final _StatBarData stat;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double progress = (stat.value / stat.maxValue).clamp(0, 1).toDouble();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 76,
          child: Text(
            stat.label,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 14,
              color: stat.color,
              backgroundColor: stat.color.withValues(alpha: 0.14),
            ),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 54,
          child: Text(
            '${stat.value}',
            textAlign: TextAlign.right,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
