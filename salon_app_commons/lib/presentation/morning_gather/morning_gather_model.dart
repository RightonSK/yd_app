import 'package:salon_app_commons/salon_app_commons.dart';

class MorningGatherModel extends CushionModel {
  @override
  final eventId = 'morning_gather';

  @override
  final UserBadge badge = UserBadge.joinGather;

  @override
  FUTReasons? futReason = FUTReasons.joinMorningGather;
}
