import 'package:salon_app_commons/i18n/strings.g.dart';

enum IntervalType {
  month,
  threeMonth,
  sixMonth,
  year;

  String get label {
    switch (this) {
      case IntervalType.month:
        return t.price.month;
      case IntervalType.threeMonth:
        return t.price.threeMonth;
      case IntervalType.sixMonth:
        return t.price.sixMonth;
      case IntervalType.year:
        return t.price.year;
    }
  }

  String get spanLabel {
    switch (this) {
      case IntervalType.month:
        return '1ヶ月';
      case IntervalType.threeMonth:
        return '3ヶ月間';
      case IntervalType.sixMonth:
        return '6ヶ月間';
      case IntervalType.year:
        return '1年間';
    }
  }

  int get monthCount {
    switch (this) {
      case IntervalType.month:
        return 1;
      case IntervalType.threeMonth:
        return 3;
      case IntervalType.sixMonth:
        return 6;
      case IntervalType.year:
        return 12;
    }
  }
}
