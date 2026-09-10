import 'package:flutter/material.dart';

import '../salon_app_commons.dart';

class CalendarInfo {
  String? kind;
  String? etag;
  DateTime? updated;
  String? timeZone;
  List<CalendarItem>? items = [];

  CalendarInfo({
    this.kind,
    this.etag,
    this.updated,
    this.timeZone,
    this.items,
  });

  factory CalendarInfo.fromJson(Map<String, dynamic> json) => CalendarInfo(
        kind: json["kind"],
        etag: json["etag"],
        updated: DateTime.parse(json["updated"]),
        timeZone: json["timeZone"],
        items: List<CalendarItem>.from(json["items"].map(
          (x) => CalendarItem.fromJson(x),
        )),
      );
}

class CalendarItem {
  String? kind;
  String? summary;
  String? description;
  String? location;
  CalendarCreator? creator;
  CalendarDate? start;
  CalendarDate? end;
  CalendarRecurrence? recurrence;
  String? status;
  CalendarDate? originalStartTime;
  String? id;
  String? recurringEventId;

  CalendarItem({
    this.kind,
    this.summary,
    this.description,
    this.location,
    this.creator,
    this.start,
    this.end,
    this.recurrence,
    this.status,
    this.originalStartTime,
    this.id,
    this.recurringEventId,
  });

  factory CalendarItem.fromJson(Map<String, dynamic> json) => CalendarItem(
        id: json["id"],
        kind: json["kind"],
        summary: json["summary"],
        description: json["description"],
        location: json["location"],
        creator: (json["creator"] != null)
            ? CalendarCreator.fromJson(json["creator"])
            : null,
        start: (json["start"] != null)
            ? CalendarDate.fromJson(json["start"])
            : null,
        end: (json["end"] != null) ? CalendarDate.fromJson(json["end"]) : null,
        recurrence: (json["recurrence"] != null)
            ? CalendarRecurrence.fromJson(json["recurrence"])
            : null,
        status: json['status'],
        originalStartTime: (json["originalStartTime"] != null)
            ? CalendarDate.fromJson(json["originalStartTime"])
            : null,
        recurringEventId: json["recurringEventId"],
      );

  EventType get eventType {
    final summary = this.summary;

    if (summary == null) {
      return EventType.other;
    }

    if (summary.contains('朝')) {
      return EventType.morning;
    } else if (summary.contains('質問')) {
      return EventType.question;
    } else if (summary.contains('共同勉強会')) {
      return EventType.study;
    } else if (summary.contains('交流会')) {
      return EventType.party;
    } else {
      return EventType.other;
    }
  }

  CalendarItem copyWith({
    CalendarDate? start,
    CalendarDate? end,
  }) {
    return CalendarItem(
      kind: kind,
      summary: summary,
      description: description,
      location: location,
      creator: creator,
      start: start ?? this.start,
      end: end ?? this.end,
      recurrence: recurrence,
      status: status,
      originalStartTime: originalStartTime,
      id: id,
      recurringEventId: recurringEventId,
    );
  }
}

enum EventType {
  morning,
  party,
  study,
  question,
  other,
  ;

  Color get backgroundColor {
    switch (this) {
      case EventType.morning:
        return morningYellowColor;
      case EventType.party:
        return primaryYellowColor;
      case EventType.study:
        return Colors.blueAccent;
      case EventType.question:
        return primaryNavyColor;
      case EventType.other:
        return githubBlackColor;
    }
  }

  Color get textColor {
    switch (this) {
      case EventType.morning:
        return Colors.black;
      case EventType.party:
        return Colors.black;
      case EventType.study:
        return Colors.white;
      case EventType.question:
        return Colors.white;
      case EventType.other:
        return Colors.white;
    }
  }
}

class CalendarRecurrence {
  Map conditions;

  CalendarRecurrence(
    this.conditions,
  );

  factory CalendarRecurrence.fromJson(json) {
    List valueKeys = ['FREQ', 'UNTIL', 'BYDAY', 'COUNT'];
    Map conditions = {};
    // 文字列から必要なvalueを取り出すために煩雑な文字列操作を行っている
    // "RRULE:FREQ=WEEKLY;WKST=MO;UNTIL=20200930T145959Z;BYDAY=SU,WE"
    // -> {FREQ: WEELLY, UNTIL: 20200930T145959Z, BYDAY:SU,WE}
    // ignore: avoid_function_literals_in_foreach_calls
    valueKeys.forEach((element) {
      if (json.toString().contains(element)) {
        conditions[element] = json
            .toString()
            .split(element)[1]
            .split(';')[0]
            .replaceAll("=", '')
            .replaceAll("]", '');
      }
    });
    return CalendarRecurrence(
      conditions,
    );
  }
}

class CalendarCreator {
  String? email;

  CalendarCreator({
    this.email,
  });

  factory CalendarCreator.fromJson(Map<String, dynamic> json) =>
      CalendarCreator(
        email: json["email"],
      );
}

class CalendarDate {
  DateTime? dateTime;

  CalendarDate({
    this.dateTime,
  });

  factory CalendarDate.fromJson(Map<String, dynamic> json) {
    String dateToParse;
    if (json["dateTime"] == null) {
      dateToParse = json["date"];
    } else {
      // より良い記述があるかも
      // 2020-08-13T10:00:00+09:00 -> 2020-08-13T10:00:00 に変えてる
      dateToParse = json["dateTime"].toString().substring(0, 19);
    }
    return CalendarDate(
      dateTime: DateTime.parse(dateToParse),
    );
  }
}
