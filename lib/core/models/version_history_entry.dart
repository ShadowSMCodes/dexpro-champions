class VersionHistoryEntry {
  const VersionHistoryEntry({
    required this.date,
    required this.title,
    required this.updates,
  });

  final String date;
  final String title;
  final List<String> updates;
}
