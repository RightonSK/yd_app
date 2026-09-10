import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

import '../domain/mentor_plan.dart';
import '../domain/user.dart';
import '../utils/log_utils.dart';

class MentorPlanRepository {
  static MentorPlanRepository? _instance;
  MentorPlanRepository._internal();

  factory MentorPlanRepository() {
    return _instance ??= MentorPlanRepository._internal();
  }

  // アイコンを出すため、ユーザーをもらう
  Future<List<MentorPlan>> fetchAll(List<User> users) async {
    try {
      // FIXME: isArchivedがないプランもあったため一旦whereをやめる
      // final snapshot = await FirebaseFirestore.instance
      //     .collectionGroup('mentorPlans')
      //     .where('isArchived', isEqualTo: false)
      //     .get();
      final snapshot =
          await FirebaseFirestore.instance.collectionGroup('mentorPlans').get();
      final mentorPlans = snapshot.docs.map((e) {
        final plan = MentorPlan.doc(e);
        final userId = e.reference.parent.parent?.id; // userId取得
        plan.userId = userId;
        plan.user = users.firstWhereOrNull((user) => user.id == userId);
        return plan;
      }).toList();

      // FIXME: 暫定でisArchivedがないやつも出す
      final filteredMentorPlans =
          mentorPlans.where((plan) => !plan.isArchived).toList();

      filteredMentorPlans.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      return filteredMentorPlans;
    } catch (e) {
      logger.d('error:${e.toString()}');
      rethrow;
    }
  }

  Future<List<MentorPlan>> fetchList(String userId, String? myUid) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('mentorPlans')
          .get();
      final mentorPlans = snapshot.docs.map((e) => MentorPlan.doc(e)).toList();
      if (myUid == userId) {
        return mentorPlans;
      } else {
        final notArchivedMentorPlans = _removeArchivedMentorPlan(mentorPlans);
        return notArchivedMentorPlans;
      }
    } catch (e) {
      logger.d('error:${e.toString()}');
      rethrow;
    }
  }

  List<MentorPlan> _removeArchivedMentorPlan(List<MentorPlan> mentorPlans) {
    List<MentorPlan> notArchivedMentorPlans = [];
    for (int i = 0; i < mentorPlans.length; i++) {
      if (!mentorPlans.elementAt(i).isArchived) {
        notArchivedMentorPlans.add(mentorPlans.elementAt(i));
      }
    }
    return notArchivedMentorPlans;
  }

  Future<MentorPlan> fetchPlan(String? userId, String? planId) async {
    if (userId == null || planId == null) {
      throw 'userId or planId is null';
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('mentorPlans')
          .doc(planId)
          .get();
      return MentorPlan.doc(snapshot);
    } catch (e) {
      logger.d('error:${e.toString()}');
      rethrow;
    }
  }
}
