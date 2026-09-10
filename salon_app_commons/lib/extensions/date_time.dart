import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:salon_app_commons/i18n/strings.g.dart';

extension DateTimeEx on DateTime {
  static const weekdays = ['', '月', '火', '水', '木', '金', '土', '日'];

  /// DateTime => YYYY/MM/DD(W)
  String get formatYMDW {
    final ymd = DateFormat("yyyy/MM/dd").format(this);
    final w = weekdays[weekday];
    return '$ymd($w)';
  }

  /// DateTime => YYYY/MM/DD(W) HH:MM
  String get formatYMDWHM {
    final ymd = DateFormat("yyyy/MM/dd").format(this);
    final hm = DateFormat("HH:mm").format(this);
    final w = weekdays[weekday];
    return '$ymd($w) $hm';
  }

  String get formatMdHmm {
    return DateFormat('M/d H:mm').format(this);
  }

  String get formatMd {
    return DateFormat('M/d').format(this);
  }

  String get formatHM {
    final hm = DateFormat("HH:mm").format(this);
    return hm;
  }

  /// 時間を現在時間よりどのくらい前かで取得する
  String getHowLongTimeAgoString({bool shouldShort = false}) {
    final duration = DateTime.now().difference(this);
    final sec = duration.inSeconds;

    const secPerMin = 60;
    const secPerHour = secPerMin * 60;
    const secPerDay = secPerHour * 24;
    const secPerWeek = secPerDay * 7;

    if (sec >= secPerWeek) {
      if (shouldShort) {
        return DateFormat('M/d').format(this);
      } else {
        return DateFormat('yyyy/M/d').format(this);
      }
    } else if (sec >= secPerDay) {
      return '${duration.inDays.toString()}${t.newMembers.dayAgo}';
    } else if (sec >= secPerHour) {
      return '${duration.inHours.toString()}${t.newMembers.hourAgo}';
    } else if (sec >= secPerMin) {
      return '${duration.inMinutes.toString()}${t.newMembers.minuteAgo}';
    } else if (sec < 0) {
      return t.newMembers.future;
    } else {
      return '$sec${t.newMembers.secondAgo}';
    }
  }

  /// 比較用に日付は今日で時間だけ反映したDateTimeを作る
  DateTime createTheTimeToday() {
    final now = DateTime.now();
    return createNewDateOfTheSameTime(now);
  }

  /// 引数でもらった日付で時間だけ反映したDateTimeを作る
  DateTime createNewDateOfTheSameTime(DateTime newDate) {
    return DateTime(
      newDate.year,
      newDate.month,
      newDate.day,
      hour,
      minute,
    );
  }

  /// 直近7日間に更新されたものか判定する
  bool checkShouldShowNewLabel() {
    final duration = DateTime.now().difference(this).inSeconds;
    return duration < 60 * 60 * 24 * 7; // 7日間
  }

  /// Timestamp => DateTime
  static DateTime fromTimestamp(dynamic field) {
    if (field is Timestamp) {
      return field.toDate();
    }
    return DateTime.now();
  }
}
