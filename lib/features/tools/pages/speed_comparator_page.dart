import 'package:dexpro/core/models/pokemon_list_item.dart';
import 'package:dexpro/core/models/stats.dart';
import 'package:dexpro/core/providers/app_details_provider.dart';
import 'package:dexpro/core/utils/saved_configs_store.dart';
import 'package:dexpro/core/widgets/pokemon_selector_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpeedComparatorPage extends StatefulWidget {
  const SpeedComparatorPage({super.key});

  @override
  State<SpeedComparatorPage> createState() => _SpeedComparatorPageState();
}

class _SpeedComparatorPageState extends State<SpeedComparatorPage> {
  static const String _speedConfigKey = 'speed_comparison_configs_v2';
  late final List<PokemonListItem> _availablePokemon;
  late final _SpeedSideState _leftState;
  late final _SpeedSideState _rightState;

  @override
  void initState() {
    super.initState();
    _availablePokemon = buildSelectablePokemonEntries();
    final PokemonListItem? defaultPokemon = _availablePokemon.isNotEmpty
        ? _availablePokemon.first
        : null;
    _leftState = _SpeedSideState(pokemon: defaultPokemon);
    _rightState = _SpeedSideState(pokemon: defaultPokemon);
    _rightState.nature = _SpeedNature.minus;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isCompact = context.watch<AppDetailsProvider>().isCompact;
    final int leftSpeed = _calculatedSpeed(_leftState);
    final int rightSpeed = _calculatedSpeed(_rightState);

    return SingleChildScrollView(
      key: const ValueKey('speed-comparator-page'),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool stackSections = isCompact || constraints.maxWidth < 1180;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Speed Comparison',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  fontFamily: 'RobotoCondensed',
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Compare Speeds of any Two Pokemon',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontFamily: 'RobotoCondensed',
                ),
              ),
              const SizedBox(height: 24),
              if (stackSections)
                Column(
                  children: [
                    _SpeedSideCard(
                      title: 'Pokemon A',
                      state: _leftState,
                      calculatedSpeed: leftSpeed,
                      isWinner: leftSpeed > rightSpeed,
                      availablePokemon: _availablePokemon,
                      onSave: () => _saveConfig(_leftState),
                      onLoad: () => _loadConfig(_leftState),
                      onChanged: () => setState(() {}),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: _VsColumn(compact: true),
                    ),
                    _SpeedSideCard(
                      title: 'Pokemon B',
                      state: _rightState,
                      calculatedSpeed: rightSpeed,
                      isWinner: rightSpeed > leftSpeed,
                      availablePokemon: _availablePokemon,
                      onSave: () => _saveConfig(_rightState),
                      onLoad: () => _loadConfig(_rightState),
                      onChanged: () => setState(() {}),
                    ),
                  ],
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _SpeedSideCard(
                        title: 'Pokemon A',
                        state: _leftState,
                        calculatedSpeed: leftSpeed,
                        isWinner: leftSpeed > rightSpeed,
                        availablePokemon: _availablePokemon,
                        onSave: () => _saveConfig(_leftState),
                        onLoad: () => _loadConfig(_leftState),
                        onChanged: () => setState(() {}),
                      ),
                    ),
                    SizedBox(width: 140, child: _VsColumn(compact: false)),
                    Expanded(
                      child: _SpeedSideCard(
                        title: 'Pokemon B',
                        state: _rightState,
                        calculatedSpeed: rightSpeed,
                        isWinner: rightSpeed > leftSpeed,
                        availablePokemon: _availablePokemon,
                        onSave: () => _saveConfig(_rightState),
                        onLoad: () => _loadConfig(_rightState),
                        onChanged: () => setState(() {}),
                      ),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }

