import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class VideoCard extends StatelessWidget {
  final String id;
  final List<Video> videos;

  const VideoCard({
    Key? key,
    required this.id,
    required this.videos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (videos.isEmpty) {
      return const Center(
        child: Text(
          '該当する動画がありません',
          style: MultiLineStyle(
            fontSize: 12,
          ),
        ),
      );
    }
    return Scrollbar(
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: videos.map((video) {
          return InkWell(
            onTap: () async {
              context.go(
                VideoDetailPage.route(
                  id,
                  video.id,
                ),
                extra: videos,
              );
            },
            child: Container(
              padding: const EdgeInsets.only(
                right: 4,
                left: 4,
                bottom: 12,
              ),
              width: 140,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: Image.network(
                        video.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 54,
                    child: Text(
                      video.title,
                      maxLines: 3,
                      style: const MultiLineStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
