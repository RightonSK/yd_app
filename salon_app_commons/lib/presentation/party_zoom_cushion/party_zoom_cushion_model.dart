import 'package:salon_app_commons/salon_app_commons.dart';

class PartyZoomCushionModel extends CushionModel {
  @override
  final eventId = PartyZoomCushionPage.route;

  @override
  final badge = UserBadge.joinPartyZoom;

  @override
  final FUTReasons futReason = FUTReasons.joinPartyMeeting;
}
