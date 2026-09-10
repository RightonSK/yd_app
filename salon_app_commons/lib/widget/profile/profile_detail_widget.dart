import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

import 'apps_grid_view.dart';
import 'badget_list_widget.dart';
import 'gift_fut_widget.dart';
import 'video_widget.dart';

class ProfileDetailWidget extends StatelessWidget {
  const ProfileDetailWidget(
    this.user, {
    super.key,
    required this.apps,
    required this.lectureVideos,
    required this.presentationVideos,
    required this.clipVideos,
    this.videoHistories,
  });
  final User user;
  final List<UserApp> apps;
  final List<Video> lectureVideos;
  final List<Video> presentationVideos;
  final List<Video> clipVideos;
  final List<VideoHistory>? videoHistories;

  @override
  Widget build(BuildContext context) {
    if (user.nickname == null) {
      return const Center(child: Text('ユーザーの取得に失敗しました'));
    }
    final isMyPage = UserRepository().myUid == user.id;
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                children: [
                  if (!isMyPage)
                    GiftFUTWidget(
                      user,
                    ),
                  BadgeListWidget(
                    user,
                    havingBadges: user.badges,
                  ),
                  AppsGridView(
                    apps: apps,
                    isMyPage: isMyPage,
                  ),
                  if (lectureVideos.isNotEmpty)
                    VideoWidget(
                      title: '登壇した勉強会',
                      category: StudyContentCategory.studyMeeting,
                      videos: lectureVideos,
                      videoHistories: videoHistories,
                    ),
                  if (presentationVideos.isNotEmpty)
                    VideoWidget(
                      title: '登壇した発表会',
                      category: StudyContentCategory.presentation,
                      videos: presentationVideos,
                      videoHistories: videoHistories,
                    ),
                  if (clipVideos.isNotEmpty)
                    VideoWidget(
                      title: '質問したZoom',
                      category: StudyContentCategory.clip,
                      videos: clipVideos,
                      videoHistories: videoHistories,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
