import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/section.dart';
import '../domain/study_contents.dart';
import '../utils/log_utils.dart';

/// 教材関連の操作をまとめたクラス (Singleton)
class StudyContentsRepository {
  static StudyContentsRepository? _instance;
  StudyContentsRepository._internal();

  factory StudyContentsRepository() {
    return _instance ??= StudyContentsRepository._internal();
  }

  /// 画像教材を取得する
  Future<List<StudyContent>> fetchContents() async {
    try {
      // 空の教材配列
      List<StudyContent> studyContents = [];
      // Flutter → Firebase → Github → Dart の順で取得し配列に追加
      List<String> parts = ['flutter', 'firebase', 'github', 'dart'];
      for (final part in parts) {
        final snapshot = await FirebaseFirestore.instance
            .collection('study_contents')
            .where('part', isEqualTo: part)
            .get();
        final partContents =
            snapshot.docs.map((doc) => StudyContent.fromDoc(doc)).toList();
        studyContents.addAll(partContents);
      }
      return studyContents;
    } catch (e) {
      logger.d('error:${e.toString()}');
      rethrow;
    }
  }

  /// Flutter基礎編の教材を単一取得
  Future<StudyContent> fetchFlutterContent(String id) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('study_contents')
          .doc(id)
          .get();
      return StudyContent.fromDoc(doc);
    } catch (e) {
      logger.d('error:${e.toString()}');
      rethrow;
    }
  }

  /// サムネイル（sectionsの0番目のimage）を返す
  Future<String> fetchThumb(String id) async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('study_contents')
          .doc(id)
          .collection('sections')
          .get();
      final section = Section.fromDoc(snap.docs.first);
      return section.image ?? '';
    } catch (e) {
      logger.d('error:${e.toString()}');
      rethrow;
    }
  }

  /// Sectionsを返す
  Future<List<Section>> fetchSections(String id) async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('study_contents')
          .doc(id)
          .collection('sections')
          .get();
      final sections = snap.docs.map((doc) => Section.fromDoc(doc)).toList();
      return sections;
    } catch (e) {
      logger.d('error:${e.toString()}');
      rethrow;
    }
  }

  /// セクションを単一取得し、返す
  Future<Section> fetchSection(String id, String index) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('study_contents')
          .doc(id)
          .collection('sections')
          .doc(index)
          .get();
      return Section.fromDoc(doc);
    } catch (e) {
      logger.d('error:${e.toString()}');
      rethrow;
    }
  }

  ///　管理者用途 -----------

  /// 教材を作成する
  Future createStudyContents({
    required String docId,
    required String title,
    required String part,
    required String thumbURL,
  }) async {
    try {
      // 教材作成
      await FirebaseFirestore.instance
          .collection('study_contents')
          .doc(docId)
          .set({'title': title, 'part': part, 'thumbURL': thumbURL});
    } catch (e) {
      logger.d('error:${e.toString()}');
      rethrow;
    }
  }

  /// セクションを追加する
  Future createSection({
    required String contentId,
    required Section section,
  }) async {
    try {
      // Firestoreを更新
      await FirebaseFirestore.instance
          .collection('study_contents')
          .doc(contentId)
          .collection('sections')
          .doc(section.index.toString())
          .set(section.toJson());
    } catch (e) {
      logger.d('error:${e.toString()}');
      rethrow;
    }
  }

  /// セクションを更新する
  Future updateSection({
    required String contentId,
    required Section section,
  }) async {
    try {
      // Firestoreを更新
      await FirebaseFirestore.instance
          .collection('study_contents')
          .doc(contentId)
          .collection('sections')
          .doc(section.index.toString())
          .update(section.toJson());
    } catch (e) {
      logger.d('error:${e.toString()}');
      rethrow;
    }
  }
}
