import 'package:salon_app_commons/salon_app_commons.dart';

/// Utility class for calculating and formatting proration-related information
class ProrationCalculator {
  ProrationCalculator._();

  /// Gets discount amount from prorations with fallback logic
  static int getDiscountAmount(StripeUpcomingInvoice? upcomingInvoice) {
    if (upcomingInvoice == null) return 0;
    
    final proration1 = upcomingInvoice.prorations.elementAtSafely(1);
    final proration0 = upcomingInvoice.prorations.elementAtSafely(0);
    
    int discountAmount = proration1?.discountAmount ?? 0;
    if (discountAmount == 0) {
      // 無料プランだった場合、1つ目に入ってる場合もあるので、試みる
      discountAmount = proration0?.discountAmount ?? 0;
    }
    return discountAmount;
  }

  /// Creates detailed calculation description text from prorations
  static String? createCalculationDescriptionText({
    required StripeUpcomingInvoice? upcomingInvoice,
    required String currentPlanName,
    required String newPlanName,
    required IntervalType? intervalType,
  }) {
    if (upcomingInvoice == null) return null;
    
    final proration0 = upcomingInvoice.prorations.elementAtSafely(0); // 現在のプラン
    final proration1 = upcomingInvoice.prorations.elementAtSafely(1); // 次のプラン

    if (proration0 == null || proration1 == null) {
      return null;
    }

    final currentPlanProrationAmount = PlanFormatter.formatPriceAmount(proration0.amount);
    final currentPlanStart = proration0.start.formatYMDW;
    final currentPlanEnd = proration0.end.formatYMDW;
    final newPlanAmount = PlanFormatter.formatPriceAmount(proration1.amount);
    final newPlanStart = proration1.start.formatYMDW;
    final newPlanEnd = proration1.end.formatYMDW;
    final spanText = intervalType?.spanLabel ?? '';
    final discount = proration1.discountAmount;

    String outputText = '''・$currentPlanProrationAmount: $currentPlanName未使用期間($currentPlanStart〜$currentPlanEnd)の返金
・$newPlanAmount: $newPlanName$spanText($newPlanStart~$newPlanEnd)''';

    if (discount != 0) {
      outputText += '\n・-${PlanFormatter.formatPriceAmount(discount)}: プロモーションコードによる割引🎉';
    }
    return outputText;
  }

  /// Formats discount display text
  static String formatDiscountText(int discountAmount) {
    return '${PlanFormatter.formatPriceAmount(discountAmount)}の割引適用中👍';
  }

  /// Formats immediate payment total
  static String formatImmediatePaymentTotal(StripeUpcomingInvoice upcomingInvoice) {
    return '合計 ${PlanFormatter.formatPriceAmount(upcomingInvoice.total)}';
  }

  /// Formats next payment information
  static String formatNextPaymentInfo({
    required int amount,
    required DateTime paymentDate,
  }) {
    return '${PlanFormatter.formatPriceAmount(amount)} (${PlanFormatter.formatDateYMDHM(paymentDate)}に決済予定)';
  }
}