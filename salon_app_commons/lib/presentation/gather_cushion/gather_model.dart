import 'package:salon_app_commons/salon_app_commons.dart';

class GatherModel extends CushionModel {
  @override
  final eventId = 'gather';

  @override
  final UserBadge badge = UserBadge.joinGather;

  @override
  FUTReasons? futReason;
}
