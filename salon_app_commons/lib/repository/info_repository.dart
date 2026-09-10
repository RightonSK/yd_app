import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salon_app_commons/domain/annual_user_fut_data.dart';

import '../domain/annual_ranking_data.dart';
import '../domain/info.dart';

class InfoRepository {
  static InfoRepository? _instance;
  InfoRepository._internal();

  factory InfoRepository() {
    return _instance ??= InfoRepository._internal();
  }

  Future<Info> fetch() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('info').doc('lp').get();
    return Info.doc(snapshot);
  }

  Future<AnnualRankingData> fetchAnnualData2024() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('info').doc('2024').get();
    return AnnualRankingData.doc(snapshot);
  }

  Future<AnnualUserFUTData> fetchPersonalData2024(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('info')
        .doc('2024')
        .collection('futDatas')
        .doc(userId)
        .get();
    return AnnualUserFUTData.doc(snapshot);
  }
}
