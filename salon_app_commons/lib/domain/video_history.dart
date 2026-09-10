import 'package:cloud_firestore/cloud_firestore.dart';

class VideoHistory {
  final String? id;
  final int playBackTime;
  final int? duration; // 後から追加したのでnullを許容

  VideoHistory._(
    this.id,
    this.playBackTime,
    this.duration,
  );

  factory VideoHistory.doc(DocumentSnapshot doc) {
    final data = doc.data() as Map;
    return VideoHistory._(doc.id, data['playBackTime'], data['duration']);
  }

  double progressIndicatorValue() {
    if (duration == null) {
      return 0;
    }
    return playBackTime / duration!;
  }
}
