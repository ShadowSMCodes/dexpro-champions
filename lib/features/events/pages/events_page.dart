import 'package:dexpro/app/routing/app_navigation.dart';
import 'package:dexpro/core/models/mystery_gift_event.dart';
import 'package:dexpro/core/models/online_competition.dart';
import 'package:dexpro/core/models/season.dart';
import 'package:dexpro/features/seasons/pages/mystery_gifts_page.dart';
import 'package:flutter/material.dart';

enum _EventFilter {
  all('All'),
  active('Active'),
  season('Season'),
  news('News'),
  onlineCompetition('Online Competition');

  const _EventFilter(this.label);

  final String label;
}

enum _EventCardType {
  season('Season'),
  news('News'),
  onlineCompetition('Online Competition');

  const _EventCardType(this.label);

  final String label;
}

class _EventGridItem {
  const _EventGridItem({
    required this.title,
    required this.dateLines,
    required this.startDate,
    required this.endDate,
    required this.imagePath,
    required this.imageAspectRatio,
    required this.statusLabel,
    required this.statusColor,
    required this.type,
    required this.onTap,
  });

  final String title;
  final List<String> dateLines;
  final DateTime startDate;
  final DateTime? endDate;
  final String? imagePath;
  final double imageAspectRatio;
  final String statusLabel;
  final Color statusColor;
  final _EventCardType type;
  final VoidCallback onTap;
}

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  static const double _eventGridDetailsHeight = 174;

  _EventFilter _filter = _EventFilter.all;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return LayoutBuilder(
      key: const ValueKey('events-page'),
      builder: (BuildContext context, BoxConstraints constraints) {
        final List<_EventGridItem> items =
            _buildEventItems(
                context,
              ).where(_matchesFilter).toList(growable: false)
              ..sort((_EventGridItem a, _EventGridItem b) {
                final int startDateComparison = b.startDate.compareTo(
                  a.startDate,
                );

                if (startDateComparison != 0) {
                  return startDateComparison;
                }

                return (b.endDate ?? b.startDate).compareTo(
                  a.endDate ?? a.startDate,
                );
              });
        final double imageHeight = _eventGridImageHeight(
          constraints.maxWidth,
          items,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Seasons & Events',
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
                fontFamily: 'RobotoCondensed',
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Track seasons, mystery gifts, online competitions, and the latest Champions updates.',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontFamily: 'RobotoCondensed',
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _EventFilter.values
                  .map(
                    (_EventFilter filter) => ChoiceChip(
                      label: Text(filter.label),
                      selected: _filter == filter,
                      onSelected: (_) {
                        setState(() {
                          _filter = filter;
                        });
                      },
                    ),
                  )
                  .toList(growable: false),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                itemCount: items.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _eventGridColumnCount(constraints.maxWidth),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  mainAxisExtent: imageHeight + _eventGridDetailsHeight,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return _EventGridCard(
                    item: items[index],
                    imageHeight: imageHeight,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  bool _matchesFilter(_EventGridItem item) {
    return switch (_filter) {
      _EventFilter.all => true,
      _EventFilter.active =>
        item.statusLabel != 'Elapsed' && item.statusLabel != 'Upcoming',
      _EventFilter.season => item.type == _EventCardType.season,
      _EventFilter.news => item.type == _EventCardType.news,
      _EventFilter.onlineCompetition =>
        item.type == _EventCardType.onlineCompetition,
    };
  }

  int _eventGridColumnCount(double width) {
    return width < 720
        ? 1
        : width < 1360
        ? 2
        : 4;
  }

  double _eventGridImageHeight(double width, List<_EventGridItem> items) {
    const double spacing = 16;
    final int columns = _eventGridColumnCount(width);
    final double tileWidth = (width - ((columns - 1) * spacing)) / columns;
    final double widestAspectRatio = items
        .map((_EventGridItem item) => item.imageAspectRatio)
        .fold<double>(16 / 9, (double max, double ratio) {
          return ratio > max ? ratio : max;
        });

    return tileWidth / widestAspectRatio;
  }

  List<_EventGridItem> _buildEventItems(BuildContext context) {
    return <_EventGridItem>[
      ...seasons.map(
        (Season season) => _EventGridItem(
          title: season.name,
          dateLines: <String>[season.dateLabel],
          startDate: season.startDate,
          endDate: season.endDate,
          imagePath: season.headerImageAssetPath,
          imageAspectRatio: 2,
          statusLabel: season.status.label,
          statusColor: season.status.color,
          type: _EventCardType.season,
          onTap: () => openSeasonDetails(context, season),
        ),
      ),
      ...mysteryGiftEvents.map(
        (MysteryGiftEvent event) => _EventGridItem(
          title: event.title,
          dateLines: <String>[event.dateLabel],
          startDate: event.start,
          endDate: event.end,
          imagePath: event.imagePath,
          imageAspectRatio: 16 / 9,
          statusLabel: event.status.label,
          statusColor: event.status.color,
          type: _EventCardType.news,
          onTap: () => showDialog<void>(
            context: context,
            builder: (BuildContext context) => MysteryGiftDialog(event: event),
          ),
        ),
      ),
      ...onlineCompetitions.map(
        (OnlineCompetition competition) => _EventGridItem(
          title: competition.name,
          dateLines: <String>[
            'Registration: ${competition.registrationDateLabel}',
            'Battles: ${competition.battleDateLabel}',
          ],
          startDate: competition.sortDate,
          endDate: competition.battleEnd,
          imagePath: competition.imageAssetPath,
          imageAspectRatio: 16 / 9,
          statusLabel: competition.status.label,
          statusColor: competition.status.color,
          type: _EventCardType.onlineCompetition,
          onTap: () => openOnlineCompetitionDetails(context, competition),
        ),
      ),
    ];
  }
}

class _EventGridCard extends StatelessWidget {
  const _EventGridCard({required this.item, required this.imageHeight});

  final _EventGridItem item;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color tintColor = _tintColorForStatus(item.statusLabel);

    return Card(
      clipBehavior: Clip.antiAlias,
      color: Color.alphaBlend(
        tintColor.withValues(alpha: 0.1),
        theme.cardColor,
      ),
      child: InkWell(
        onTap: item.onTap,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool narrowCard = constraints.maxWidth < 420;

            return Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: imageHeight,
                  child: item.imagePath == null
                      ? Container(
                          color: theme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.32),
                          child: Center(
                            child: Icon(
                              Icons.emoji_events_rounded,
                              size: 72,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        )
                      : Image.asset(item.imagePath!, fit: BoxFit.fitWidth),
                ),
                SizedBox(
                  height: _EventsPageState._eventGridDetailsHeight,
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.type.label,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'RobotoCondensed',
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              _iconForType(item.type),
                              size: 20,
                              color: item.statusColor,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontSize: narrowCard ? 19 : null,
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
                            Icon(
                              Icons.circle,
                              size: 10,
                              color: item.statusColor,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                item.statusLabel,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontSize: narrowCard ? 13 : null,
                                  color: item.statusColor,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'RobotoCondensed',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...item.dateLines.map(
                          (String dateLine) => Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Text(
                              dateLine,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: narrowCard ? 12 : 13,
                                color: theme.colorScheme.onSurfaceVariant,
                                fontFamily: 'RobotoCondensed',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  IconData _iconForType(_EventCardType type) {
    return switch (type) {
      _EventCardType.season => Icons.flag_rounded,
      _EventCardType.news => Icons.redeem_rounded,
      _EventCardType.onlineCompetition => Icons.emoji_events_rounded,
    };
  }

  Color _tintColorForStatus(String statusLabel) {
    return switch (statusLabel) {
      'Elapsed' => const Color(0xFFEF4444),
      'Upcoming' => const Color(0xFFFACC15),
      _ => const Color(0xFF22C55E),
    };
  }
}
