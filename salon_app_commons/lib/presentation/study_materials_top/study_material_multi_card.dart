import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

import 'video_card.dart';

class StudyMaterialMultiCard extends StatelessWidget {
  const StudyMaterialMultiCard({
    Key? key,
    required this.id,
    required this.title,
    required this.description,
    required this.videos,
  }) : super(key: key);

  final String id;
  final String title;
  final String description;
  final List<Video> videos;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        child: SizedBox(
          height: 230,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const BoldMultiLineStyle(fontSize: 20),
                ),
                Text(
                  description,
                  style: const MultiLineStyle(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                Expanded(
                  child: VideoCard(
                    id: id,
                    videos: videos,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: () async {
        context.go(
          VideoDetailPage.route(
            id,
            videos.first.id,
          ),
          extra: videos,
        );
      },
    );
  }
}
