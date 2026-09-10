import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

/// ユーザ
class User {
  final String id;
  final String? email;
  final String? nickname;
  final String? githubUsername;
  final int? githubId;
  final int githubContribution;
  final List<int> githubContributionArray;
  final String? slackEmail;
  final String? photoUrl;
  final String? bio;
  final Prefecture prefecture;
  final LatLng? location;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? role;
  final int coinAmount;
  final List? isDoneStudyContents;
  final List? likedVideos;
  final String? priceRef;
  final String? stripeId;
  final String? stripeAccountId;
  final bool questionnaireAnswered;
  final String? status;
  final String? slackTimesId;
  final String? slackId;
  final int inviteCount;
  final List<UserBadge> badges;
  final List<RevenueCatSubscription> revenueCatSubscriptions;
  final bool detailsSubmitted;
  final bool isOnMyFutNotification;
  final String? mentorId;
  final EngineerAttribute? engineerAttribute;
  final FlutterExperience? flutterExperience;
  final TriggerToKnow? triggerToKnow;
  final Purpose? purpose;
  final JobSeekingStatus? jobSeekingStatus;
  final String? otherCommentWhenJoining;
  final List<DateTime> questionZoomJoinDates;
  final String? zennId;

  /// ポートフォリオが審査中かどうか
  final bool isReviewing;

  /// 通知を未読
  final bool notificationUnread;

  User._(
    this.id,
    this.email,
    this.nickname,
    this.githubUsername,
    this.githubId,
    this.githubContribution,
    this.githubContributionArray,
    this.slackEmail,
    this.photoUrl,
    this.bio,
    this.prefecture,
    this.location,
    this.createdAt,
    this.updatedAt,
    this.role,
    this.coinAmount,
    this.priceRef,
    this.isDoneStudyContents,
    this.likedVideos,
    this.isReviewing,
    this.notificationUnread,
    this.stripeId,
    this.stripeAccountId,
    this.questionnaireAnswered,
    this.status,
    this.slackTimesId,
    this.slackId,
    this.inviteCount,
    this.badges,
    this.revenueCatSubscriptions,
    this.detailsSubmitted,
    this.isOnMyFutNotification,
    this.mentorId,
    this.engineerAttribute,
    this.flutterExperience,
    this.triggerToKnow,
    this.purpose,
    this.jobSeekingStatus,
    this.otherCommentWhenJoining,
    this.questionZoomJoinDates,
    this.zennId,
  );

  factory User.doc(DocumentSnapshot doc) {
    final data = doc.data() as Map;
    return User.json(doc.id, data);
  }

  factory User.json(String id, Map data) {
    final user = User._(
      id,
      data['email'],
      data['nickname'],
      data['github_username'],
      data['githubId'],
      data['githubContribution'] ?? 0,
      _toGithubContributionArray(data, 'githubContributionArray'),
      data['slackEmail'],
      data['photoUrl'],
      data['bio'],
      PrefectureHelper.from(data['prefecture']),
      PrefectureHelper.from(data['prefecture']).location,
      _toDate(data, 'createdAt'),
      _toDate(data, 'updatedAt'),
      data['role'],
      data['coinAmount'] ?? 0,
      data['priceRef'],
      data['isDoneStudyContents'] ?? [],
      data['likedVideos'] ?? [],
      data['isReviewing'] ?? false,
      data['notificationUnread'] ?? false,
      data['stripeId'],
      data['stripeAccountId'],
      data['questionnaireAnswered'] ?? false,
      data['status'],
      data['slackTimesId'],
      data['slackId'],
      data['inviteCount'] ?? 0,
      _toUserBadgeList(data, 'badges'),
      _toRevenueCatSubscriptions(data['subscriptions']),
      data['detailsSubmitted'] ?? false,
      data['isOnMyFutNotification'] ?? false,
      data['mentorId'],
      data['engineerAttribute'] != null
          ? EngineerAttribute.values.byName(data['engineerAttribute'])
          : null,
      data['flutterExperience'] != null
          ? FlutterExperience.values.byName(data['flutterExperience'])
          : null,
      data['triggerToKnow'] != null
          ? TriggerToKnow.values.byName(data['triggerToKnow'])
          : null,
      data['purpose'] != null ? Purpose.values.byName(data['purpose']) : null,
      data['jobSeekingStatus'] != null
          ? JobSeekingStatus.values.byName(data['jobSeekingStatus'])
          : null,
      data['otherCommentWhenJoining'],
      _toQuestionZoomJoinDates(data, 'questionZoomJoinDates'),
      data['zennId'],
    );
    return user;
  }

