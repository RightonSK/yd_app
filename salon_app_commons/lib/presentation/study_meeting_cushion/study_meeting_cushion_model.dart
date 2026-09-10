import 'package:salon_app_commons/salon_app_commons.dart';

class StudyMeetingCushionModel extends CushionModel {
  @override
  final eventId = StudyMeetingCushionPage.route;

  @override
  final badge = UserBadge.joinStudyMeeting;

  @override
  final FUTReasons futReason = FUTReasons.joinStudyMeeting;
}
