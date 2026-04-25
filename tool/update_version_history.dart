import 'dart:convert';
import 'dart:io';

const int maxDates = 8;
const int maxMessagesPerDate = 4;

Future<void> main() async {
  final ProcessResult logResult = await Process.run('git', <String>[
    'log',
    '--date=short',
    '--pretty=format:%ad|%s',
    '-n',
    '40',
  ]);

  if (logResult.exitCode != 0) {
    stderr.writeln(logResult.stderr);
    exit(logResult.exitCode);
  }

  final Map<String, List<String>> entriesByDate = <String, List<String>>{};
  final List<String> orderedDates = <String>[];

  for (final String line in const LineSplitter().convert(
    (logResult.stdout as String).trim(),
  )) {
    if (line.isEmpty || !line.contains('|')) {
      continue;
    }

    final int separatorIndex = line.indexOf('|');
    final String date = line.substring(0, separatorIndex).trim();
    final String message = _normalizeMessage(
      line.substring(separatorIndex + 1).trim(),
    );

    if (message.isEmpty) {
      continue;
    }

    final List<String> messages = entriesByDate.putIfAbsent(date, () {
      orderedDates.add(date);
      return <String>[];
    });

    if (!messages.contains(message) && messages.length < maxMessagesPerDate) {
      messages.add(message);
    }
  }

  final List<_HistoryEntry> history = orderedDates
      .take(maxDates)
      .map(
        (String date) => _HistoryEntry(
          date: date,
          title: 'Website Update',
          updates: entriesByDate[date] ?? const <String>[],
        ),
      )
      .where((_HistoryEntry entry) => entry.updates.isNotEmpty)
      .toList(growable: false);

  final File dartOutput = File('lib/core/config/version_history.dart');
  final File readmeOutput = File('README.md');

  dartOutput.writeAsStringSync(_buildDartFile(history));
  readmeOutput.writeAsStringSync(_buildReadme(history));
}

String _normalizeMessage(String message) {
  final String withoutPrefixes = message
      .replaceFirst(
        RegExp(
          r'^(feat|fix|chore|docs|refactor|style|build|ci):\s*',
          caseSensitive: false,
        ),
        '',
      )
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  if (withoutPrefixes.isEmpty) {
    return withoutPrefixes;
  }

  final String withCapitalizedFirst =
      '${withoutPrefixes[0].toUpperCase()}${withoutPrefixes.substring(1)}';

  if (withCapitalizedFirst.length <= 96) {
    return withCapitalizedFirst;
  }

  return '${withCapitalizedFirst.substring(0, 93).trimRight()}...';
}

String _buildDartFile(List<_HistoryEntry> history) {
  final StringBuffer buffer = StringBuffer()
    ..writeln("import 'package:dexpro/core/models/version_history_entry.dart';")
    ..writeln()
    ..writeln('const List<VersionHistoryEntry> websiteVersionHistory =')
    ..writeln('    <VersionHistoryEntry>[');

  for (final _HistoryEntry entry in history) {
    buffer.writeln('  VersionHistoryEntry(');
    buffer.writeln("    date: '${entry.date}',");
    buffer.writeln("    title: '${_escapeSingleQuotes(entry.title)}',");
    buffer.writeln('    updates: <String>[');
    for (final String update in entry.updates) {
      buffer.writeln("      '${_escapeSingleQuotes(update)}',");
    }
    buffer.writeln('    ],');
    buffer.writeln('  ),');
  }

  buffer
    ..writeln('];')
    ..writeln();

  return buffer.toString();
}

String _buildReadme(List<_HistoryEntry> history) {
  final StringBuffer buffer = StringBuffer()
    ..writeln('# DexPro - Champions')
    ..writeln()
    ..writeln(
      'DexPro is an unofficial Pokemon Champions web app built with Flutter for web. It includes a Pokemon Dex, team builder, move and item references, weakness charts, and event tracking.',
    )
    ..writeln()
    ..writeln('## Version History')
    ..writeln();

  for (final _HistoryEntry entry in history) {
    buffer
      ..writeln('### ${entry.title} - ${entry.date}')
      ..writeln();
    for (final String update in entry.updates) {
      buffer.writeln('- $update');
    }
    buffer.writeln();
  }

  return buffer.toString();
}

String _escapeSingleQuotes(String input) => input.replaceAll("'", "\\'");

class _HistoryEntry {
  const _HistoryEntry({
    required this.date,
    required this.title,
    required this.updates,
  });

  final String date;
  final String title;
  final List<String> updates;
}
