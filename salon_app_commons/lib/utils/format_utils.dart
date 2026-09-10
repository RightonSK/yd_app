import 'package:intl/intl.dart';
import 'package:recase/recase.dart';

class FormatUtils {
  FormatUtils._();

  static String divideByComma(int number) {
    final formatter = NumberFormat("#,###");
    return formatter.format(number);
  }

  static String camelCaseToSnakeCase(String text) {
    return text.snakeCase;
  }
}
