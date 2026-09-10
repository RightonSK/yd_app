import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class TeacherCommissionRepository {
  final _functions = FirebaseFunctions.instanceFor(
    app: Firebase.app(),
    region: 'asia-northeast1',
  );

  Future<TeacherCommissionRate> fetchCommissionRate(String userId) async {
    final callable = _functions
        .httpsCallable('teacherCommission-fetchTeacherCommissionRate');
    final result = await callable.call({
      'userId': userId,
    });
    final commissionRate = result.data['commissionRate'] as num;
    final totalAmount = result.data['totalAmount'] as num;
    logger.d('commissionRate: $commissionRate, totalAmount: $totalAmount');
    return TeacherCommissionRate(
      commissionRate: commissionRate.toDouble(),
      totalAmount: totalAmount.toDouble(),
    );
  }

  Future<List<TeacherCommissionReference>>
      fetchCommissionRateReferences() async {
    final callable = _functions
        .httpsCallable('teacherCommission-fetchCommissionRateReference');
    final result = await callable.call();
    return (result.data as List<dynamic>).map((reference) {
      final commissionRate = reference['commissionRate'] as num;
      final requiredAmount = reference['requiredAmount'] as num;
      logger.d(
          'commissionRate: $commissionRate, requiredAmount: $requiredAmount');
      return TeacherCommissionReference(
        commissionRate: commissionRate.toDouble(),
        requiredAmount: requiredAmount.toDouble(),
      );
    }).toList();
  }
}