  int _calculatedSpeed(_SpeedSideState state) {
    final int baseSpeed = state.pokemon?.pokemon.stats.spe ?? 0;
    return Stats.championSpeedValue(
      baseSpeed: baseSpeed,
      spValue: state.speedSp,
      alignment: state.nature.alignment,
      stage: state.speedStage,
      hasAbilityBoost: state.hasAbilitySpeedBoost,
      hasChoiceScarf: state.hasChoiceScarf,
      hasTailwind: state.hasTailwind,
      hasParalysis: state.hasParalysis,
    );
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

  Future<void> _saveConfig(_SpeedSideState state) async {
    if (state.pokemon == null) {
      return;
    }

    final SaveAppendResult result =
        await SavedConfigsStore.append(_speedConfigKey, <String, dynamic>{
          'pokemonSlug': state.pokemon!.slug,
          'nature': state.nature.name,
          'speedSp': state.speedSp,
          'hasAbilitySpeedBoost': state.hasAbilitySpeedBoost,
          'hasChoiceScarf': state.hasChoiceScarf,
          'hasTailwind': state.hasTailwind,
          'hasParalysis': state.hasParalysis,
          'speedStage': state.speedStage,
        });

    if (mounted) {
      _showThemedSnackBar(switch (result) {
        SaveAppendResult.saved => 'Speed config saved',
        SaveAppendResult.duplicate => 'That speed config is already saved',
        SaveAppendResult.failed => 'Could not save speed config',
      });
    }
  }

  Future<void> _loadConfig(_SpeedSideState state) async {
    final List<Map<String, dynamic>> configs = await SavedConfigsStore.load(
      _speedConfigKey,
    );
    final Map<String, PokemonListItem> bySlug = <String, PokemonListItem>{
      for (final PokemonListItem entry in _availablePokemon) entry.slug: entry,
    };
    if (!mounted) {
      return;
    }
    if (configs.isEmpty) {
      await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Load Speed Config'),
            content: const Text('No configs saved.'),
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
              title: const Text('Load Speed Config'),
              content: SizedBox(
                width: 560,
                child: dialogConfigs.isEmpty
                    ? const Text('No configs saved.')
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: dialogConfigs.length,
                        separatorBuilder: (_, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (BuildContext context, int index) {
                          final Map<String, dynamic> config =
                              dialogConfigs[index];
                          final PokemonListItem? pokemon =
                              bySlug[config['pokemonSlug']];
                          final List<String> selectedChecks = <String>[
                            if (config['hasAbilitySpeedBoost'] == true)
                              'Ability x2',
                            if (config['hasChoiceScarf'] == true)
                              'Choice Scarf x2',
                            if (config['hasTailwind'] == true) 'Tailwind x2',
                            if (config['hasParalysis'] == true)
                              'Paralysis x0.5',
                          ];
                          final String natureLabel = switch (config['nature']) {
                            'plus' => '+',
                            'minus' => '-',
                            _ => 'Neutral',
                          };

                          return ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            tileColor: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest
                                .withValues(alpha: 0.22),
                            leading: pokemon != null
                                ? Image.asset(
                                    '${pokemon.assetImagePath}.png',
                                    width: 52,
                                    height: 52,
                                    fit: BoxFit.contain,
                                  )
                                : null,
                            title: Text(pokemon?.displayName ?? 'Unknown Pokémon'),
                            subtitle: Text(
                              [
                                'Speed Nature: $natureLabel',
                                'SP: ${config['speedSp']}',
                                if (selectedChecks.isNotEmpty)
                                  selectedChecks.join(', '),
                                'Speed Stage: ${config['speedStage']}',
                              ].join('\n'),
                              style: Theme.of(context).textTheme.bodySmall,
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
                                      _speedConfigKey,
                                      dialogConfigs,
                                    );
                                if (!context.mounted) {
                                  return;
                                }
                                if (removed) {
                                  if (mounted) {
                                    _showThemedSnackBar('Saved config deleted');
                                  }
                                } else {
                                  setDialogState(() {
                                    dialogConfigs.insert(index, config);
                                  });
                                  if (mounted) {
                                    _showThemedSnackBar(
                                      'Could not delete speed config',
                                    );
                                  }
                                }
                              },
                              icon: const Icon(Icons.close_rounded),
                              tooltip: 'Delete saved config',
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

    setState(() {
      state.pokemon = bySlug[selected['pokemonSlug']] ?? state.pokemon;
      state.nature = _SpeedNature.values.firstWhere(
        (_SpeedNature item) => item.name == selected['nature'],
        orElse: () => _SpeedNature.neutral,
      );
      state.speedSp = (selected['speedSp'] as num?)?.toInt() ?? 32;
      state.hasAbilitySpeedBoost =
          selected['hasAbilitySpeedBoost'] as bool? ?? false;
      state.hasChoiceScarf = selected['hasChoiceScarf'] as bool? ?? false;
      state.hasTailwind = selected['hasTailwind'] as bool? ?? false;
      state.hasParalysis = selected['hasParalysis'] as bool? ?? false;
      state.speedStage = (selected['speedStage'] as num?)?.toInt() ?? 0;
    });
  }
}

class _SpeedSideState {
  _SpeedSideState({this.pokemon})
    : nature = _SpeedNature.plus,
      speedSp = 32,
      hasAbilitySpeedBoost = false,
      hasChoiceScarf = false,
      speedStage = 0,
      hasTailwind = false,
      hasParalysis = false;

  PokemonListItem? pokemon;
  _SpeedNature nature;
  int speedSp;
  bool hasAbilitySpeedBoost;
  bool hasChoiceScarf;
  int speedStage;
  bool hasTailwind;
  bool hasParalysis;

  void reset() {
    nature = _SpeedNature.plus;
    speedSp = 32;
    hasAbilitySpeedBoost = false;
    hasChoiceScarf = false;
    speedStage = 0;
    hasTailwind = false;
    hasParalysis = false;
  }
}

enum _SpeedNature {
  plus(' + Speed', 1.1),
  neutral('Neutral Speed', 1.0),
  minus(' - Speed', 0.9);

  const _SpeedNature(this.label, this.alignment);

  final String label;
  final double alignment;
}

class _SpeedSideCard extends StatelessWidget {
  const _SpeedSideCard({
    required this.title,
    required this.state,
    required this.calculatedSpeed,
    required this.isWinner,
    required this.availablePokemon,
    required this.onSave,
    required this.onLoad,
    required this.onChanged,
  });

  final String title;
  final _SpeedSideState state;
  final int calculatedSpeed;
  final bool isWinner;
  final List<PokemonListItem> availablePokemon;
  final VoidCallback onSave;
  final VoidCallback onLoad;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isCompact = context.watch<AppDetailsProvider>().isCompact;
    final PokemonListItem? pokemon = state.pokemon;
    final int baseSpeed = pokemon?.pokemon.stats.spe ?? 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isWinner ? const Color(0xFF14B8A6) : Colors.black,
          width: isWinner ? 3 : 1.2,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            theme.colorScheme.surface,
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.26),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              fontFamily: 'RobotoCondensed',
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isWinner ? const Color(0xFF14B8A6) : Colors.black,
                width: isWinner ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _PickerButton(
                    label: pokemon?.displayName ?? 'Select a Pokémon',
                    assetImagePath: pokemon?.assetImagePath,
                    onPressed: () async {
                      final PokemonListItem? selected =
                          await showPokemonSelectorDialog(
                            context,
                            pokemon: availablePokemon,
                            title: 'Select a Pokémon',
                          );
                      if (selected == null) {
                        return;
                      }
                      state.pokemon = selected;
                      onChanged();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton.tonalIcon(
                  onPressed: () {
                    state.reset();
                    onChanged();
                  },
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Reset'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: onSave,
                  icon: const Icon(Icons.save_rounded),
                  label: const Text('Save'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: onLoad,
                  icon: const Icon(Icons.folder_open_rounded),
                  label: const Text('Load'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isWinner
                    ? const Color(0xFF14B8A6).withValues(alpha: 0.85)
                    : Colors.black,
                width: isWinner ? 2 : 1,
              ),
              color: isWinner
                  ? const Color(0xFF14B8A6).withValues(alpha: 0.08)
                  : theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.16,
                    ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Calculated Speed',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontFamily: 'RobotoCondensed',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      '$calculatedSpeed',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: const Color(0xFF14B8A6),
                        fontFamily: 'RobotoCondensed',
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Base Speed',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontFamily: 'RobotoCondensed',
                        ),
                      ),
                    ),
                    Text(
                      '$baseSpeed',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontFamily: 'RobotoCondensed',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                if (isWinner) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Wins Speed Check',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: const Color(0xFF14B8A6),
                        fontFamily: 'RobotoCondensed',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Speed Nature',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontFamily: 'RobotoCondensed',
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _SpeedNature.values
                .map(
                  (_SpeedNature nature) => ChoiceChip(
                    label: Text(nature.label),
                    selected: state.nature == nature,
                    onSelected: (_) {
                      state.nature = nature;
                      onChanged();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    labelStyle: theme.textTheme.bodyMedium?.copyWith(
                      fontFamily: 'RobotoCondensed',
                      fontWeight: FontWeight.w700,
                    ),
                    selectedColor: theme.colorScheme.primary.withValues(
                      alpha: 0.18,
                    ),
                    side: BorderSide(
                      color: state.nature == nature
                          ? theme.colorScheme.primary.withValues(alpha: 0.55)
                          : theme.colorScheme.outlineVariant.withValues(
                              alpha: 0.45,
                            ),
                    ),
                  ),
                )
                .toList(growable: false),
          ),
          const SizedBox(height: 20),
          _LabeledSlider(
            title: 'Speed SPs',
            value: state.speedSp.toDouble(),
            min: 0,
            max: 32,
            divisions: 32,
            labels: const <String>['0', '8', '16', '24', '32'],
            onChanged: (double value) {
              state.speedSp = value.round();
              onChanged();
            },
          ),
          const SizedBox(height: 12),
          if (isCompact)
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _CompactCheckbox(
                        label: 'Choice Scarf',
                        subtitle: 'x2 speed',
                        value: state.hasChoiceScarf,
                        onChanged: (bool? value) {
                          state.hasChoiceScarf = value ?? false;
                          onChanged();
                        },
                      ),
                    ),
                    Expanded(
                      child: _CompactCheckbox(
                        label: 'Ability',
                        subtitle: 'x2 speed',
                        value: state.hasAbilitySpeedBoost,
                        onChanged: (bool? value) {
                          state.hasAbilitySpeedBoost = value ?? false;
                          onChanged();
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _CompactCheckbox(
                        label: 'Tailwind',
                        subtitle: 'x2 speed',
                        value: state.hasTailwind,
                        onChanged: (bool? value) {
                          state.hasTailwind = value ?? false;
                          onChanged();
                        },
                      ),
                    ),
                    Expanded(
                      child: _CompactCheckbox(
                        label: 'Paralysis',
                        subtitle: 'x0.5 speed',
                        value: state.hasParalysis,
                        onChanged: (bool? value) {
                          state.hasParalysis = value ?? false;
                          onChanged();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _CompactCheckbox(
                    label: 'Choice Scarf',
                    subtitle: 'x2 speed',
                    value: state.hasChoiceScarf,
                    onChanged: (bool? value) {
                      state.hasChoiceScarf = value ?? false;
                      onChanged();
                    },
                  ),
                ),
                Expanded(
                  child: _CompactCheckbox(
                    label: 'Ability',
                    subtitle: 'x2 speed',
                    value: state.hasAbilitySpeedBoost,
                    onChanged: (bool? value) {
                      state.hasAbilitySpeedBoost = value ?? false;
                      onChanged();
                    },
                  ),
                ),
                Expanded(
                  child: _CompactCheckbox(
                    label: 'Tailwind',
                    subtitle: 'x2 speed',
                    value: state.hasTailwind,
                    onChanged: (bool? value) {
                      state.hasTailwind = value ?? false;
                      onChanged();
                    },
                  ),
                ),
                Expanded(
                  child: _CompactCheckbox(
                    label: 'Paralysis',
                    subtitle: 'x0.5 speed',
                    value: state.hasParalysis,
                    onChanged: (bool? value) {
                      state.hasParalysis = value ?? false;
                      onChanged();
                    },
                  ),
                ),
              ],
            ),
          const SizedBox(height: 20),
          _LabeledSlider(
            title: 'Speed Stage',
            value: state.speedStage.toDouble(),
            min: -6,
            max: 6,
            divisions: 12,
            labels: const <String>[
              '-6',
              '-5',
              '-4',
              '-3',
              '-2',
              '-1',
              '0',
              '+1',
              '+2',
              '+3',
              '+4',
              '+5',
              '+6',
            ],
            onChanged: (double value) {
              state.speedStage = value.round();
              onChanged();
            },
          ),
        ],
      ),
    );
  }
}

class _VsColumn extends StatelessWidget {
  const _VsColumn({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SizedBox(
      height: compact ? null : 560,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'vs.',
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: theme.colorScheme.primary,
                fontFamily: 'RobotoCondensed',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerButton extends StatelessWidget {
  const _PickerButton({
    required this.label,
    required this.onPressed,
    this.assetImagePath,
  });

  final String label;
  final VoidCallback onPressed;
  final String? assetImagePath;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      child: Row(
        children: [
          if (assetImagePath != null) ...[
            Image.asset('$assetImagePath.png', width: 28, height: 28),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontFamily: 'RobotoCondensed',
              ),
            ),
          ),
          const Icon(Icons.arrow_drop_down_rounded),
        ],
      ),
    );
  }
}

class _LabeledSlider extends StatelessWidget {
  const _LabeledSlider({
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.labels,
    required this.onChanged,
  });

  final String title;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final List<String> labels;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title: ${value.round()}',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            fontFamily: 'RobotoCondensed',
          ),
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: labels
              .map(
                (String label) => Expanded(
                  child: Text(
                    label,
                    textAlign: label == labels.first
                        ? TextAlign.left
                        : label == labels.last
                        ? TextAlign.right
                        : TextAlign.center,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontFamily: 'RobotoCondensed',
                    ),
                  ),
                ),
              )
              .toList(growable: false),
        ),
      ],
    );
  }
}

class _CompactCheckbox extends StatelessWidget {
  const _CompactCheckbox({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return CheckboxListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      value: value,
      title: Text(
        label,
        style: theme.textTheme.titleSmall?.copyWith(
          fontFamily: 'RobotoCondensed',
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          fontFamily: 'RobotoCondensed',
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      onChanged: onChanged,
    );
  }
}
