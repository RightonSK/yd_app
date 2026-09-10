import 'package:intl/intl.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

/// Utility class for formatting plan-related strings consistently across the app
class PlanFormatter {
  PlanFormatter._();

  /// Formats plan name with interval (e.g., "ベーシックプラン (月)")
  static String formatPlanNameWithInterval(String planName, IntervalType? intervalType) {
    return '$planName (${intervalType?.spanLabel ?? ''})';
  }

  /// Formats price amount with yen symbol (e.g., "1,000円")
  static String formatPriceAmount(int amount) {
    return '${amount.getSplitAmount()}円';
  }

  /// Formats date in Japanese format (e.g., "2024年1月1日12時00分")
  static String formatDateYMDHM(DateTime date) {
    return DateFormat('yyyy年M月d日HH時mm分').format(date);
  }

  /// Formats plan change action text based on upgrade status
  static String formatPlanChangeAction(bool isUpgrade) {
    return isUpgrade ? '即時アップグレード 💪' : '変更予約 ⏰';
  }

  /// Formats plan change button text based on state
  static String formatPlanChangeButtonText({
    required bool hasReserved,
    required bool isUpgrade,
  }) {
    if (hasReserved) return '予約解除';
    return isUpgrade ? '今すぐアップグレード' : '変更予約';
  }

  /// Formats full plan description with price and interval
  static String formatPlanDescription({
    required String planName,
    required IntervalType? intervalType,
    required int price,
  }) {
    return '${formatPlanNameWithInterval(planName, intervalType)} - ${formatPriceAmount(price)}';
  }

  /// Formats reservation change text
  static String formatReservationChangeText({
    required String planName,
    required IntervalType? intervalType,
    required DateTime changeDate,
  }) {
    return '${formatPlanNameWithInterval(planName, intervalType)}に${formatDateYMDHM(changeDate)}から変更予定';
  }
}