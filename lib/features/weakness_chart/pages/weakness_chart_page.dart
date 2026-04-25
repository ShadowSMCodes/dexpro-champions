import 'package:dexpro/core/models/type.dart';
import 'package:flutter/material.dart';

class WeaknessChartPage extends StatelessWidget {
  const WeaknessChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      key: const ValueKey('weakness-chart-page'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weakness Chart',
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w800,
            fontFamily: 'RobotoCondensed',
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Vertical axis is attacker, horizontal axis is defender.',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontFamily: 'RobotoCondensed',
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 1100),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: _WeaknessMatrix(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WeaknessMatrix extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Type> types = Type.values;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double safeWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 1700;
        final double headerWidth = (safeWidth * 0.042).clamp(40, 56);
        final double dataCellWidth =
            ((safeWidth - headerWidth) / types.length).clamp(36, 72);
        final double cellHeight = dataCellWidth.clamp(36, 60);

        return Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: <int, TableColumnWidth>{
            0: FixedColumnWidth(headerWidth),
            for (int index = 1; index <= types.length; index += 1)
              index: FixedColumnWidth(dataCellWidth),
          },
          children: <TableRow>[
            TableRow(
              children: <Widget>[
                _CornerCell(size: cellHeight),
                ...types.map(
                  (Type type) => _TypeHeaderCell(
                    type: type,
                    size: cellHeight,
                  ),
                ),
              ],
            ),
            ...types.map(
              (Type attacker) => TableRow(
                children: <Widget>[
                  _TypeHeaderCell(
                    type: attacker,
                    size: cellHeight,
                  ),
                  ...types.map(
                    (Type defender) => _ValueCell(
                      label: Type.formatMultiplier(
                        attacker.effectivenessAgainst(defender),
                      ),
                      size: cellHeight,
                      multiplier: attacker.effectivenessAgainst(defender),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CornerCell extends StatelessWidget {
  const _CornerCell({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Text(
        'Att/Def',
        textAlign: TextAlign.center,
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w800,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _TypeHeaderCell extends StatelessWidget {
  const _TypeHeaderCell({
    required this.type,
    required this.size,
  });

  final Type type;
  final double size;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      height: size,
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Image.asset(
            type.imageURL,
            height: size * 0.54,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class _ValueCell extends StatelessWidget {
  const _ValueCell({
    required this.label,
    required this.size,
    required this.multiplier,
  });

  final String label;
  final double size;
  final double multiplier;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color highlightColor = multiplier == 0
        ? const Color(0xFFEF4444)
        : multiplier < 1
            ? const Color(0xFFFACC15)
            : multiplier > 1
            ? const Color(0xFF22C55E)
            : theme.colorScheme.surface;

    return Container(
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: highlightColor.withValues(alpha: multiplier == 1 ? 0 : 0.26),
      ),
      child: Text(
        '$label×',
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: size * 0.24,
        ),
      ),
    );
  }
}
