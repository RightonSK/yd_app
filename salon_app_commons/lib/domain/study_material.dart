import 'package:salon_app_commons/domain/video.dart';

class StudyMaterial {
  String id;
  String? title;
  String? description;
  String? thumbURL;
  String? youtubeId = 'VZ9wcJ920XA';
  String? vimeoURL =
      'https://player.vimeo.com/external/588875275.hd.mp4?s=45eac8d63f79bd1443c5fa729aa37e9bab8a7dc6&profile_id=170&oauth2_token_id=1367321380';
  String? userId;
  String? link;
  int likeCount;

  StudyMaterial(
    this.id,
    this.title,
    this.description,
    this.thumbURL,
    this.youtubeId,
    this.vimeoURL,
    this.link,
    this.likeCount, {
    this.userId,
  });

  static StudyMaterial fromVideo(Video video) {
    return StudyMaterial(
      video.id,
      video.title,
      video.description,
      video.image,
      null,
      video.url,
      video.link,
      video.likeCount ?? 0,
      userId: video.userId,
    );
  }
}
