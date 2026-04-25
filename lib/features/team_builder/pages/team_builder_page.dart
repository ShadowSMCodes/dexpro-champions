import 'dart:math' as math;

import 'package:dexpro/core/models/pokemon_list_item.dart';
import 'package:dexpro/core/models/type.dart';
import 'package:dexpro/core/providers/app_details_provider.dart';
import 'package:dexpro/core/utils/saved_configs_store.dart';
import 'package:dexpro/core/widgets/pokemon_selector_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeamBuilderPage extends StatefulWidget {
  const TeamBuilderPage({super.key});

  @override
  State<TeamBuilderPage> createState() => _TeamBuilderPageState();
}

class _TeamBuilderPageState extends State<TeamBuilderPage> {
  static const String _savedTeamsKey = 'saved_team_builder_teams_v2';
  static const int _teamSize = 6;

  late final List<PokemonListItem> _availablePokemon;
  late final List<PokemonListItem?> _teamSlots;

  @override
  void initState() {
    super.initState();
    _availablePokemon = buildSelectablePokemonEntries();
    _teamSlots = List<PokemonListItem?>.filled(_teamSize, null);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isCompact = context.watch<AppDetailsProvider>().isCompact;
    final List<_TypeScoreData> typeScores = Type.values
        .map((Type type) => _buildTypeScoreData(type))
        .toList(growable: false);

    return SingleChildScrollView(
      key: const ValueKey('team-builder-page'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Team Builder',
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
              fontFamily: 'RobotoCondensed',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isCompact
                ? 'Review how your team stacks up'
                : 'Pick up to six Pokemon and review how your team stacks up across all attack types.',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontFamily: 'RobotoCondensed',
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: EdgeInsets.all(isCompact ? 16 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Team Slots',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontFamily: 'RobotoCondensed',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.tonalIcon(
                          onPressed: _saveTeam,
                          icon: const Icon(Icons.save_rounded),
                          label: const Text('Save Team'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.tonalIcon(
                          onPressed: _loadTeam,
                          icon: const Icon(Icons.folder_open_rounded),
                          label: const Text('Load Team'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                          const double spacing = 12;
                          final int crossAxisCount =
                              (constraints.maxWidth / (isCompact ? 150 : 176))
                                  .floor()
                                  .clamp(1, _teamSize);
                          final double tileWidth =
                              (constraints.maxWidth -
                                  ((crossAxisCount - 1) * spacing)) /
                              crossAxisCount;

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _teamSize,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: spacing,
                                  mainAxisSpacing: spacing,
                                  mainAxisExtent: isCompact
                                      ? tileWidth
                                      : math.max(156, tileWidth * 0.94),
                                ),
                            itemBuilder: (BuildContext context, int index) {
                              return _TeamSlotCard(
                                entry: _teamSlots[index],
                                onTap: () => _openPokemonPicker(index),
                                onClear: _teamSlots[index] == null
                                    ? null
                                    : () {
                                        setState(() {
                                          _teamSlots[index] = null;
                                        });
                                      },
                              );
                            },
                          );
                        },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: EdgeInsets.all(isCompact ? 16 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Type Tally',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontFamily: 'RobotoCondensed',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Check the team's type coverage across all types",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontFamily: 'RobotoCondensed',
                    ),
                  ),
                  const SizedBox(height: 20),
                  LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                          final int crossAxisCount = _typeTallyColumnCount(
                            constraints.maxWidth,
                            isCompact,
                          );

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: typeScores.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 14,
                                  mainAxisSpacing: isCompact ? 8 : 10,
                                  mainAxisExtent: isCompact ? 54 : 64,
                                ),
                            itemBuilder: (BuildContext context, int index) {
                              return _TypeTallyCard(
                                data: typeScores[index],
                                isCompact: isCompact,
                              );
                            },
                          );
                        },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _typeTallyColumnCount(double width, bool isCompact) {
    if (isCompact) {
      return math.max(2, (width / 300).floor()).clamp(2, 3);
    }

    if (width >= 1440) {
      return 6;
    }

    if (width >= 840) {
      return 3;
    }

    if (width >= 560) {
      return 2;
    }

    return 1;
  }

