import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salon_app_commons/extensions/date_time.dart';

class Event {
  final String id;
  final String name;
  final DateTime? createdAt;
  final int? dayOfWeek; // 曜日
  final int? numberOfDayOfWeek; // 第何水曜とか
  final DateTime? date;
  final DateTime? start;
  final DateTime? end;
  final bool? isRecurring;
  final String? zoomURL;
  final String? imageURL;
  bool? isOpen;
  bool isLoading = false;

  Event(
    this.id,
    this.name,
    this.createdAt,
    this.dayOfWeek,
    this.numberOfDayOfWeek,
    this.date,
    this.start,
    this.end,
    this.isRecurring,
    this.zoomURL,
    this.isOpen,
    this.imageURL,
  );

  factory Event.doc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Event(
      doc.id,
      data['name'],
      _toDate(data, 'createdAt'),
      data['dayOfWeek'],
      data['numberOfDayOfWeek'],
      _toDate(data, 'date'),
      _toDate(data, 'start'),
      _toDate(data, 'end'),
      data['isRecurring'],
      data['zoomURL'],
      data['isOpen'],
      data['imageURL'],
    );
  }

  /// Timestamp => DateTime
  static DateTime? _toDate(Map<String, dynamic> data, String fieldName) {
    DateTime? dTime;
    if (data[fieldName] is Timestamp) {
      dTime = (data[fieldName] as Timestamp).toDate();
    }
    return dTime;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['createdAt'] = createdAt;
    data['dayOfWeek'] = dayOfWeek;
    data['numberOfDayOfWeek'] = numberOfDayOfWeek;
    data['date'] = date;
    data['start'] = start;
    data['end'] = end;
    data['isRecurring'] = isRecurring;
    data['zoomURL'] = zoomURL;
    data['isOpen'] = isOpen;
    data['imageURL'] = imageURL;
    return data;
  }

  String createTimeText() {
    if (id == 'question_zoom') {
      return '週４回（火8時、水20時、木20時、土10時）';
    } else if (id == 'morning_gather') {
      return '平日毎朝7:10~8:00';
    } else if (id == 'gather') {
      return 'いつでも';
    }

    String text = '';

    if (isRecurring == true) {
      // 定期予定
      final day = days[dayOfWeek ?? 0];

      if (numberOfDayOfWeek != 0) {
        // 月1の予定
        text += '毎月第$numberOfDayOfWeek$day';
      } else {
        text += '毎週 $day';
      }
    } else {
      // 単発予定
      text += date?.formatYMDW ?? '';
    }

    final startHour = start?.hour;
    final endHour = end?.hour;

    if (startHour == null) {
      return '';
    }

    text += ' $startHour時~$endHour時';

    return text;
  }

  static List<String> days = [
    "日曜",
    "月曜",
    "火曜",
    "水曜",
    "木曜",
    "金曜",
    "土曜",
  ];
}
