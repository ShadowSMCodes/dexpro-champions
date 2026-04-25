import 'package:dexpro/core/models/pokemon_list_item.dart';
import 'package:dexpro/core/models/stats.dart';
import 'package:dexpro/core/providers/app_details_provider.dart';
import 'package:dexpro/core/widgets/pokemon_selector_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EvsToChampionStatsPage extends StatefulWidget {
  const EvsToChampionStatsPage({super.key});

  @override
  State<EvsToChampionStatsPage> createState() => _EvsToChampionStatsPageState();
}

class _EvsToChampionStatsPageState extends State<EvsToChampionStatsPage> {
  static const int _maxTotalSp = 66;
  static const int _maxTotalEv = 516;
  static const int _maxStatSp = 32;
  static const int _maxStatEv = 252;

  late final List<PokemonListItem> _availablePokemon;

  PokemonListItem? _selectedPokemon;
  _NatureOption _selectedNature = _neutralNature;
  final Map<_StatKey, int> _evValues = <_StatKey, int>{
    for (final _StatKey stat in _statOrder) stat: 0,
  };
  final Map<_StatKey, int> _spValues = <_StatKey, int>{
    for (final _StatKey stat in _statOrder) stat: 0,
  };
  final Map<_StatKey, _SliderMode> _sliderModes = <_StatKey, _SliderMode>{
    for (final _StatKey stat in _statOrder) stat: _SliderMode.sp,
  };

