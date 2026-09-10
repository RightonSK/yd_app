import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:salon_app_commons/domain/comment.dart';
import 'package:salon_app_commons/domain/video_history.dart';

import '../domain/video.dart';
import '../utils/log_utils.dart';

/// フィード関連の操作をまとめたクラス (Singleton)
class VideoRepository {
  static VideoRepository? _instance;
  VideoRepository._internal();

  factory VideoRepository() {
    return _instance ??= VideoRepository._internal();
  }

  /// そのユーザーの勉強会動画をすべて取得する
  Future<List<Video>> fetchUserLectureVideos(String uid) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('lecture_videos')
          .orderBy('createdAt', descending: true)
          .where('userId', isEqualTo: uid)
          .get();
      return snapshot.docs.map((e) => Video.doc(e)).toList();
    } catch (e) {
      logger.d('error:${e.toString()}');
      rethrow;
    }
  }

  /// そのユーザーの発表会動画をすべて取得する
  Future<List<Video>> fetchUserPresentationVideos(String uid) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('presentation_videos')
          .orderBy('createdAt', descending: true)
          .where('userId', isEqualTo: uid)
          .get();
      return snapshot.docs.map((e) => Video.doc(e)).toList();
    } catch (e) {
      logger.d('error:${e.toString()}');
      rethrow;
    }
  }

  /// そのユーザーの発表会動画をすべて取得する
  Future<List<Video>> fetchUserClipVideos(String uid) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('clip_videos')
          .orderBy('createdAt', descending: true)
          .where('userId', isEqualTo: uid)
          .get();
      return snapshot.docs.map((e) => Video.doc(e)).toList();
    } catch (e) {
      logger.d('error:${e.toString()}');
      rethrow;
    }
  }

  // 勉強会アーカイブ取得
  Future<List<Video>> fetchLectureVideos() async {
    return _fetchVideos('lecture_videos');
  }

  /// 質問zoom切り抜き動画をすべて取得する
  Future<List<Video>> fetchClipVideos() async {
    return _fetchVideos('clip_videos');
  }

  /// 発表会動画をすべて取得する
  Future<List<Video>> fetchPresentationVideos() async {
    return _fetchVideos('presentation_videos');
  }

  Future<List<Video>> _fetchVideos(String collectionName) async {
    final snapshot = await FirebaseFirestore.instance
        .collection(collectionName)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) {
      return Video.doc(doc);
    }).toList();
  }

  /// そのユーザーの動画履歴をすべて取得する
  Future<List<VideoHistory>> fetchVideoHistory() async {
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser!;
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .collection('video_history')
          .get();
      return snapshot.docs.map((e) => VideoHistory.doc(e)).toList();
    } catch (e) {
      logger.d('error:${e.toString()}');
      rethrow;
    }
  }

  Future<List<VideoComment>> fetchComments({
    required String chapterId,
    required String videoId,
  }) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(chapterId)
          .doc(videoId)
          .collection('comment')
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs.map((e) => VideoComment.doc(e)).toList();
    } catch (e) {
      logger.d('error:${e.toString()}');
      rethrow;
    }
  }

  Future addComment({
    required String chapterId,
    required String videoId,
    required String? nickname,
    required String commentText,
    required String? photoURL,
    required String userId,
  }) async {
    final DateTime createdAt = DateTime.now();
    return await FirebaseFirestore.instance
        .collection(chapterId)
        .doc(videoId)
        .collection('comment')
        .doc()
        .set({
      'name': nickname,
      'commentText': commentText,
      'createdAt': createdAt,
      'photoURL': photoURL,
      'userId': userId,
    });
  }

  Future deleteComment({
    required String chapterId,
    required String videoId,
    required String commentId,
  }) async {
    await FirebaseFirestore.instance
        .collection(chapterId)
        .doc(videoId)
        .collection('comment')
        .doc(commentId)
        .delete();
  }

  Future incrementVideoLikeCount({
    required String chapterId,
    required String videoId,
  }) async {
    final document =
        FirebaseFirestore.instance.collection(chapterId).doc(videoId);
    await document.update({'likeCount': FieldValue.increment(1)});
  }

  Future decrementVideoLikeCount({
    required String chapterId,
    required String videoId,
  }) async {
    final document =
        FirebaseFirestore.instance.collection(chapterId).doc(videoId);
    await document.update({'likeCount': FieldValue.increment(-1)});
  }

  Future getVideoLikeCount({
    required String chapterId,
    required String videoId,
  }) async {
    final document =
        FirebaseFirestore.instance.collection(chapterId).doc(videoId);
    final snapshot = await document.get();
    final video = Video.doc(snapshot);
    return video.likeCount;
  }

  Future updateVideoUser({
    required String chapterId,
    required String videoId,
    required String userId,
  }) async {
    final document =
        FirebaseFirestore.instance.collection(chapterId).doc(videoId);
    await document.update({'userId': userId});
  }
}
