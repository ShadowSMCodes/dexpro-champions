import 'package:dexpro/app/routing/app_navigation.dart';
import 'package:dexpro/core/models/season.dart';
import 'package:flutter/material.dart';

class SeasonsPage extends StatelessWidget {
  const SeasonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return LayoutBuilder(
      key: const ValueKey('seasons-page'),
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 15,
              child: SizedBox(
                width: double.infinity,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Seasons',
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontFamily: 'RobotoCondensed',
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Review seasons and full reward tracks in one place.',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontFamily: 'RobotoCondensed',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              flex: 85,
              child: GridView.builder(
                itemCount: seasons.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: constraints.maxWidth < 720
                      ? 1
                      : constraints.maxWidth < 1080
                      ? 3
                      : 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  mainAxisExtent: constraints.maxWidth < 720 ? 296 : 312,
                ),
                itemBuilder: (BuildContext context, int index) {
                  final Season season = seasons[index];
                  final _SeasonCardState state = _getSeasonCardState(season);

                  return _SeasonGridCard(
                    season: season,
                    state: state,
                    onTap: state.clickable
                        ? () => openSeasonDetails(context, season)
                        : null,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  _SeasonCardState _getSeasonCardState(Season season) {
    return _SeasonCardState(
      label: season.status.label,
      color: season.status.color,
      title: season.name,
      clickable: true,
    );
  }
}

class _SeasonCardState {
  const _SeasonCardState({
    required this.label,
    required this.color,
    required this.title,
    required this.clickable,
  });

  final String label;
  final Color color;
  final String title;
  final bool clickable;
}

class _SeasonGridCard extends StatelessWidget {
  const _SeasonGridCard({
    required this.season,
    required this.state,
    required this.onTap,
  });

  final Season season;
  final _SeasonCardState state;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: season.headerImageAssetPath != null && state.clickable
                    ? Padding(
                        padding: EdgeInsets.zero,
                        child: Image.asset(
                          season.headerImageAssetPath!,
                          fit: BoxFit.fitWidth,
                        ),
                      )
                    : Container(
                        color: theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.32),
                        child: Center(
                          child: Icon(
                            Icons.flag_circle_rounded,
                            size: 72,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
              ),
            ),
            SizedBox(
              height: 116,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(
                          state.clickable
                              ? Icons.flag_rounded
                              : Icons.schedule_rounded,
                          size: 20,
                          color: state.color,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            state.title,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              fontFamily: 'RobotoCondensed',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.circle, size: 10, color: state.color),
                        const SizedBox(width: 8),
                        Text(
                          state.label,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: state.color,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'RobotoCondensed',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      season.dateLabel,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontFamily: 'RobotoCondensed',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
