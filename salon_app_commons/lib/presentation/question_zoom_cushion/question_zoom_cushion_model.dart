import 'package:salon_app_commons/salon_app_commons.dart';

class QuestionZoomCushionModel extends CushionModel {
  @override
  final eventId = QuestionZoomCushionPage.route;

  @override
  final badge = UserBadge.joinQuestionZoom;

  @override
  final FUTReasons? futReason = null;

  @override
  Future pushToZoomPage() async {
    if (!canJoinQuestionZoom) {
      throw '制限回数を超えたため参加できません。\n参加するためにはプランを変更してください';
    }
    await super.pushToZoomPage();
    await _addJoinDateToUser();
  }

  Future _addJoinDateToUser() async {
    final userRepo = UserRepository();
    final uid = userRepo.myUid;

    if (uid == null) {
      return;
    }

    await userRepo.addQuestionZoomJoinDate(uid);
  }
}
