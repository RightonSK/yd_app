import 'package:intl/intl.dart';

extension IntEx on int {
  /// 税込み金額を返す（内税なので0%）
  int get amountTaxIncluded => (this * 1.0).round();

  /// 税込み金額表示を返す
  String getSplitAmount() {
    final formatter = NumberFormat("#,###");
    return formatter.format(amountTaxIncluded);
  }
}
