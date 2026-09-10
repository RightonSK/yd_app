import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:salon_app_commons/domain/google_calendar.dart';
import 'package:salon_app_commons/extensions/date_time.dart';

class CalendarRepository {
  static CalendarRepository? _instance;

  CalendarRepository._internal(this._googleToken, this._calendarId);

  factory CalendarRepository({
    required String googleToken,
    required String calendarId,
  }) {
    _instance ??= CalendarRepository._internal(googleToken, calendarId);
    return _instance!;
  }

  final String _googleToken;
  final String _calendarId;

  final Map _baseDates = {
    "MO": 1,
    "TU": 2,
    "WE": 3,
    "TH": 4,
    "FR": 5,
    "SA": 6,
    "SU": 7,
  };

  Map<DateTime, List<CalendarItem>>? eventsMapCache;

  Future<Map<DateTime, List<CalendarItem>>> fetch() async {
    if (eventsMapCache != null) {
      return eventsMapCache!;
    }
    int curMonth = DateTime.now().month;
    String fromDateTime = _getMonthToSearch(curMonth);
    String toDateTime =
        _getMonthToSearch(curMonth + 4); // 次の次の次の次の月の1日まで(今日が5月25日なら9月1日まで)

    final response = await http.get(
      Uri.parse(
        "https://www.googleapis.com/calendar/v3/calendars/$_calendarId/events?key=$_googleToken&timeMin=$fromDateTime&timeMax=$toDateTime&showDeleted=false&singleEvents=true&orderBy=startTime",
      ),
    );

    if (response.statusCode == 200) {
      CalendarInfo info = CalendarInfo.fromJson(json.decode(response.body));
      final eventsMap = _createCalendarEvents(info);
      eventsMapCache = eventsMap;
      return eventsMap;
    } else {
      throw ('Request failed with status: ${response.statusCode}.');
    }
  }

  String _getMonthToSearch(int month) {
    return '${DateTime(
      DateTime.now().year,
      month,
      1,
      0,
      0,
      0,
    ).toIso8601String()}Z';
  }

  /// ---- カレンダー ------------------------

  /// カレンダーイベントを取得する
  Map<DateTime, List<CalendarItem>> _createCalendarEvents(CalendarInfo info) {
    Map<DateTime, List<CalendarItem>> calendarEvents = {};

    for (int i = 0; i < info.items!.length; i++) {
      final item = info.items![i];

      // 定期の予定に対してなんらかの変更を与えるItemにはrecurringEventIdが入っている
      if (item.recurringEventId != null) {
        final targetDate = item.originalStartTime!.dateTime;
        final dateKey =
            DateTime(targetDate!.year, targetDate.month, targetDate.day);

        if (item.status == 'cancelled') {
          // キャンセルのitemがあった場合は、追加されたところから取り除く
          // その日の中のcancel対象のeventだけ取り除く

          final targetEvents = calendarEvents[dateKey];

          if (targetEvents == null) {
            continue;
          }
          calendarEvents[dateKey]!.removeWhere((targetItem) {
            return targetItem.id == item.recurringEventId;
          });
        } else {
          // 変更があった場合は時間やタイトルを変更する
          final index = calendarEvents[dateKey]?.indexWhere((targetItem) {
            return targetItem.id == item.recurringEventId;
          });
          // 入れ替え
          if (index != null && index >= 0) {
            calendarEvents[dateKey]![index] = item;
          }
        }
      } else {
        // それ以外はeventを作成する
        if (item.start == null || item.end == null) {
          continue;
        }
        // 日付のリストを作る
        // 繰り返しイベントの場合は複数になる
        List<DateTime> keyDates = _getKeyDates(
          item.start!.dateTime!,
          item.end!.dateTime!,
          item.recurrence,
        );

        for (int j = 0; j < keyDates.length; j++) {
          final dateKey = keyDates[j];
          final itemCopied = item.copyWith(
            start: CalendarDate(
              dateTime:
                  item.start?.dateTime?.createNewDateOfTheSameTime(dateKey),
            ),
            end: CalendarDate(
              dateTime: item.end?.dateTime?.createNewDateOfTheSameTime(dateKey),
            ),
          );

          if (calendarEvents[dateKey] == null) {
            calendarEvents[dateKey] = [itemCopied];
          } else {
            calendarEvents[dateKey]!.add(itemCopied);
          }
        }
      }
    }
    return calendarEvents;
  }

  // FIXME: 改善の余地あり
  // 1月から１年分を無駄に取得しているので
  /// カレンダーに表示する日付のリストを取得する
  List<DateTime> _getKeyDates(DateTime startDateTime, DateTime endDateTime,
      CalendarRecurrence? recurrence) {
    final DateTime startDate = _getAddedDate(startDateTime);
    final DateTime endDate = _getAddedDate(endDateTime);

    List<DateTime> keyDates = [];
    // 予定が日付を跨ぐ時
    // 最後の日付が0時0分0秒のときにはその日付を省く
    int loopNum = endDateTime.hour == 0 &&
            endDateTime.minute == 0 &&
            endDateTime.second == 0
        ? endDate.difference(startDate).inDays - 1
        : endDate.difference(startDate).inDays;

    for (int i = 0; i <= loopNum; i++) {
      keyDates.add(_getAddedDate(startDate, i));
    }

    // 予定が周期の時(現状一週間のみ対応している)
    if (recurrence != null && recurrence.conditions["FREQ"] == "WEEKLY") {
      List dates = recurrence.conditions['BYDAY'].split(",");
      dates.forEach((date) {
        final int dateNumber = _baseDates[date];
        final int startDateNumber = startDate.weekday;
        final int plusNum = (dateNumber - startDateNumber) % 7;

        int weekLength = 7;
        final count = recurrence.conditions["COUNT"];
        int repeatNum = count ?? 52; // 一年分繰り返す

        for (int i = 0; i <= repeatNum; i++) {
          if (plusNum + weekLength * i == 0) {
            continue;
          }
          DateTime addedDates =
              _getAddedDate(startDate, plusNum + weekLength * i);

          if (_isEndDate(recurrence, addedDates)) {
            break;
          }
          keyDates.add(addedDates);
        }
      });
    }
    return keyDates;
  }

  /// 任意の数進めた日付を取得する
  DateTime _getAddedDate(dateTime, [int numToAdd = 0]) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day + numToAdd);
  }

  bool _isEndDate(CalendarRecurrence recurrence, addedDates) {
    final until = recurrence.conditions['UNTIL'];

    if (until == null) {
      return false;
    }
    // addedDatesがuntilよりも日付が後ならtrue
    return addedDates.compareTo(DateTime.parse(until)) == 1;
  }
}
