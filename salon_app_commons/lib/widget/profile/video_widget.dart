import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

import '../study_content_item_widget.dart';

class VideoWidget extends StatelessWidget {
  final String title;
  final StudyContentCategory category;
  final List<Video> videos;
  final List<VideoHistory>? videoHistories;

  const VideoWidget({
    Key? key,
    required this.title,
    required this.category,
    required this.videos,
    required this.videoHistories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 8,
            left: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.apps,
                color: Colors.white,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                title,
                style: const MultiLineStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: videos.length,
          itemExtent: 96,
          itemBuilder: (context, index) {
            final video = videos[index];
            final VideoHistory? videoHistory = videoHistories
                ?.firstWhereOrNull((history) => history.id == video.id);
            return StudyContentItemWidget(
              isDarkColor: true,
              thumbURL: video.image,
              title: video.title,
              createdAt: video.createdAt.getHowLongTimeAgoString(),
              isNew: video.createdAt.checkShouldShowNewLabel(),
              ratio: videoHistory?.progressIndicatorValue() ?? 0,
              onTap: () async {
                context.push(
                  VideoDetailPage.route(
                    category.urlPath,
                    video.id,
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
