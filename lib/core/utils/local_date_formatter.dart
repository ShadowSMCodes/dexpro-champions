String formatLocalDateTime(DateTime utcDateTime) {
  final DateTime localDateTime = utcDateTime.toLocal();
  final String month = _months[localDateTime.month - 1];
  final String hour = localDateTime.hour.toString().padLeft(2, '0');
  final String minute = localDateTime.minute.toString().padLeft(2, '0');
  final String timeZoneName = _shortTimeZoneName(localDateTime);

  return '$month ${localDateTime.day}, ${localDateTime.year}, '
      '$hour:$minute $timeZoneName';
}

String formatLocalDateTimeRange(DateTime start, DateTime? end) {
  if (end == null) {
    return 'Starts ${formatLocalDateTime(start)}';
  }

  return '${formatLocalDateTime(start)} to '
      '${formatLocalDateTime(end)}';
}

const List<String> _months = <String>[
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

String _shortTimeZoneName(DateTime localDateTime) {
  final String zoneName = localDateTime.timeZoneName;
  if (zoneName.length <= 5 && !zoneName.contains(' ')) {
    return zoneName;
  }

  final Duration offset = localDateTime.timeZoneOffset;
  final String? mappedName = _commonTimeZoneNames[offset.inMinutes];
  if (mappedName != null) {
    return mappedName;
  }

  final String sign = offset.isNegative ? '-' : '+';
  final int totalMinutes = offset.inMinutes.abs();
  final String hours = (totalMinutes ~/ 60).toString().padLeft(2, '0');
  final String minutes = (totalMinutes % 60).toString().padLeft(2, '0');

  return 'UTC$sign$hours:$minutes';
}

const Map<int, String> _commonTimeZoneNames = <int, String>{
  0: 'UTC',
  60: 'CET',
  120: 'EET',
  330: 'IST',
  480: 'CST',
  540: 'JST',
  600: 'AEST',
  -300: 'EST',
  -240: 'EDT',
  -360: 'CST',
  -420: 'MST',
  -480: 'PST',
};
