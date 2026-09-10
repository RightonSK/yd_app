import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

import '../../domain/reservation.dart';
import '../../repository/calendar_repository.dart';
import '../../repository/reservation_repository.dart';

class CalendarModel extends ChangeNotifier {
  CalendarModel(this.googleToken, this.calendarId);

  final String googleToken;
  final String calendarId;

  DateTime selectedDate = DateTime.now();
  DateTime focusedDay = DateTime.now();
  DateTime focusedSunday = DateTime.now().weekday == DateTime.sunday
      ? DateTime.now()
      : DateTime.now().subtract(Duration(days: DateTime.now().weekday));

  DateTime? startDate;
  DateTime? endDate;
  List<CalendarItem> selectedEvents = [];
  List<CalendarItem>? todayEvents;
  Map<DateTime, List<CalendarItem>>? eventsMap;
  bool isLoading = true;
  String? calendarImageURL;
  List<Reservation>? reservations;
  User? user;
  AbstractSubscription? subscription;

  late final _calendarRepo = CalendarRepository(
    googleToken: googleToken,
    calendarId: calendarId,
  );
  final _userRepo = UserRepository();

  Future init() async {
    user = await _userRepo.fetchMyUser();
    subscription = await _userRepo.fetchSubscriptionFlesh();

    await _fetchGoogleCalendar();
    await _fetchTodayEvents();
    await _fetchCalendarImage();
    await _fetchReservations();

    endLoading();

    _selectToday();
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future _fetchGoogleCalendar() async {
    eventsMap = await _calendarRepo.fetch();
    final eventsMapEntry = eventsMap!.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    startDate = eventsMapEntry.first.key;
    endDate = eventsMapEntry.last.key;
  }

  Future<void> _fetchTodayEvents() async {
    final now = DateTime.now();
    final todayDateKey = DateTime(now.year, now.month, now.day);
    todayEvents = eventsMap![todayDateKey] ?? [];
    todayEvents?.sort((a, b) {
      final aTime = a.start!.dateTime!.createTheTimeToday();
      final bTime = b.start!.dateTime!.createTheTimeToday();
      return aTime.compareTo(bTime);
    });
  }

  Future _fetchCalendarImage() async {
    final info = await InfoRepository().fetch();
    calendarImageURL = info.calendarImageURL;
    notifyListeners();
  }

  Future _fetchReservations() async {
    final reservations = await ReservationRepository().fetchReservations();
    this.reservations = reservations;
    notifyListeners();
  }

  void _selectToday() {
    final now = DateTime.now();
    final dateKey = DateTime(now.year, now.month, now.day);
    onDaySelected(dateKey);
  }

  void onDaySelected(DateTime day) {
    // webは選択できなくする
    if (kIsWeb) {
      return;
    }

    final dateKey = DateTime(day.year, day.month, day.day);
    focusedDay = dateKey;
    selectedDate = dateKey;

    if (eventsMap == null || eventsMap!.isEmpty) {
      selectedEvents = [];
    } else {
      selectedEvents = eventsMap?[dateKey] ?? [];
      selectedEvents.sort((a, b) {
        final aTime = a.start!.dateTime!.createTheTimeToday();
        final bTime = b.start!.dateTime!.createTheTimeToday();
        return aTime.compareTo(bTime);
      });
    }
    notifyListeners();
  }

  void onPageChanged(DateTime focusedDay) {
    logger.d('page changed');
    logger.d(focusedDay);

    this.focusedDay = focusedDay;

    if (focusedDay.weekday != DateTime.sunday) {
      focusedSunday = focusedDay.subtract(Duration(days: focusedDay.weekday));
    } else {
      focusedSunday = focusedDay;
    }
    notifyListeners();
  }

  Future reserveQuestionZoom(CalendarItem item) async {
    final user = await _userRepo.fetchMyUser();

    if (user == null) {
      throw Exception('ユーザーが見つかりませんでした');
    }
    final reservation = Reservation(
      id: '${item.id}_${item.start?.dateTime.toString()}_${user.id}',
      userId: user.id,
      userName: user.nickname,
      userImageURL: user.photoUrl,
      eventName: item.summary,
      start: item.start?.dateTime,
      end: item.end?.dateTime,
      createdAt: DateTime.now(),
    );
    await ReservationRepository().createReservation(reservation);
  }

  Future cancelQuestionZoom(CalendarItem item) async {
    final reservation = fetchYourReservation(item);
    final id = reservation?.id;

    if (id == null) {
      throw Exception('予約が見つかりませんでした');
    }

    await ReservationRepository().cancelReservation(id);
  }

  int? reservationCount(CalendarItem item) {
    final itemId = item.id;

    if (itemId == null) {
      return null;
    }

    if (reservations == null) {
      return null;
    }

    return reservations!
        .where((reservation) =>
            reservation.id.contains(itemId) &&
            reservation.start == item.start?.dateTime)
        .toList()
        .length;
  }

  bool isFull(CalendarItem item) {
    final count = reservationCount(item) ?? 0;
    return count >= 3;
  }

  bool isYouReserved(CalendarItem item) {
    return fetchYourReservation(item) != null;
  }

  Reservation? fetchYourReservation(CalendarItem item) {
    final itemId = item.id;

    if (itemId == null) {
      return null;
    }
    return reservations?.firstWhereOrNull((reservation) =>
        reservation.id.contains(itemId) &&
        reservation.userId == user?.id &&
        reservation.start == item.start?.dateTime);
  }

  bool shouldGrayOutReserveButton(CalendarItem item) {
    return isPast(item) || !_isAvailablePlan() || !_isWithinAWeek(item);
  }

  bool isPast(CalendarItem item) {
    final now = DateTime.now();
    final itemTime = item.end?.dateTime;
    return itemTime?.isBefore(now) ?? false;
  }

  bool isNow(CalendarItem item) {
    final now = DateTime.now();
    final start = item.start?.dateTime;
    final end = item.end?.dateTime;

    if (start == null || end == null) {
      return false;
    }
    return start.isBefore(now) && end.isAfter(now);
  }

  bool isToday(CalendarItem item) {
    final itemTime = item.start?.dateTime;
    final now = DateTime.now();
    return itemTime?.year == now.year &&
        itemTime?.month == now.month &&
        itemTime?.day == now.day;
  }

  /// 質問zoom予約に対して問題があった場合はエラーメッセージを返す
  Future<String?> validate(CalendarItem item) async {
    if (!_isAvailablePlan()) {
      return '修行プランになると予約ができます。';
    }

    if (!_isWithinAWeek(item)) {
      return '１週間後までしか予約できません。';
    }

    // 人数確認前に最新の予約状況を取得しておく
    await _fetchReservations();

    if (isFull(item)) {
      return '予約できる人数が上限に達しています。';
    }

    if (isPast(item)) {
      return '過去の質問zoomは予約できません。';
    }
    return null;
  }

  bool _isAvailablePlan() {
    return isTrainingPlan || isLightTrainingPlan;
  }

  // 現在から1週間以内なら予約できる(やってる途中予約可能)
  bool _isWithinAWeek(CalendarItem item) {
    final start = item.start?.dateTime;
    final end = item.end?.dateTime;

    if (start == null || end == null) {
      return false;
    }

    return start.isBefore(DateTime.now().add(const Duration(days: 7))) &&
        end.isAfter(DateTime.now());
  }

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
}