  @override
  void initState() {
    super.initState();
    _availablePokemon = buildSelectablePokemonEntries();
    _selectedPokemon = _availablePokemon.isNotEmpty
        ? _availablePokemon.first
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isCompact = context.watch<AppDetailsProvider>().isCompact;
    final int totalSp = _totalSp;
    final int totalEv = _totalEv;

    return SingleChildScrollView(
      key: const ValueKey('evs-to-champion-stats-page'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Showdown EVs to Champion SPs',
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
              fontFamily: 'RobotoCondensed',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Convert Showdown EVs into the new 66-point Champions format with live sliders.',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontFamily: 'RobotoCondensed',
            ),
          ),
          const SizedBox(height: 24),
          if (isCompact)
            _buildTotalsCard(theme, totalSp, totalEv)
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 6,
                  child: _buildTotalsCard(theme, totalSp, totalEv),
                ),
                const SizedBox(width: 16),
                Expanded(flex: 4, child: _buildSelectorCard(theme)),
              ],
            ),
          const SizedBox(height: 20),
          if (isCompact) ...[
            _buildSelectorCard(theme),
            const SizedBox(height: 20),
          ],
          _SectionCard(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final int crossAxisCount = isCompact
                    ? 1
                    : constraints.maxWidth >= 1180
                    ? 3
                    : constraints.maxWidth >= 760
                    ? 2
                    : 1;
                final double tileWidth =
                    (constraints.maxWidth - ((crossAxisCount - 1) * 16)) /
                    crossAxisCount;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stat Inputs',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontFamily: 'RobotoCondensed',
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Tune each stat with linked SP and EV controls.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontFamily: 'RobotoCondensed',
                      ),
                    ),
                    const SizedBox(height: 18),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _statOrder.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        mainAxisExtent: tileWidth >= 320 ? 176 : 188,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        final _StatKey stat = _statOrder[index];
                        return _StatInputCard(
                          stat: stat,
                          baseStat: _baseStatFor(stat),
                          displayedStatValue: _displayStatFor(stat),
                          evValue: _evValues[stat]!,
                          spValue: _spValues[stat]!,
                          sliderMode: _sliderModes[stat]!,
                          onModeChanged: (_SliderMode mode) =>
                              _setSliderMode(stat, mode),
                          onSliderChanged: (double value) =>
                              _onSliderChanged(stat, value.round()),
                          isBoosted: _selectedNature.increasedStat == stat,
                          isHindered: _selectedNature.decreasedStat == stat,
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalsCard(ThemeData theme, int totalSp, int totalEv) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Stat Points',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
              fontFamily: 'RobotoCondensed',
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontFamily: 'RobotoCondensed',
                      color: theme.colorScheme.onSurface,
                    ),
                    children: <InlineSpan>[
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: _AnimatedIntText(
                          value: totalSp,
                          style: theme.textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontFamily: 'RobotoCondensed',
                          ),
                        ),
                      ),
                      TextSpan(
                        text: ' / $_maxTotalSp',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontFamily: 'RobotoCondensed',
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: RichText(
                  textAlign: TextAlign.right,
                  text: TextSpan(
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontFamily: 'RobotoCondensed',
                      color: theme.colorScheme.onSurface,
                    ),
                    children: <InlineSpan>[
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: _AnimatedIntText(
                          value: totalEv,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontFamily: 'RobotoCondensed',
                          ),
                        ),
                      ),
                      TextSpan(
                        text: ' / $_maxTotalEv EVs',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontFamily: 'RobotoCondensed',
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _AnimatedGradientProgressBar(
            value: totalSp / _maxTotalSp,
            colors: const <Color>[
              Color(0xFF22C55E),
              Color(0xFFFFFFFF),
              Color(0xFF14B8A6),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${_maxTotalSp - totalSp} stat points remaining',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontFamily: 'RobotoCondensed',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  '${_maxTotalEv - totalEv} EVs remaining',
                  textAlign: TextAlign.right,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontFamily: 'RobotoCondensed',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectorCard(ThemeData theme) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ActionButton(
            label: _selectedPokemon == null
                ? 'Select a Pokémon'
                : _selectedPokemon!.displayName,
            icon: _selectedPokemon == null
                ? null
                : Image.asset(
                    '${_selectedPokemon!.assetImagePath}.png',
                    width: 28,
                    height: 28,
                  ),
            onPressed: _selectPokemon,
          ),
          const SizedBox(height: 12),
          _ActionButton(
            label: _selectedNature.label,
            trailing: Text(
              'Choose a Nature',
              style: theme.textTheme.labelLarge?.copyWith(
                fontFamily: 'RobotoCondensed',
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            onPressed: _chooseNature,
          ),
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: _resetAll,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Reset'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int get _totalSp =>
      _spValues.values.fold<int>(0, (int sum, int value) => sum + value);

  int get _totalEv =>
      _evValues.values.fold<int>(0, (int sum, int value) => sum + value);

  int _baseStatFor(_StatKey stat) {
    final Stats? stats = _selectedPokemon?.pokemon.stats;
    if (stats == null) {
      return 0;
    }

    return stat.valueOf(stats);
  }

  int _displayStatFor(_StatKey stat) {
    final int baseStat = _baseStatFor(stat);
    final int spValue = _spValues[stat]!;
    if (stat == _StatKey.hp) {
      return Stats.championHpValue(baseStat: baseStat, spValue: spValue);
    }

    return Stats.championOtherStatValue(
      baseStat: baseStat,
      spValue: spValue,
      alignment: _selectedNature.alignmentFor(stat),
    );
  }

  Future<void> _selectPokemon() async {
    final PokemonListItem? selected = await showPokemonSelectorDialog(
      context,
      pokemon: _availablePokemon,
      title: 'Select a Pokémon',
    );
    if (selected == null) {
      return;
    }

    setState(() {
      _selectedPokemon = selected;
    });
  }

  Future<void> _chooseNature() async {
    final _NatureOption? selected = await showDialog<_NatureOption>(
      context: context,
      builder: (BuildContext context) {
        return _NaturePickerDialog(selectedNature: _selectedNature);
      },
    );
    if (selected == null) {
      return;
    }

    setState(() {
      _selectedNature = selected;
    });
  }

  void _setSliderMode(_StatKey stat, _SliderMode mode) {
    setState(() {
      _sliderModes[stat] = mode;
    });
  }

  void _onSliderChanged(_StatKey stat, int rawValue) {
    final _SliderMode mode = _sliderModes[stat]!;
    if (mode == _SliderMode.ev) {
      _updateEvValue(stat, rawValue);
      return;
    }

    _updateSpFromSlider(stat, rawValue);
  }

  void _updateEvValue(_StatKey stat, int rawEv) {
    int nextEv = rawEv.clamp(0, _maxStatEv);
    nextEv -= nextEv % 4;
    final int otherTotalEv = _totalEv - _evValues[stat]!;
    final int evBudget = (_maxTotalEv - otherTotalEv).clamp(0, _maxStatEv);
    if (nextEv > evBudget) {
      nextEv = evBudget - (evBudget % 4);
    }

    int nextSp = _spFromEv(nextEv);
    final int otherTotalSp = _totalSp - _spValues[stat]!;
    final int spBudget = (_maxTotalSp - otherTotalSp).clamp(0, _maxStatSp);
    if (nextSp > spBudget) {
      nextSp = spBudget;
      nextEv = nextSp == 0
          ? 0
          : nextEv.clamp(_minEvForSp(nextSp), _maxEvForSp(nextSp));
    }

    _applyStatValues(stat, ev: nextEv, sp: nextSp);
  }

  void _updateSpFromSlider(_StatKey stat, int nextSp) {
    final int otherTotalSp = _totalSp - _spValues[stat]!;
    final int spBudget = (_maxTotalSp - otherTotalSp).clamp(0, _maxStatSp);
    final int clampedSp = nextSp.clamp(0, spBudget);
    final int nextEv = _canonicalEvForSp(clampedSp);
    final int otherTotalEv = _totalEv - _evValues[stat]!;
    final int evBudget = (_maxTotalEv - otherTotalEv).clamp(0, _maxStatEv);
    final int clampedEv = nextEv > evBudget
        ? _largestSpUnderEvBudget(evBudget)
        : nextEv;
    final int finalSp = nextEv > evBudget ? _spFromEv(clampedEv) : clampedSp;

    _applyStatValues(stat, ev: clampedEv, sp: finalSp);
  }

  int _largestSpUnderEvBudget(int evBudget) {
    for (int sp = _maxStatSp; sp >= 0; sp--) {
      if (_canonicalEvForSp(sp) <= evBudget) {
        return _canonicalEvForSp(sp);
      }
    }

    return 0;
  }

  void _applyStatValues(_StatKey stat, {required int ev, required int sp}) {
    setState(() {
      _evValues[stat] = ev;
      _spValues[stat] = sp;
    });
  }

  void _resetAll() {
    setState(() {
      for (final _StatKey stat in _statOrder) {
        _evValues[stat] = 0;
        _spValues[stat] = 0;
        _sliderModes[stat] = _SliderMode.sp;
      }
    });
  }

  int _spFromEv(int ev) => Stats.championSpFromEv(ev).clamp(0, _maxStatSp);

  int _minEvForSp(int sp) => Stats.championMinEvForSp(sp);

  int _maxEvForSp(int sp) => Stats.championMaxEvForSp(sp);

  int _canonicalEvForSp(int sp) => Stats.championCanonicalEvForSp(sp);
}

enum _StatKey {
  hp('HP'),
  attack('Attack'),
  defense('Defense'),
  specialAttack('Sp. Atk'),
  specialDefense('Sp. Def'),
  speed('Speed');

  const _StatKey(this.label);

  final String label;

  int valueOf(Stats stats) {
    return switch (this) {
      _StatKey.hp => stats.hp,
      _StatKey.attack => stats.att,
      _StatKey.defense => stats.def,
      _StatKey.specialAttack => stats.spa,
      _StatKey.specialDefense => stats.spd,
      _StatKey.speed => stats.spe,
    };
  }
}

const List<_StatKey> _statOrder = <_StatKey>[
  _StatKey.hp,
  _StatKey.attack,
  _StatKey.defense,
  _StatKey.specialAttack,
  _StatKey.specialDefense,
  _StatKey.speed,
];

class _NatureOption {
  const _NatureOption({
    required this.label,
    this.increasedStat,
    this.decreasedStat,
  });

  final String label;
  final _StatKey? increasedStat;
  final _StatKey? decreasedStat;

  double alignmentFor(_StatKey stat) {
    if (increasedStat == stat) {
      return 1.1;
    }

    if (decreasedStat == stat) {
      return 0.9;
    }

    return 1.0;
  }
}

enum _SliderMode { sp, ev }

const _NatureOption _neutralNature = _NatureOption(label: 'Serious');

const List<_NatureGridRow> _natureRows = <_NatureGridRow>[
  _NatureGridRow(
    loweredStat: _StatKey.attack,
    cells: <_NatureOption>[
      _NatureOption(label: 'Hardy'),
      _NatureOption(
        label: 'Lonely',
        increasedStat: _StatKey.attack,
        decreasedStat: _StatKey.defense,
      ),
      _NatureOption(
        label: 'Adamant',
        increasedStat: _StatKey.attack,
        decreasedStat: _StatKey.specialAttack,
      ),
      _NatureOption(
        label: 'Naughty',
        increasedStat: _StatKey.attack,
        decreasedStat: _StatKey.specialDefense,
      ),
      _NatureOption(
        label: 'Brave',
        increasedStat: _StatKey.attack,
        decreasedStat: _StatKey.speed,
      ),
    ],
  ),
  _NatureGridRow(
    loweredStat: _StatKey.defense,
    cells: <_NatureOption>[
      _NatureOption(
        label: 'Bold',
        increasedStat: _StatKey.defense,
        decreasedStat: _StatKey.attack,
      ),
      _NatureOption(label: 'Docile'),
      _NatureOption(
        label: 'Impish',
        increasedStat: _StatKey.defense,
        decreasedStat: _StatKey.specialAttack,
      ),
      _NatureOption(
        label: 'Lax',
        increasedStat: _StatKey.defense,
        decreasedStat: _StatKey.specialDefense,
      ),
      _NatureOption(
        label: 'Relaxed',
        increasedStat: _StatKey.defense,
        decreasedStat: _StatKey.speed,
      ),
    ],
  ),
  _NatureGridRow(
    loweredStat: _StatKey.specialAttack,
    cells: <_NatureOption>[
      _NatureOption(
        label: 'Modest',
        increasedStat: _StatKey.specialAttack,
        decreasedStat: _StatKey.attack,
      ),
      _NatureOption(
        label: 'Mild',
        increasedStat: _StatKey.specialAttack,
        decreasedStat: _StatKey.defense,
      ),
      _NatureOption(label: 'Bashful'),
      _NatureOption(
        label: 'Rash',
        increasedStat: _StatKey.specialAttack,
        decreasedStat: _StatKey.specialDefense,
      ),
      _NatureOption(
        label: 'Quiet',
        increasedStat: _StatKey.specialAttack,
        decreasedStat: _StatKey.speed,
      ),
    ],
  ),
  _NatureGridRow(
    loweredStat: _StatKey.specialDefense,
    cells: <_NatureOption>[
      _NatureOption(
        label: 'Calm',
        increasedStat: _StatKey.specialDefense,
        decreasedStat: _StatKey.attack,
      ),
      _NatureOption(
        label: 'Gentle',
        increasedStat: _StatKey.specialDefense,
        decreasedStat: _StatKey.defense,
      ),
      _NatureOption(
        label: 'Careful',
        increasedStat: _StatKey.specialDefense,
        decreasedStat: _StatKey.specialAttack,
      ),
      _NatureOption(label: 'Quirky'),
      _NatureOption(
        label: 'Sassy',
        increasedStat: _StatKey.specialDefense,
        decreasedStat: _StatKey.speed,
      ),
    ],
  ),
  _NatureGridRow(
    loweredStat: _StatKey.speed,
    cells: <_NatureOption>[
      _NatureOption(
        label: 'Timid',
        increasedStat: _StatKey.speed,
        decreasedStat: _StatKey.attack,
      ),
      _NatureOption(
        label: 'Hasty',
        increasedStat: _StatKey.speed,
        decreasedStat: _StatKey.defense,
      ),
      _NatureOption(
        label: 'Jolly',
        increasedStat: _StatKey.speed,
        decreasedStat: _StatKey.specialAttack,
      ),
      _NatureOption(
        label: 'Naive',
        increasedStat: _StatKey.speed,
        decreasedStat: _StatKey.specialDefense,
      ),
      _NatureOption(label: 'Serious'),
    ],
  ),
];

class _NatureGridRow {
  const _NatureGridRow({required this.loweredStat, required this.cells});

  final _StatKey loweredStat;
  final List<_NatureOption> cells;
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            theme.colorScheme.surface.withValues(alpha: 0.92),
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
          ],
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(padding: const EdgeInsets.all(24), child: child),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.trailing,
  });

  final String label;
  final VoidCallback onPressed;
  final Widget? icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.18,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide.none,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          backgroundColor: Colors.transparent,
        ),
        child: Row(
          children: [
            if (icon != null) ...[icon!, const SizedBox(width: 12)],
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'RobotoCondensed',
                ),
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: 12), trailing!],
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_drop_down_rounded,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatInputCard extends StatelessWidget {
  const _StatInputCard({
    required this.stat,
    required this.baseStat,
    required this.displayedStatValue,
    required this.evValue,
    required this.spValue,
    required this.sliderMode,
    required this.onModeChanged,
    required this.onSliderChanged,
    required this.isBoosted,
    required this.isHindered,
  });

  final _StatKey stat;
  final int baseStat;
  final int displayedStatValue;
  final int evValue;
  final int spValue;
  final _SliderMode sliderMode;
  final ValueChanged<_SliderMode> onModeChanged;
  final ValueChanged<double> onSliderChanged;
  final bool isBoosted;
  final bool isHindered;

  List<String> _sliderLabels(bool compact) {
    final List<String> labels = sliderMode == _SliderMode.ev
        ? <String>['0', '63', '126', '189', '252']
        : <String>['0', '8', '16', '24', '32'];

    if (compact) {
      return <String>[labels.first, labels[2], labels.last];
    }

    return labels;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isCompact = context.watch<AppDetailsProvider>().isCompact;
    final Color statColor = isBoosted
        ? const Color(0xFF22C55E)
        : isHindered
        ? const Color(0xFFEF4444)
        : theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: statColor.withValues(alpha: 0.18)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            statColor.withValues(alpha: 0.12),
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.16),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  stat.label,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onSurface,
                    fontFamily: 'RobotoCondensed',
                  ),
                ),
              ),
              Text(
                '$displayedStatValue',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 30,
                  fontFamily: 'RobotoCondensed',
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Base $baseStat',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
              fontFamily: 'RobotoCondensed',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 22,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: statColor,
                          thumbColor: statColor,
                          overlayColor: statColor.withValues(alpha: 0.18),
                          inactiveTrackColor:
                              theme.colorScheme.surfaceContainerHighest,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 6,
                          ),
                          trackHeight: 4,
                        ),
                        child: Slider(
                          value: sliderMode == _SliderMode.ev
                              ? evValue.toDouble()
                              : spValue.toDouble(),
                          max: sliderMode == _SliderMode.ev ? 252 : 32,
                          divisions: sliderMode == _SliderMode.ev ? 63 : 32,
                          label: sliderMode == _SliderMode.ev
                              ? '$evValue'
                              : '$spValue',
                          onChanged: onSliderChanged,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _sliderLabels(isCompact)
                          .map(
                            (String label) => Expanded(
                              child: Text(
                                label,
                                textAlign:
                                    label == _sliderLabels(isCompact).first
                                    ? TextAlign.left
                                    : label == _sliderLabels(isCompact).last
                                    ? TextAlign.right
                                    : TextAlign.center,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontFamily: 'RobotoCondensed',
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          )
                          .toList(growable: false),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ValuePill(
                    label: 'EV',
                    value: '$evValue',
                    highlighted: sliderMode == _SliderMode.ev,
                    onTap: () => onModeChanged(_SliderMode.ev),
                  ),
                  const SizedBox(width: 8),
                  _ValuePill(
                    label: 'SP',
                    value: '$spValue',
                    highlighted: sliderMode == _SliderMode.sp,
                    onTap: () => onModeChanged(_SliderMode.sp),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NaturePickerDialog extends StatelessWidget {
  const _NaturePickerDialog({required this.selectedNature});

  final _NatureOption selectedNature;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 840),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                theme.colorScheme.surface,
                theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.35,
                ),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Choose a Nature',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontFamily: 'RobotoCondensed',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Select how your nature boosts one stat and lowers another.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontFamily: 'RobotoCondensed',
                  ),
                ),
                const SizedBox(height: 18),
                _NatureHeaderRow(),
                const SizedBox(height: 10),
                ..._natureRows.map(
                  (_NatureGridRow row) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        const SizedBox(width: 96),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 96,
                          child: Text(
                            '+ ${row.loweredStat.label}',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF22C55E),
                              fontFamily: 'RobotoCondensed',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Row(
                            children: row.cells
                                .map(
                                  (_NatureOption nature) => Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      child: _NatureButton(
                                        nature: nature,
                                        isSelected:
                                            nature.label ==
                                            selectedNature.label,
                                        onTap: () =>
                                            Navigator.of(context).pop(nature),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(growable: false),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NatureHeaderRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<_StatKey> headers = <_StatKey>[
      _StatKey.attack,
      _StatKey.defense,
      _StatKey.specialAttack,
      _StatKey.specialDefense,
      _StatKey.speed,
    ];

    return Row(
      children: [
        const SizedBox(width: 96),
        const SizedBox(width: 10),
        const SizedBox(width: 96),
        const SizedBox(width: 10),
        Expanded(
          child: Row(
            children: headers
                .map(
                  (_StatKey stat) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        '- ${stat.label}',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFEF4444),
                          fontFamily: 'RobotoCondensed',
                        ),
                      ),
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        ),
      ],
    );
  }
}

class _NatureButton extends StatelessWidget {
  const _NatureButton({
    required this.nature,
    required this.isSelected,
    required this.onTap,
  });

  final _NatureOption nature;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isNeutral =
        nature.increasedStat == null && nature.decreasedStat == null;

    return FilledButton.tonal(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        backgroundColor: isSelected
            ? theme.colorScheme.primary.withValues(alpha: 0.18)
            : isNeutral
            ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.55)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.45)
              : isNeutral
              ? theme.colorScheme.outline.withValues(alpha: 0.44)
              : theme.colorScheme.outlineVariant.withValues(alpha: 0.32),
        ),
      ),
      child: Text(
        nature.label,
        textAlign: TextAlign.center,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w700,
          fontFamily: 'RobotoCondensed',
          color: isSelected
              ? theme.colorScheme.primary
              : isNeutral
              ? theme.colorScheme.onSurface
              : null,
        ),
      ),
    );
  }
}

