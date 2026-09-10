import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/reward.dart';

class RewardsRepository {
  static RewardsRepository? _instance;

  RewardsRepository._internal();

  factory RewardsRepository() {
    return _instance ??= RewardsRepository._internal();
  }

  Future<List<Reward>> fetchRewards() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('rewards')
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) {
      return Reward.doc(doc);
    }).toList();
  }

  Future<Reward> fetch(String id) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('rewards').doc(id).get();
    return Reward.doc(snapshot);
  }

  Future add(String id, Reward reward) async {
    return FirebaseFirestore.instance
        .collection('rewards')
        .doc(id)
        .set(reward.toJson());
  }
}
