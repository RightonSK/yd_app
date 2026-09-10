import 'package:chewie/chewie.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salon_app_commons/domain/comment.dart';
import 'package:salon_app_commons/salon_app_commons.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class VideoDetailModel extends ChangeNotifier {
  VideoDetailModel(
    this.originalChapterId,
    this.originalVideoId,
    this.extraVideos,
  );
  final String originalChapterId;
  final String originalVideoId;
  List<Video>? extraVideos;

  bool? isPaidPlan;
  List<String> likedIds = [];
  User? videoUser;
  User? myUser;
  List<VideoComment>? videoCommentList;

  int imageIndex = 0;
  Video? selectedVideo;
  bool isLoading = false;
  bool isLoadingLikeCount = false;
  bool reloadFlag = false;

  final _userRepo = UserRepository();
  final _videoRepo = VideoRepository();
  final _futRepo = FUTTransactionRepository();

  VideoPlayerController? videoPlayerController;
  ChewieController? vimeoController;
  late final TextEditingController searchController = TextEditingController()
    ..addListener(notifyListeners);
  final confettiController =
      ConfettiController(duration: const Duration(seconds: 1));

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void startLoadingLikeCount() {
    isLoadingLikeCount = true;
    notifyListeners();
  }

  void endLoadingLikeCount() {
    isLoadingLikeCount = false;
    notifyListeners();
  }

  Future init(BuildContext context) async {
    WakelockPlus.enable();

    // お問い合わせボタンを隠す
    URLUtils.hideChannelButton();

    try {
      final user = await _userRepo.fetchMyUser();
      myUser = user;
      final subscription = await _userRepo.fetchSubscriptionFlesh();
      isPaidPlan = subscription?.planType.isPaid;
      likedIds = user!.likedVideos!.map((e) => e.toString()).toList();

      if (extraVideos == null) {
        reloadFlag = true;

        switch (originalChapterId) {
          case 'lecture_videos':
            extraVideos = await _videoRepo.fetchLectureVideos();
            break;
          case 'clip_videos':
            extraVideos = await _videoRepo.fetchClipVideos();
            break;
          case 'presentation_videos':
            extraVideos = await _videoRepo.fetchPresentationVideos();
            break;
        }
      }
      selectedVideo =
          extraVideos?.firstWhere((material) => material.id == originalVideoId);
      await loadVideo();

      if (reloadFlag) {
        // autoPlayするかどうかに使う
        reloadFlag = false;
      }

      notifyListeners();
    } catch (e) {
      logger.d(e);
    }

    videoPlayerController!.addListener(() {
      // 検知したタイミングで再描画する
      notifyListeners();
    });
  }

  Future checkVideoHistory(Video video) async {
    try {
      final history = await _userRepo.fetchVideoHistory(video.id);

      if (history != null) {
        await videoPlayerController
            ?.seekTo(Duration(seconds: history.playBackTime));
        logger.d('seek to ${history.playBackTime}');
      }
    } catch (e) {
      logger.d(e.toString());
      // await videoPlayerController?.seekTo(const Duration(seconds: 0));
      // logger.d('seek to 0 (reset)');
    }
  }

  Future loadVideo() async {
    final video = selectedVideo;

    if (video == null) {
      return;
    }
    logger.d('loadMaterial:${video.id}');

    startLoading();

    videoPlayerController = VideoPlayerController.network(video.url ?? '');
    await videoPlayerController!.initialize();
    vimeoController = ChewieController(
      videoPlayerController: videoPlayerController!,
      autoPlay: !reloadFlag,
      looping: true,
      aspectRatio: 16 / 9,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
      ],
    );
    await vimeoController!.seekTo(const Duration(seconds: 0));
    await checkVideoHistory(video);
    await fetchComment();

    final userId = selectedVideo?.userId;

    if (userId != null) {
      await _fetchVideoUser(userId);
    } else {
      videoUser = null;
    }
    endLoading();
  }

  void setImageIndex(int index) {
    imageIndex = index;
    notifyListeners();
  }

  Future selectVideoFromMenu(Video material) async {
    //　遷移前の動画の秒数を残す
    await addVideoHistory();

    vimeoController?.pause();
    selectedVideo = material;

    // urlの書き換え
    final newURL = VideoDetailPage.route(originalChapterId, material.id);
    URLUtils.changeURLHistory(newURL);

    // 動画のリロード
    await loadVideo();
  }

  Future addLiked(String id) async {
    await _userRepo.updateUserLike(id);
    await _videoRepo.incrementVideoLikeCount(
      chapterId: originalChapterId,
      videoId: id,
    );
  }

  Future removeLiked(String id) async {
    await _userRepo.removeLike(id);
    await _videoRepo.decrementVideoLikeCount(
      chapterId: originalChapterId,
      videoId: id,
    );
  }

  Future checkLikeCountAgain(String videoId) async {
    final user = await _userRepo.fetchMyUser();
    likedIds = user!.likedVideos!.map((id) => id as String).toList();

    final int likeCount = await _videoRepo.getVideoLikeCount(
      chapterId: originalChapterId,
      videoId: videoId, // メニューから遷移したりしてきてるとgrobalのcontentIdはこれと違うので注意
    );
    selectedVideo?.likeCount = likeCount;
    notifyListeners();
  }

  Future _fetchVideoUser(String userId) async {
    videoUser = await _userRepo.fetchUser(userId);
  }

  List<Video> searchVideoByName({
    required String searchWord,
  }) {
    final videos = extraVideos;
    if (videos == null) {
      return [];
    }
    if (searchWord.isEmpty) {
      return videos;
    }
    final searchedMaterials = videos
        .where(
          (element) =>
              element.title.toLowerCase().contains(searchWord.toLowerCase()),
        )
        .toList();
    return searchedMaterials;
  }

  Future addVideoHistory() async {
    final id = selectedVideo?.id;
    final controller = videoPlayerController;

    if (id == null || controller == null) {
      return;
    }

    final duration = controller.value.duration.inSeconds.toInt();
    final playBackTime = controller.value.position.inSeconds.toInt();
    await _userRepo.addPlayBackTime(
      id,
      playBackTime,
      duration,
    );
  }

  Future addComment(String commentText) async {
    final videoId = selectedVideo!.id;
    final nickname = myUser?.nickname;
    final photoUrl = myUser?.photoUrl;
    final userId = myUser!.id;
    await _videoRepo.addComment(
      chapterId: originalChapterId,
      videoId: videoId,
      nickname: nickname,
      commentText: commentText,
      photoURL: photoUrl,
      userId: userId,
    );
    await fetchComment();
  }

  Future fetchComment() async {
    final videoId = selectedVideo?.id;

    if (videoId == null) {
      return;
    }

    final comments = await _videoRepo.fetchComments(
      chapterId: originalChapterId,
      videoId: videoId,
    );
    videoCommentList = comments;
    notifyListeners();
  }

  Future deleteComment(String commentId) async {
    final videoId = selectedVideo!.id;
    await _videoRepo.deleteComment(
      chapterId: originalChapterId,
      videoId: videoId,
      commentId: commentId,
    );
    await fetchComment();
    notifyListeners();
  }


  Future addUserToVideo(User newVideoUser) async {
    final selectedVideo = this.selectedVideo;

    if (selectedVideo == null) {
      return;
    }

    await Future.wait([
      // 動画にユーザーを追加する処理
      _videoRepo.updateVideoUser(
        chapterId: originalChapterId,
        videoId: selectedVideo.id,
        userId: newVideoUser.id,
      ),
      //  追加者へのFUT付与
      _addFUT(FUTReasons.addUserToVideo),
      //  動画映ってる人にFUT付与
      if (originalChapterId == 'lecture_videos')
        _sendFUT(newVideoUser.id, FUTReasons.presentationStudyMeeting),
      if (originalChapterId == 'presentation_videos')
        _sendFUT(newVideoUser.id, FUTReasons.presentationPersonalDevMeeting),
    ]);
    this.selectedVideo?.userId = newVideoUser.id;
  }

  // 自分で自分に付与はできる(セキュリティルール的に)
  Future _addFUT(FUTReasons reasonType) async {
    final uid = _userRepo.myUid!;
    final amount = reasonType.futAmount;

    if (amount == null) {
      return;
    }
    await _futRepo.addObtainTransaction(
      uid: uid,
      coinAmount: amount,
      reason: reasonType,
    );
    await _userRepo.incrementUserFUT(amount);
  }

  Future _sendFUT(String toUserId, FUTReasons reasonType) async {
    final uid = _userRepo.myUid!;
    final amount = reasonType.futAmount;

    if (amount == null) {
      return;
    }
    final FUTTransactionForWhat forWhat;

    if (FUTReasons.presentationPersonalDevMeeting == reasonType) {
      forWhat = FUTTransactionForWhat.presentationPersonalDevMeeting;
    } else if (FUTReasons.presentationStudyMeeting == reasonType) {
      forWhat = FUTTransactionForWhat.presentationStudyMeeting;
    } else {
      return;
    }
    await _userRepo.requestFUTTransaction(
      myId: uid,
      sendUserId: toUserId,
      forWhat: forWhat.name,
      coinAmount: amount,
    );
  }

  @override
  void dispose() async {
    addVideoHistory();
    WakelockPlus.disable();
    vimeoController?.dispose();
    await videoPlayerController?.dispose();

    super.dispose();
  }
}
