import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

/// Plan関連の操作をまとめたクラス (Singleton)
class PlanRepository {
  static PlanRepository? _instance;
  PlanRepository._internal();

  /// コンストラクタ
  factory PlanRepository() {
    return _instance ??= PlanRepository._internal();
  }

  /// サブスクプラン一覧を返す
  Future<List<Plan>> fetchMonthlySubscriptionPlans() async {
    // プラン一覧を取得する
    final plans = await _fetchAllActivePlans();

    // サブスクだけに絞る
    final subscriptionPlans = plans.where((plan) {
      final isSubscription = plan.getPrice(IntervalType.month)?.type == 'recurring';
      return isSubscription;
    }).toList();

    // 料金の低い順に並び替える
    subscriptionPlans
        .sort((a, b) => a.getPrice(IntervalType.month)!.unitAmount! - b.getPrice(IntervalType.month)!.unitAmount!);

    return subscriptionPlans;
  }

  Future<Plan> fetchOneTimePlan() async {
    final plans = await _fetchAllActivePlans();
    // 単発プランだけに絞る
    final oneTimePlan = plans.where((plan) => plan.availablePrices.first.type == 'one_time').toList().first;
    return oneTimePlan;
  }

  Future<List<Plan>> _fetchAllActivePlans() async {
    final query = await FirebaseFirestore.instance.collection('plans').where('active', isEqualTo: true).get();
    final fetchPlanTasks = query.docs.map((doc) async {
      // プラン配下の料金情報を取得する
      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('plans')
            .doc(doc.id)
            .collection('prices')
            .where('active', isEqualTo: true)
            .get();
        final prices = snapshot.docs.map((doc) {
          return Price.doc(doc);
        }).toList();
        return Plan.doc(doc, prices);
      } catch (e) {
        logger.d(e);
        return null;
      }
    }).toList();
    final plans = await Future.wait(fetchPlanTasks);
    return plans.whereNotNull().toList();
  }

  /// プランを取得する
  Future<Plan> fetchPlan(String id) async {
    final pricesSnapshot = await FirebaseFirestore.instance
        .collection('plans')
        .doc(id)
        .collection('prices')
        .where('active', isEqualTo: true)
        .get();
    final prices = pricesSnapshot.docs.map((doc) => Price.doc(doc)).toList();
    final planSnapshot = await FirebaseFirestore.instance.collection('plans').doc(id).get();
    return Plan.doc(planSnapshot, prices);
  }

  /// 料金を取得する
  Future<Price> fetchPrice(String documentPath) async {
    final snapshot = await FirebaseFirestore.instance.doc(documentPath).get();
    return Price.doc(snapshot);
  }
}
