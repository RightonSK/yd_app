import 'package:flutter/cupertino.dart';
import 'package:salon_app_commons/repository/withdraw_repository.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class WithdrawModel extends ChangeNotifier {
  AbstractSubscription? subscription;
  List<StripeSubscriptionSchedule> reservations = [];
  List<StripeSubscriptionSchedule> _reservedActiveSchedule =
      []; // 予約されて、現在はそのサイクルにいる状態のスケジュール（例えば修行プランから、コミュニティプランに予約変更して、今コミュニティプランだった場合ここに値が入る）

  bool isLoading = true;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  /// 初期化処理
  Future init() async {
    startLoading();

    if (UserRepository().isLogin) {
      // 現在のサブスクを取得
      subscription = await UserRepository().fetchSubscriptionFlesh();

      // 予約一覧を取得
      final user = await UserRepository().fetchMyUser();
      final stripeId = user?.stripeId;

      if (stripeId != null) {
        reservations = await StripeRepository().fetchReservations(
          customerId: stripeId,
        );
        final activeSubscriptionSchedules =
            await StripeRepository().fetchActiveSubscriptionSchedules(
          customerId: stripeId,
        );

        // もし、予約はないのにactiveSubscriptionSchedulesがあった場合は、過去に予約したプランに現在いるということ
        // その状態での退会予約情報はScheduleに入っているので、ここで格納し、適切にUIで表示する
        if (reservations.isEmpty && activeSubscriptionSchedules.isNotEmpty) {
          _reservedActiveSchedule = activeSubscriptionSchedules;
        }
      }
    }
    endLoading();
  }

  /// 退会の申込みをキャンセルする
  Future cancelToWithdraw(BuildContext context) async {
    final subscription = this.subscription;

    if (subscription is StripeSubscription) {
      final user = await UserRepository().fetchMyUser();

      if (user != null) {
        // 退会の申込みをキャンセルする
        await StripeRepository().cancelWithdraw(customerId: user.stripeId!);
        await WithdrawRepository().cancel(user.id);
      }
    }
  }

  bool get isUnderCancelReservation {
    final subscription = this.subscription;

    if (_reservedActiveSchedule.isNotEmpty &&
        _reservedActiveSchedule.first.endBehavior == 'cancel') {
      return true;
    } else if (subscription is StripeSubscription &&
        subscription.isWithdrawing) {
      return true;
    } else {
      return false;
    }
  }

  DateTime? get cancelAt {
    final subscription = this.subscription;

    if (subscription is StripeSubscription) {
      return subscription.cancelAt;
    }
    return null;
  }
}
