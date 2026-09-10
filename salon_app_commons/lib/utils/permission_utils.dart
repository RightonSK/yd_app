import '../domain/plan_type.dart';
import '../repository/user_repository.dart';

class PermissionUtils {
  static final UserRepository _userRepo = UserRepository();

  /// Check if current user is a teacher
  static bool get isTeacher => _userRepo.myUid == 'DKujPNcD0nSfr7adnhi6waBkrtS2';

  /// Check if current user has permission to access question chat features
  static Future<bool> hasQuestionChatPermission() async {
    try {
      final subscription = await _userRepo.fetchSubscriptionFlesh();
      final planType = subscription?.planType;

      return planType == PlanType.training ||
          planType == PlanType.trainingLight ||
          planType == PlanType.aiTraining ||
          isTeacher; // Allow teacher to use question chat
    } catch (e) {
      return false;
    }
  }

  /// Check if current user has permission to access Zenn content (learning plan or higher)
  static Future<bool> hasZennPermission() async {
    try {
      final subscription = await _userRepo.fetchSubscriptionFlesh();
      final planType = subscription?.planType;

      return planType?.isLearningOrHigher == true || isTeacher;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> hasCalendlyPermission() async {
    try {
      final subscription = await _userRepo.fetchSubscriptionFlesh();
      final planType = subscription?.planType;

      return planType == PlanType.training || planType == PlanType.trainingLight;
    } catch (e) {
      return false;
    }
  }
}
