import 'package:dexpro/core/models/version_history_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DisclaimerInfoPage extends StatelessWidget {
  const DisclaimerInfoPage({super.key});

  static const String _disclaimerText =
      'All Pokémon images, names, characters, and related marks are trademarks and copyright of The Pokémon Company, Nintendo, Game Freak, or Creatures Inc. (“Pokémon Rights Holders”).\n\n'
      'DexPro is an unofficial fan site and is not endorsed by or affiliated with Pokémon Rights Holders.';
  static const String _readmeAssetPath = 'README.md';

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Disclaimer & Info',
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
            fontFamily: 'RobotoCondensed',
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Review recent website updates and important DexPro information in one place.',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontFamily: 'RobotoCondensed',
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: FutureBuilder<List<VersionHistoryEntry>>(
            future: _loadVersionHistory(),
            builder:
                (
                  BuildContext context,
                  AsyncSnapshot<List<VersionHistoryEntry>> snapshot,
                ) {
                  final List<VersionHistoryEntry> entries =
                      snapshot.data ?? const <VersionHistoryEntry>[];

                  return ListView(
                    children: [
                      if (snapshot.connectionState != ConnectionState.done)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: LinearProgressIndicator(minHeight: 3),
                        ),
                      if (entries.isEmpty)
                        _EmptyUpdatesCard(error: snapshot.error?.toString()),
                      ...entries.map(
                        (VersionHistoryEntry entry) =>
                            _VersionHistoryCard(entry: entry),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Disclaimer',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                fontFamily: 'RobotoCondensed',
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              _disclaimerText,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                height: 1.6,
                                fontFamily: 'RobotoCondensed',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
          ),
        ),
      ],
    );
  }

  Future<List<VersionHistoryEntry>> _loadVersionHistory() async {
    final String readme = await rootBundle.loadString(_readmeAssetPath);
    return _parseVersionHistory(readme);
  }

  List<VersionHistoryEntry> _parseVersionHistory(String readme) {
    final List<String> lines = readme.split('\n');
    final List<VersionHistoryEntry> entries = <VersionHistoryEntry>[];

    String? currentTitle;
    String? currentDate;
    final List<String> currentUpdates = <String>[];

    void commitCurrent() {
      if (currentTitle == null ||
          currentDate == null ||
          currentUpdates.isEmpty) {
        return;
      }

      entries.add(
        VersionHistoryEntry(
          date: currentDate!,
          title: currentTitle!,
          updates: List<String>.from(currentUpdates),
        ),
      );
      currentTitle = null;
      currentDate = null;
      currentUpdates.clear();
    }

    for (final String rawLine in lines) {
      final String line = rawLine.trimRight();
      if (line.startsWith('### ')) {
        commitCurrent();
        final String heading = line.substring(4).trim();
        final int separatorIndex = heading.lastIndexOf(' - ');
        if (separatorIndex == -1) {
          continue;
        }

        currentTitle = heading.substring(0, separatorIndex).trim();
        currentDate = heading.substring(separatorIndex + 3).trim();
        continue;
      }

      if (currentTitle == null) {
        continue;
      }

      if (line.startsWith('- ')) {
        currentUpdates.add(line.substring(2).trim());
      }
    }

    commitCurrent();
    return entries;
  }
}

class _VersionHistoryCard extends StatelessWidget {
  const _VersionHistoryCard({required this.entry});

  final VersionHistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.3,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Theme(
          data: theme.copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 8,
            ),
            childrenPadding: const EdgeInsets.fromLTRB(26, 0, 26, 20),
            title: Text(
              '${entry.title} – ${entry.date}',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                fontFamily: 'RobotoCondensed',
              ),
            ),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: entry.updates
                    .map(
                      (String update) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          '• $update',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            height: 1.5,
                            fontFamily: 'RobotoCondensed',
                          ),
                        ),
                      ),
                    )
                    .toList(growable: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyUpdatesCard extends StatelessWidget {
  const _EmptyUpdatesCard({this.error});

  final String? error;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        error == null
            ? 'No website updates were found in the README yet.'
            : 'Unable to load website updates from the README right now.',
        style: theme.textTheme.bodyLarge?.copyWith(
          fontFamily: 'RobotoCondensed',
          height: 1.5,
        ),
      ),
    );
  }
}
