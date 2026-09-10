import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/user_app.dart';
import '../utils/log_utils.dart';

class UserAppsRepository {
  static UserAppsRepository? _instance;
  UserAppsRepository._internal();

  factory UserAppsRepository() {
    return _instance ??= UserAppsRepository._internal();
  }

  Future<List<UserApp>?> fetchAppsList() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('user_apps').get();
      final apps = snapshot.docs.map((e) => UserApp.doc(e)).toList();
      
      // Sort by most recent relevant date (latestReleaseDate if available, otherwise releasedAt)
      apps.sort((a, b) {
        final aDate = a.latestReleaseDate?.toDate() ?? a.releasedAt?.toDate() ?? DateTime(1970);
        final bDate = b.latestReleaseDate?.toDate() ?? b.releasedAt?.toDate() ?? DateTime(1970);
        return bDate.compareTo(aDate); // descending order
      });
      
      return apps;
    } catch (e) {
      logger.d('error:${e.toString()}');
    }
    return null;
  }

  Future<List<UserApp>?> fetchJointDevelopmentAppsList() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('user_apps')
          .where('isTeam', isEqualTo: true)
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs.map((e) => UserApp.doc(e)).toList();
    } catch (e) {
      logger.d('error:${e.toString()}');
    }
    return null;
  }

  Future<void> saveUserApp({
    required String userId,
    String? iOSURL,
    String? androidURL,
  }) async {
    try {
      final data = <String, dynamic>{
        'userId': userId,
        'iOSURL': iOSURL,
        'androidURL': androidURL,
        'createdAt': FieldValue.serverTimestamp(),
        'isTeam': false,
        'isActive': false,
        'userIds': [userId],
      };
      
      await FirebaseFirestore.instance.collection('user_apps').add(data);
    } catch (e) {
      logger.d('error:${e.toString()}');
      rethrow;
    }
  }
}
