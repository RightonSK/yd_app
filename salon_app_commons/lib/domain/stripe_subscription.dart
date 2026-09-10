import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salon_app_commons/domain/abstract_subscription.dart';
import 'package:salon_app_commons/domain/plan_type.dart';

import 'plan.dart';
import 'price.dart';

/// 決済情報
class StripeSubscription implements AbstractSubscription {
  final String? id;
  final DateTime? cancelAt;
  final bool? cancelAtPeriodEnd;
  final DateTime? canceledAt;
  @override
  final DateTime? created;
  final DateTime? currentPeriodEnd;
  @override
  final DateTime? currentPeriodStart;
  final DateTime? endedAt;
  final List items;
  final Map<String, dynamic>? metadata;
  final int? quantity;
  final String? status;
  final String? stripeLink;
  final DateTime? trialEnd;
  final DateTime? trialStart;
  final Plan currentPlan;
  final Price currentPrice;

  StripeSubscription._(
    this.id,
    this.cancelAt,
    this.cancelAtPeriodEnd,
    this.canceledAt,
    this.created,
    this.currentPeriodEnd,
    this.currentPeriodStart,
    this.endedAt,
    this.items,
    this.metadata,
    this.quantity,
    this.status,
    this.stripeLink,
    this.trialEnd,
    this.trialStart,
    this.currentPlan,
    this.currentPrice,
  );

  factory StripeSubscription.doc(
    DocumentSnapshot doc,
    Plan currentPlan,
    Price currentPrice,
  ) {
    final data = doc.data() as Map;
    return StripeSubscription.json(
      doc.id,
      data,
      currentPlan,
      currentPrice,
    );
  }

  factory StripeSubscription.json(
    String id,
    Map data,
    Plan currentPlan,
    Price currentPrice,
  ) {
    return StripeSubscription._(
      id,
      _toDate(data, 'cancel_at'),
      data['cancel_at_period_end'],
      _toDate(data, 'canceled_at'),
      _toDate(data, 'created'),
      _toDate(data, 'current_period_end'),
      _toDate(data, 'current_period_start'),
      _toDate(data, 'ended_at'),
      data['items'],
      data['metadata'],
      data['quantity'],
      data['status'],
      data['stripeLink'],
      _toDate(data, 'trial_end'),
      _toDate(data, 'trial_start'),
      currentPlan,
      currentPrice,
    );
  }

  /// Timestamp => DateTime
  static DateTime? _toDate(Map data, String fieldName) {
    if (data[fieldName] is Timestamp) {
      return (data[fieldName] as Timestamp).toDate();
    }
    return null;
  }

  /// 現在の料金情報のDocumentReferenceを返す
  static DocumentReference? getCurrentPriceRef(Map data) {
    final currentPricePath = _getCurrentPricePathFromMetadata(data);
    if (currentPricePath != null) {
      // metadataからプラン変更時点の現在の料金情報を取り出す
      return FirebaseFirestore.instance.doc(currentPricePath);
    }
    // metadataからプラン変更時点の現在の料金情報が取れなければpriceRefが現在の料金情報となる
    return data['price'];
  }

  /// 予約中の料金情報のDocumentReferenceを返す
  static DocumentReference? getReservedPriceRef(Map data) {
    final currentPricePath = _getCurrentPricePathFromMetadata(data);
    if (currentPricePath != null) {
      // metadataからプラン変更時点の現在の料金情報を取り出せた場合はpriceRefが予約中の料金情報となる
      return data['price'];
    }
    // metadataからプラン変更時点の現在の料金情報が取れなければ予約中の料金情報は無し
    return null;
  }

  /// metadataから現在の料金情報のパスを返す_getCurrentPricePathFromMetadata
  static String? _getCurrentPricePathFromMetadata(Map data) {
    // metadataには、プラン変更時に「現在の料金情報」と「プラン変更時の日時」が格納されている
    final metadata = data['metadata'];
    final currentPeriodStart = _toDate(data, 'current_period_start');

    if (metadata == null) {
      return null;
    }

    if (currentPeriodStart == null) {
      return null;
    }

    if (metadata.containsKey('current_price_path') &&
        metadata.containsKey('changed_plan_at')) {
      // 前回決済日時(current_period_start)がプラン予約日時(changed_plan_at)を超えていたら、予約したプランで決済済みと判断できるため、metadataの情報は無視する
      final changedPlanAt = DateTime.fromMillisecondsSinceEpoch(
          int.parse(metadata['changed_plan_at']) * 1000);
      if (currentPeriodStart.isAfter(changedPlanAt)) {
        return null;
      }

      // metadataからプラン変更時点の現在の料金情報を取り出す
      return metadata['current_price_path'];
    }
    return null;
  }

  /// metadataから予約日時を返す
  DateTime? getReservedDate() {
    // metadataには、プラン変更時に「現在の料金情報」と「プラン変更時の日時」が格納されている

    if (metadata == null || currentPeriodStart == null) {
      return null;
    }

    if (metadata!.containsKey('current_price_path') &&
        metadata!.containsKey('changed_plan_at')) {
      final changedPlanAt = DateTime.fromMillisecondsSinceEpoch(
          int.parse(metadata!['changed_plan_at']) * 1000);
      return changedPlanAt;
    }
    return null;
  }

  /// 入会日時からの経過月を返す
  String get elapsedLabel {
    if (created == null) {
      return '';
    }
    final diff = DateTime.now().difference(created!);
    final diffDtime = DateTime.fromMillisecondsSinceEpoch(diff.inMilliseconds);
    final diffYear = diffDtime.year - 1970;
    final diffMonth = diffDtime.month;
    return diffYear > 0 ? '$diffYear年$diffMonthヶ月目' : '$diffMonthヶ月目';
  }

  /// 退会申込み済みならtrue
  bool get isWithdrawing => cancelAtPeriodEnd ?? false;

  /// 状態の表示文字列を返す
  String get displayStatus => status == 'active'
      ? '正常'
      : status == 'trialing'
          ? '正常(トライアル中)'
          : status == 'past_due'
              ? '決済エラー'
              : '<不明>';

  /// 状態がエラーならtrue
  @override
  bool get isErrorStatus => !(status == 'active' || status == 'trialing');

  @override
  int get amount => currentPrice.unitAmount ?? 0;

  @override
  PlanType get planType => currentPlan.planType;

  @override
  DateTime? get expired => endedAt;
}
