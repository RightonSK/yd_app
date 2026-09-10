import 'package:cloud_firestore/cloud_firestore.dart';

import '../salon_app_commons.dart';

class WithdrawInfo {
  final String id;
  final int githubContribution;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int coinAmount;
  final List? isDoneStudyContents;
  final List? likedVideos;
  final bool questionnaireAnswered;
  final String? status;
  final int inviteCount;
  final List<UserBadge> badges;
  final bool detailsSubmitted;
  final bool isOnMyFutNotification;
  final String? mentorId;
  final EngineerAttribute? engineerAttribute;
  final FlutterExperience? flutterExperience;
  final TriggerToKnow? triggerToKnow;
  final Purpose? purpose;
  final String? otherCommentWhenJoining;

  final WithdrawReason withdrawReason;
  final String? withdrawOtherReasonText;
  final DateTime withdrawDate;

  WithdrawInfo._(
    this.id,
    this.githubContribution,
    this.createdAt,
    this.updatedAt,
    this.coinAmount,
    this.isDoneStudyContents,
    this.likedVideos,
    this.questionnaireAnswered,
    this.status,
    this.inviteCount,
    this.badges,
    this.detailsSubmitted,
    this.isOnMyFutNotification,
    this.mentorId,
    this.engineerAttribute,
    this.flutterExperience,
    this.triggerToKnow,
    this.purpose,
    this.otherCommentWhenJoining,
    this.withdrawReason,
    this.withdrawOtherReasonText,
    this.withdrawDate,
  );

  factory WithdrawInfo.fromUser(
    User user, {
    required WithdrawReason reason,
    String? otherReasonText,
  }) {
    return WithdrawInfo._(
      user.id,
      user.githubContribution,
      user.createdAt,
      user.updatedAt,
      user.coinAmount,
      user.isDoneStudyContents,
      user.likedVideos,
      user.questionnaireAnswered,
      user.status,
      user.inviteCount,
      user.badges,
      user.detailsSubmitted,
      user.isOnMyFutNotification,
      user.mentorId,
      user.engineerAttribute,
      user.flutterExperience,
      user.triggerToKnow,
      user.purpose,
      user.otherCommentWhenJoining,
      reason,
      otherReasonText,
      DateTime.now(),
    );
  }

  factory WithdrawInfo.doc(DocumentSnapshot doc) {
    final data = doc.data() as Map;
    return WithdrawInfo._(
      doc.id,
      data['githubContribution'],
      _toDate(data, 'createdAt'),
      _toDate(data, 'updatedAt'),
      data['coinAmount'],
      data['isDoneStudyContents'],
      data['likedVideos'],
      data['questionnaireAnswered'],
      data['status'],
      data['inviteCount'],
      _toUserBadgeList(data, 'badges'),
      data['detailsSubmitted'],
      data['isOnMyFutNotification'],
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
      data['otherCommentWhenJoining'],
      data['withdrawReason'] != null
          ? WithdrawReason.values.byName(data['withdrawReason'])
          : WithdrawReason.other,
      data['withdrawOtherReasonText'],
      _toDate(data, 'withdrawDate'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'githubContribution': githubContribution,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'coinAmount': coinAmount,
      'isDoneStudyContents': isDoneStudyContents,
      'likedVideos': likedVideos,
      'questionnaireAnswered': questionnaireAnswered,
      'status': status,
      'inviteCount': inviteCount,
      'badges': badges.map((badge) => badge.name).toList(),
      'detailsSubmitted': detailsSubmitted,
      'isOnMyFutNotification': isOnMyFutNotification,
      'mentorId': mentorId,
      'engineerAttribute': engineerAttribute?.name,
      'flutterExperience': flutterExperience?.name,
      'triggerToKnow': triggerToKnow?.name,
      'purpose': purpose?.name,
      'otherCommentWhenJoining': otherCommentWhenJoining,
      'withdrawReason': withdrawReason.name,
      'withdrawOtherReasonText': withdrawOtherReasonText,
      'withdrawDate': withdrawDate,
    };
  }

  /// Timestamp => DateTime
  static DateTime _toDate(Map data, String fieldName) {
    if (data[fieldName] is Timestamp) {
      return (data[fieldName] as Timestamp).toDate();
    }
    return DateTime.now();
  }

  static List<UserBadge> _toUserBadgeList(Map data, String fieldName) {
    if (data[fieldName] is List) {
      return (data[fieldName] as List)
          .map((e) => UserBadge.values.byName(e))
          .toList();
    }
    return [];
  }
}

enum WithdrawReason {
  quitFlutter,
  achieveMyGoal,
  atmosphere,
  expensive,
  anotherCommunity,
  hatePerson,
  busyForWork,
  busyForHobby,
  unawareOfSubscription,
  notUsedEfficiently,
  other;

  String get label {
    switch (this) {
      case WithdrawReason.quitFlutter:
        return 'Flutterをやらなくなったから';
      case WithdrawReason.achieveMyGoal:
        return '目標を達成したから';
      case WithdrawReason.atmosphere:
        return 'コミュニティの雰囲気が自分に合わないから';
      case WithdrawReason.expensive:
        return '値段が高いから';
      case WithdrawReason.anotherCommunity:
        return '会社やサークルなど別のコミュニティで十分だから';
      case WithdrawReason.hatePerson:
        return 'コミュニティに嫌いな人がいるから';
      case WithdrawReason.busyForWork:
        return '仕事が忙しくなったから';
      case WithdrawReason.busyForHobby:
        return '別の趣味で忙しくなったから';
      case WithdrawReason.unawareOfSubscription:
        return '定期購読をしていることに気づかなかったから';
      case WithdrawReason.notUsedEfficiently:
        return 'サービスを有効活用できていないから';
      case WithdrawReason.other:
        return 'その他の理由';
    }
  }
}