  /// Timestamp => DateTime
  static DateTime _toDate(Map data, String fieldName) {
    if (data[fieldName] is Timestamp) {
      return (data[fieldName] as Timestamp).toDate();
    }
    return DateTime.now();
  }

  static List<int> _toGithubContributionArray(Map data, String fieldName) {
    if (data[fieldName] is List) {
      return (data[fieldName] as List).map((e) => e as int).toList();
    }
    return [];
  }

  static List<UserBadge> _toUserBadgeList(Map data, String fieldName) {
    if (data[fieldName] is List) {
      return (data[fieldName] as List)
          .map((e) => UserBadge.values.byName(e))
          .toList();
    }
    return [];
  }

  static List<RevenueCatSubscription> _toRevenueCatSubscriptions(
    Map? data,
  ) {
    if (data == null) {
      return [];
    }
    return data.entries
        .map((e) => RevenueCatSubscription.json(e.key, e.value))
        .toList();
  }

  static List<DateTime> _toQuestionZoomJoinDates(Map data, String fieldName) {
    if (data[fieldName] is List) {
      return (data[fieldName] as List).map((e) {
        final timestamp = e as Timestamp;
        return timestamp.toDate();
      }).toList();
    }
    return [];
  }

  int get dailyGithubContribution {
    if (githubContributionArray.length < 2) {
      return 0;
    }
    // 前日のcontribution
    return githubContributionArray[githubContributionArray.length - 2];
  }

  int get weeklyGithubContribution {
    if (githubContributionArray.length < 2) {
      return 0;
    }
    final sliced = githubContributionArray.sublist(
        githubContributionArray.length - 7 - 2, // 7日前
        githubContributionArray.length - 2); // 前日
    final reduced = sliced.reduce((a, b) => a + b);
    return reduced;
  }

  int get monthlyGithubContribution {
    if (githubContributionArray.length < 2) {
      return 0;
    }
    final sliced = githubContributionArray.sublist(
        githubContributionArray.length - 30 - 2, // 30日前
        githubContributionArray.length - 2); // 前日
    final reduced = sliced.reduce((a, b) => a + b);
    return reduced;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nickname': nickname,
      'githubUsername': githubUsername,
      'githubId': githubId,
      'githubContribution': githubContribution,
      'githubContributionArray': githubContributionArray,
      'slackEmail': slackEmail,
      'photoUrl': photoUrl,
      'bio': bio,
      'prefecture': prefecture.value,
      'location': location != null
          ? {
              'latitude': location!.latitude,
              'longitude': location!.longitude,
            }
          : null,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'role': role,
      'coinAmount': coinAmount,
      'isDoneStudyContents': isDoneStudyContents,
      'likedVideos': likedVideos,
      'priceRef': priceRef,
      'stripeId': stripeId,
      'stripeAccountId': stripeAccountId,
      'questionnaireAnswered': questionnaireAnswered,
      'status': status,
      'slackTimesId': slackTimesId,
      'slackId': slackId,
      'inviteCount': inviteCount,
      'badges': badges.map((badge) => badge.name).toList(),
      'revenueCatSubscriptions':
          revenueCatSubscriptions.map((sub) => sub.toJson()).toList(),
      'detailsSubmitted': detailsSubmitted,
      'isOnMyFutNotification': isOnMyFutNotification,
      'mentorId': mentorId,
      'engineerAttribute': engineerAttribute?.name,
      'flutterExperience': flutterExperience?.name,
      'triggerToKnow': triggerToKnow?.name,
      'purpose': purpose?.name,
      'otherCommentWhenJoining': otherCommentWhenJoining,
      'questionZoomJoinDates': questionZoomJoinDates,
    };
  }

  User copyWith({
    int? newFUTCoinAmount,
    int? newGithubContribution,
  }) =>
      User._(
        id,
        email,
        nickname,
        githubUsername,
        githubId,
        newGithubContribution ?? githubContribution,
        githubContributionArray,
        slackEmail,
        photoUrl,
        bio,
        prefecture,
        location,
        createdAt,
        updatedAt,
        role,
        newFUTCoinAmount ?? coinAmount,
        priceRef,
        isDoneStudyContents,
        likedVideos,
        isReviewing,
        notificationUnread,
        stripeId,
        stripeAccountId,
        questionnaireAnswered,
        status,
        slackTimesId,
        slackId,
        inviteCount,
        badges,
        revenueCatSubscriptions,
        detailsSubmitted,
        isOnMyFutNotification,
        mentorId,
        engineerAttribute,
        flutterExperience,
        triggerToKnow,
        purpose,
        jobSeekingStatus,
        otherCommentWhenJoining,
        questionZoomJoinDates,
        zennId,
      );
}