class _AnimatedIntText extends StatelessWidget {
  const _AnimatedIntText({required this.value, required this.style});

  final int value;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value.toDouble()),
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      builder: (BuildContext context, double animatedValue, Widget? child) {
        return Text(animatedValue.round().toString(), style: style);
      },
    );
  }
}

class _AnimatedGradientProgressBar extends StatelessWidget {
  const _AnimatedGradientProgressBar({
    required this.value,
    required this.colors,
  });

  final double value;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            height: 12,
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.4,
            ),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: value.clamp(0, 1)),
              duration: const Duration(milliseconds: 420),
              curve: Curves.easeOutCubic,
              builder:
                  (BuildContext context, double animatedValue, Widget? child) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: constraints.maxWidth * animatedValue,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: colors),
                          ),
                          child: const SizedBox.expand(),
                        ),
                      ),
                    );
                  },
            ),
          );
        },
      ),
    );
  }
}

class _ValuePill extends StatelessWidget {
  const _ValuePill({
    required this.label,
    required this.value,
    required this.onTap,
    this.highlighted = false,
  });

  final String label;
  final String value;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: highlighted
                ? const Color(0xFF0F3D38)
                : theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.24,
                  ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: highlighted
                  ? const Color(0xFF34D399).withValues(alpha: 0.35)
                  : theme.colorScheme.outlineVariant.withValues(alpha: 0.32),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: highlighted ? const Color(0xFF6EE7B7) : null,
                  fontFamily: 'RobotoCondensed',
                ),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: highlighted
                      ? const Color(0xFF6EE7B7)
                      : theme.colorScheme.onSurfaceVariant,
                  fontFamily: 'RobotoCondensed',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
