import 'package:intl/intl.dart';

String getDateTimeRangeStr(DateTime startDate, DateTime endDate) {
  DateFormat formatter = DateFormat('HH:mm');
  String startTime = formatter.format(startDate);
  String endTime = formatter.format(endDate);
  return '$startTime~$endTime';
}

DateTime unixSecondsToDateTime(int unixSeconds) {
  return DateTime.fromMillisecondsSinceEpoch(unixSeconds * 1000);
}
