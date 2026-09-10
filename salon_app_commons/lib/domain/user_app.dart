import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class UserApp {
  String id;
  String? userId;
  String? appTitle;
  String? appIconImageURL;
  String? appDescription;
  String? iOSURL;
  String? androidURL;
  String? webURL;
  Timestamp? releasedAt;
  Timestamp? latestReleaseDate;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  bool isTeam;
  bool isActive;
  String? github;
  List<String> userIds;
  String? slackId;

  UserApp(
    this.id,
    this.userId,
    this.appTitle,
    this.appIconImageURL,
    this.appDescription,
    this.iOSURL,
    this.androidURL,
    this.webURL,
    this.releasedAt,
    this.latestReleaseDate,
    this.createdAt,
    this.updatedAt,
    this.isTeam,
    this.isActive,
    this.github,
    this.userIds,
    this.slackId,
  );

  factory UserApp.doc(DocumentSnapshot doc) {
    final data = doc.data() as Map;
    return UserApp(
      doc.id,
      data['userId'],
      data['appTitle'],
      data['appIconImageURL'],
      data['appDescription'],
      data['iOSURL'],
      data['androidURL'],
      data['webURL'],
      data['releasedAt'],
      data['latestReleaseDate'],
      data['createdAt'],
      data['updatedAt'],
      data['isTeam'] ?? false,
      data['isActive'] ?? false,
      data['github'],
      _toList(data, 'userIds'),
      data['slackId'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['docId'] = id;
    data['userId'] = userId;
    data['appTitle'] = appTitle;
    data['appIconImageURL'] = appIconImageURL;
    data['appDescription'] = appDescription;
    data['iOSURL'] = iOSURL;
    data['androidURL'] = androidURL;
    data['webURL'] = webURL;
    data['releasedAt'] = releasedAt;
    data['latestReleaseDate'] = latestReleaseDate;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['isTeam'] = isTeam;
    data['isActive'] = isActive;
    data['github'] = github;
    data['userIds'] = userIds;
    data['slackId'] = slackId;
    return data;
  }

  static List<String> _toList(Map data, String fieldName) {
    if (data[fieldName] is List) {
      return (data[fieldName] as List).map((e) => e.toString()).toList();
    }
    return [];
  }

  /// Get display release date with 3-month logic
  String getDisplayReleaseDate() {
    if (latestReleaseDate != null && releasedAt != null) {
      final monthsSinceRelease = DateTime.now().difference(releasedAt!.toDate()).inDays / 30;
      if (monthsSinceRelease >= 3) {
        return '${latestReleaseDate!.toDate().getHowLongTimeAgoString()}${t.works.updated_ago}';
      }
    }
    return releasedAt != null ? '${releasedAt!.toDate().getHowLongTimeAgoString()}${t.works.released_ago}' : '開発中';
  }
}
