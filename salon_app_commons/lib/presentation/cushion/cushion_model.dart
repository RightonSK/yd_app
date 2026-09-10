import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

import '../../domain/reservation.dart';
import '../../repository/reservation_repository.dart';

abstract class CushionModel extends ChangeNotifier {
  String get eventId;
  FUTReasons? get futReason;
  UserBadge? get badge;

  bool isPaidError = false;
  bool isLoading = true;
  bool isButtonLoading = false;
  bool isMeetingTime = false;
  bool canJoinQuestionZoom = false;
  bool isReserved = false;

  Event? event;
  AbstractSubscription? subscription;
  List<Reservation>? reservations;

  bool get isTrainingPlan {
    final subscription = this.subscription;
    if (subscription == null) {
      return false;
    }
    return subscription.planType == PlanType.training;
  }

  bool get isLightTrainingPlan {
    final subscription = this.subscription;
    if (subscription == null) {
      return false;
    }
    return subscription.planType == PlanType.trainingLight;
  }

  final _userRepo = UserRepository();
  final _futRepo = FUTTransactionRepository();
  final _eventRepo = EventRepository();
  final _reserveRepo = ReservationRepository();

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void startButtonLoading() {
    isButtonLoading = true;
    notifyListeners();
  }

  void endButtonLoading() {
    isButtonLoading = false;
    notifyListeners();
  }

  Future init(BuildContext context) async {
    final subscription = await _userRepo.fetchSubscriptionFlesh();
    this.subscription = subscription;
    isPaidError = subscription?.isErrorStatus ?? false;

    if (eventId == QuestionZoomCushionPage.route) {
      await _checkCanJoin();
      await _fetchReservations();
    }

    _checkTime();
    endLoading();
  }

  void _checkTime() {
    _eventRepo.fetchEventStream(eventId).listen((event) {
      this.event = event;
      isMeetingTime = event.isOpen ?? false;
      notifyListeners();
    });
  }

  Future pushToZoomPage() async {
    try {
      await Future.wait([
        _addToParticipant(),
        _addFUT(),
        _addBadge(),
      ]);
    } finally {
      final url = event?.zoomURL;

      if (url != null) {
        await URLUtils.launch(urlString: url);
      }
    }
  }

  Future _addToParticipant() async {
    final userId = _userRepo.myUid;
    if (userId == null) {
      return;
    }
    await _eventRepo.addEventParticipant(
      eventId,
      userId,
    );
  }

  Future _addFUT() async {
    final uid = _userRepo.myUid;

    if (uid == null) {
      return;
    }
    final futReason = this.futReason;
    if (futReason == null) {
      return;
    }

    final isExist = await _futRepo.checkIsExistSameTransaction1HourAgo(
      uid: uid,
      reasonType: futReason,
    );

    if (isExist) {
      return;
    }
    final futAmount = futReason.futAmount;

    if (futAmount == null) {
      return;
    }
    // FIXME: まとめてrunTransactionにしたい (どっちかが失敗すると整合性取れなくなるので)
    await _futRepo.addObtainTransaction(
      uid: uid,
      coinAmount: futAmount,
      reason: futReason,
    );
    await _userRepo.incrementUserFUT(futAmount);
  }

  Future _addBadge() async {
    final badge = this.badge;
    if (badge != null) {
      await _userRepo.addMyBadges([badge]);
    }
  }

  Future _checkCanJoin() async {
    canJoinQuestionZoom = await _checkHasRightOfJoiningQuestionZoom();
    logger.d('canJoinQuestionZoom: $canJoinQuestionZoom');
  }

  Future<bool> _checkHasRightOfJoiningQuestionZoom() async {
    if (isTrainingPlan) {
      return true;
    } else if (isLightTrainingPlan) {
      final user = await _userRepo.fetchMyUser();
      final dates = user?.questionZoomJoinDates ?? [];
      final currentPeriodStart = subscription?.currentPeriodStart;
      final count = _countAfterCurrentPeriodStart(dates, currentPeriodStart);
      logger.d('count: $count');
      return count < 4;
    } else {
      return false;
    }
  }

  // 最近の決済以降の質問zoom参加の回数を数える
  int _countAfterCurrentPeriodStart(
    List<DateTime> questionZoomJoinDates,
    DateTime? currentPeriodStart,
  ) {
    if (currentPeriodStart == null) {
      return 0;
    }
    return questionZoomJoinDates
        .where((date) => date.isAfter(currentPeriodStart))
        .length;
  }

  Future _fetchReservations() async {
    final reservations = await _reserveRepo.fetchReservations();
    this.reservations = reservations;

    // 今日の予約があるか確認する
    final today = DateTime.now();
    final isReserved = reservations.any((reservation) {
      final start = reservation.start;
      if (start == null) {
        return false;
      }
      return start.year == today.year &&
          start.month == today.month &&
          start.day == today.day;
    });
    this.isReserved = isReserved;

    notifyListeners();
  }
}
