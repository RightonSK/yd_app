import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuple/tuple.dart';

import '../utils/log_utils.dart';

/// Firestore の review_version コレクション関連
class ReviewVersionRepository {
  static ReviewVersionRepository? _instance;
  ReviewVersionRepository._internal();

  factory ReviewVersionRepository() {
    return _instance ??= ReviewVersionRepository._internal();
  }

  /// version 情報を返す
  Future<Tuple2<String, String>> fetchVersions() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('review_version').get();
      final data = snapshot.docs.first.data();
      final reviewVersion = data['version']; // これがAppleレビュー対応中のバージョン
      final forceUpdateVersion = data['force_update_version']; // こちらは強制アップデート対象のバージョン
      return Tuple2<String, String>(reviewVersion, forceUpdateVersion);
    } catch (e) {
      logger.d('error:${e.toString()}');
      rethrow;
    }
  }

  /// 管理画面用途 -----

  /// version を変更する
  Future updateVersion({
    required String objectName,
    required String nextVersion,
  }) async {
    // 現在のドキュメントを取得
    final snap = await FirebaseFirestore.instance.collection('review_version').get();
    final currentDocRef = snap.docs.first.reference;
    // updateする
    await currentDocRef.update({
      objectName: nextVersion,
    });
  }
}
