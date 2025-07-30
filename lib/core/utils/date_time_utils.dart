import 'package:intl/intl.dart';

/// Converts epoch to 12-hour format time with AM/PM, or 'Now' if hour matches current hour
String formatEpochTime(int timeEpoch) {
  final dateTime = DateTime.fromMillisecondsSinceEpoch(timeEpoch * 1000);
  final now = DateTime.now();

  final isSameHour =
      dateTime.year == now.year &&
      dateTime.month == now.month &&
      dateTime.day == now.day &&
      dateTime.hour == now.hour;

  return isSameHour ? 'Now' : DateFormat.jm().format(dateTime);
}

/// Converts "yyyy-MM-dd HH:mm" string to 12-hour format or 'Now'
String formatTimeString(String timeString) {
  final dateTime = DateFormat("yyyy-MM-dd HH:mm").parse(timeString);
  final now = DateTime.now();

  final isSameHour =
      dateTime.year == now.year &&
      dateTime.month == now.month &&
      dateTime.day == now.day &&
      dateTime.hour == now.hour;

  return isSameHour ? 'Now' : DateFormat.jm().format(dateTime);
}

String getDayLabel(String dateStr) {
  final inputDate = DateTime.parse(dateStr);
  final now = DateTime.now();

  final today = DateTime(now.year, now.month, now.day);
  final tomorrow = today.add(Duration(days: 1));
  // final dayAfter = today.add(Duration(days: 2));

  final inputDay = DateTime(inputDate.year, inputDate.month, inputDate.day);

  if (inputDay == today) {
    return 'Today';
  } else if (inputDay == tomorrow) {
    return 'Tomorrow';
  } else {
    return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][inputDay.weekday -
        1];
  }
}
