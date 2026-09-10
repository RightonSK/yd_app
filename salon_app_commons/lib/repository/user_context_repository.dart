import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class UserContextRepository {
  static UserContextRepository? _instance;
  UserContextRepository._internal();

  factory UserContextRepository() {
    return _instance ??= UserContextRepository._internal();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserRepository _userRepo = UserRepository();

  /// ユーザーコンテキストを取得
  Future<UserContext?> getUserContext() async {
    final uid = _userRepo.myUid;
    if (uid == null) return null;

    try {
      final doc = await _firestore
          .collection('users')
          .doc(uid)
          .collection('contexts')
          .doc('userContext')
          .get();

      if (doc.exists && doc.data() != null) {
        return UserContext.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      logger.e('Error getting user context: $e');
      return null;
    }
  }

  /// ユーザーコンテキストを保存
  Future<void> saveUserContext(UserContext context) async {
    final uid = _userRepo.myUid;
    if (uid == null) return;

    try {
      final updatedContext = context.copyWith(
        lastUpdated: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('contexts')
          .doc('userContext')
          .set(updatedContext.toJson(), SetOptions(merge: true));
          
      logger.d('User context saved successfully');
    } catch (e) {
      logger.e('Error saving user context: $e');
      rethrow;
    }
  }

  /// ユーザーコンテキストをリアルタイムで監視
  Stream<UserContext?> watchUserContext() {
    final uid = _userRepo.myUid;
    if (uid == null) return Stream.value(null);

    return _firestore
        .collection('users')
        .doc(uid)
        .collection('contexts')
        .doc('userContext')
        .snapshots()
        .map((doc) {
      if (doc.exists && doc.data() != null) {
        return UserContext.fromJson(doc.data()!);
      }
      return null;
    });
  }
}