  void _showThemedSnackBar(String message) {
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

  Future<void> _openPokemonPicker(int slotIndex) async {
    final PokemonListItem? selected = await showPokemonSelectorDialog(
      super.context,
      pokemon: _availablePokemon,
      title: 'Select Pokémon',
    );

    if (selected == null) {
      return;
    }

    setState(() {
      _teamSlots[slotIndex] = selected;
    });
  }

  Future<void> _saveTeam() async {
    final List<String> slugs = _teamSlots
        .whereType<PokemonListItem>()
        .map((PokemonListItem item) => item.slug)
        .toList(growable: false);
    if (slugs.isEmpty) {
      _showThemedSnackBar('Cannot save an empty team');
      return;
    }

    final SaveAppendResult result =
        await SavedConfigsStore.append(_savedTeamsKey, <String, dynamic>{
          'slots': _teamSlots
              .map((PokemonListItem? item) => item?.slug)
              .toList(growable: false),
        });

    if (mounted) {
      _showThemedSnackBar(switch (result) {
        SaveAppendResult.saved => 'Team saved',
        SaveAppendResult.duplicate => 'That team is already saved',
        SaveAppendResult.failed => 'Could not save team',
      });
    }
  }

  Future<void> _loadTeam() async {
    final List<Map<String, dynamic>> configs = await SavedConfigsStore.load(
      _savedTeamsKey,
    );
    if (!mounted) {
      return;
    }
    if (configs.isEmpty) {
      await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Load Team'),
            content: const Text('No teams saved.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
      return;
    }

    final Map<String, PokemonListItem> bySlug = <String, PokemonListItem>{
      for (final PokemonListItem entry in _availablePokemon) entry.slug: entry,
    };

    final List<Map<String, dynamic>> dialogConfigs =
        configs
            .map((Map<String, dynamic> item) => Map<String, dynamic>.from(item))
            .toList(growable: true);

    final Map<String, dynamic>? selected = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (
            BuildContext context,
            void Function(void Function()) setDialogState,
          ) {
            return AlertDialog(
              title: const Text('Load Team'),
              content: SizedBox(
                width: 560,
                child: dialogConfigs.isEmpty
                    ? const Text('No teams saved.')
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: dialogConfigs.length,
                        separatorBuilder: (_, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (BuildContext context, int index) {
                          final List<dynamic> slots =
                              dialogConfigs[index]['slots'] as List<dynamic>? ??
                              <dynamic>[];
                          final List<PokemonListItem> entries = slots
                              .whereType<String>()
                              .map((String slug) => bySlug[slug])
                              .whereType<PokemonListItem>()
                              .toList(growable: false);

                          return ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            tileColor: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest
                                .withValues(alpha: 0.22),
                            title: Text('Saved Team ${index + 1}'),
                            subtitle: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: entries
                                  .map(
                                    (PokemonListItem entry) => Image.asset(
                                      '${entry.assetImagePath}.png',
                                      width: 44,
                                      height: 44,
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                  .toList(growable: false),
                            ),
                            trailing: IconButton(
                              onPressed: () async {
                                final Map<String, dynamic> config =
                                    dialogConfigs[index];
                                setDialogState(() {
                                  dialogConfigs.removeAt(index);
                                });
                                final bool removed =
                                    await SavedConfigsStore.saveAll(
                                      _savedTeamsKey,
                                      dialogConfigs,
                                    );
                                if (!context.mounted) {
                                  return;
                                }
                                if (removed) {
                                  if (mounted) {
                                    _showThemedSnackBar('Saved team deleted');
                                  }
                                } else {
                                  setDialogState(() {
                                    dialogConfigs.insert(index, config);
                                  });
                                  if (mounted) {
                                    _showThemedSnackBar('Could not delete team');
                                  }
                                }
                              },
                              icon: const Icon(Icons.close_rounded),
                              tooltip: 'Delete saved team',
                            ),
                            onTap: () =>
                                Navigator.of(context).pop(dialogConfigs[index]),
                          );
                        },
                      ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );

    if (selected == null) {
      return;
    }

    final List<dynamic> slots =
        selected['slots'] as List<dynamic>? ?? <dynamic>[];
    setState(() {
      for (int index = 0; index < _teamSize; index++) {
        final String? slug = index < slots.length
            ? slots[index] as String?
            : null;
        _teamSlots[index] = slug == null ? null : bySlug[slug];
      }
    });
  }

  _TypeScoreData _buildTypeScoreData(Type attackType) {
    final List<_PokemonTypeMultiplier> multipliers = <_PokemonTypeMultiplier>[];
    double product = 1;

    for (final PokemonListItem? entry in _teamSlots) {
      if (entry == null) {
        continue;
      }

      final double multiplier = Type.combinedEffectivenessAgainst(
        attackType,
        entry.pokemon.type1,
        entry.pokemon.type2,
      );
      final double normalizedMultiplier = multiplier == 0 ? 0.25 : multiplier;
      product *= normalizedMultiplier;
      multipliers.add(
        _PokemonTypeMultiplier(
          name: entry.displayName,
          multiplier: multiplier,
          normalizedMultiplier: normalizedMultiplier,
        ),
      );
    }

    final double score = multipliers.isEmpty ? 0 : math.log(product) / math.ln2;

    return _TypeScoreData(
      type: attackType,
      score: score,
      product: product,
      multipliers: multipliers,
    );
  }
}

class _TeamSlotCard extends StatelessWidget {
  const _TeamSlotCard({
    required this.entry,
    required this.onTap,
    required this.onClear,
  });

  final PokemonListItem? entry;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.32),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: entry == null
                    ? Center(
                        child: Icon(
                          Icons.add_rounded,
                          size: 34,
                          color: theme.colorScheme.primary,
                        ),
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: Image.asset(
                              '${entry!.assetImagePath}.png',
                              fit: BoxFit.contain,
                              errorBuilder:
                                  (
                                    BuildContext context,
                                    Object error,
                                    StackTrace? stackTrace,
                                  ) {
                                    return Icon(
                                      Icons.catching_pokemon_rounded,
                                      size: 30,
                                      color: theme.colorScheme.primary,
                                    );
                                  },
                            ),
                          ),
                          const SizedBox(height: 0),
                          Text(
                            entry!.displayName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontFamily: 'RobotoCondensed',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              _TypeIcon(type: entry!.pokemon.type1),
                              if (entry!.pokemon.type2 != null)
                                _TypeIcon(type: entry!.pokemon.type2!),
                            ],
                          ),
                        ],
                      ),
              ),
            ),
            if (entry != null)
              Positioned(
                top: 8,
                right: 8,
                child: IconButton.filledTonal(
                  onPressed: onClear,
                  icon: const Icon(Icons.close_rounded, size: 18),
                  tooltip: 'Clear slot',
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TypeIcon extends StatelessWidget {
  const _TypeIcon({required this.type});

  final Type type;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      type.imageURL,
      width: 24,
      height: 24,
      fit: BoxFit.contain,
    );
  }
}

