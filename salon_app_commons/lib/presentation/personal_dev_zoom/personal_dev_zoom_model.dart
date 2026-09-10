import 'package:salon_app_commons/salon_app_commons.dart';

class PersonalDevZoomModel extends CushionModel {
  @override
  final eventId = PersonalDevZoomPage.route;

  @override
  final badge = UserBadge.joinPersonalDevZoom;

  @override
  final FUTReasons futReason = FUTReasons.joinPersonalDevMeeting;
}