class _TypeScoreData {
  const _TypeScoreData({
    required this.type,
    required this.score,
    required this.product,
    required this.multipliers,
  });

  final Type type;
  final double score;
  final double product;
  final List<_PokemonTypeMultiplier> multipliers;
}

class _PokemonTypeMultiplier {
  const _PokemonTypeMultiplier({
    required this.name,
    required this.multiplier,
    required this.normalizedMultiplier,
  });

  final String name;
  final double multiplier;
  final double normalizedMultiplier;
}

class _TypeTallyCard extends StatelessWidget {
  const _TypeTallyCard({required this.data, required this.isCompact});

  final _TypeScoreData data;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isPositive = data.score < 0;
    final bool isNegative = data.score > 0;
    final Color activeColor = isPositive
        ? const Color(0xFF22C55E)
        : isNegative
        ? const Color(0xFFF97316)
        : theme.colorScheme.outlineVariant;
    final int filledCells = data.score.abs().round().clamp(0, 8);
    final String tooltipMessage = data.multipliers.isEmpty
        ? 'No Pokemon selected.\nFinal multiplier: 1x'
        : [
            ...data.multipliers.map(
              (_PokemonTypeMultiplier item) =>
                  '${item.name}: ${_formatMultiplier(item.multiplier)}x'
                  '${item.multiplier == 0 ? ' (uses ${_formatMultiplier(item.normalizedMultiplier)}x for tally)' : ''}',
            ),
            'Final multiplier: ${_formatMultiplier(data.product)}x',
          ].join('\n');

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 10 : 14,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.28,
        ),
      ),
      child: Row(
        children: [
          Tooltip(
            message: tooltipMessage,
            child: SizedBox(
              width: 44,
              height: 44,
              child: Image.asset(data.type.imageURL, fit: BoxFit.contain),
            ),
          ),
          SizedBox(width: isCompact ? 6 : 10),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: List<Widget>.generate(
                8,
                (int index) => Padding(
                  padding: EdgeInsets.only(right: index == 7 ? 0 : 2),
                  child: Container(
                    width: isCompact ? 5 : 7,
                    height: isCompact ? 34 : 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: index < filledCells
                          ? activeColor
                          : theme.colorScheme.outlineVariant.withValues(
                              alpha: 0.28,
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatMultiplier(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }
    if ((value * 10).roundToDouble() == value * 10) {
      return value.toStringAsFixed(1);
    }
    return value.toStringAsFixed(2);
  }
}
