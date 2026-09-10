import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:collection/collection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:salon_app_commons/domain/stripe_subscription_schedule.dart';

import '../domain/price.dart';
import '../domain/stripe_subscription.dart';
import '../domain/stripe_upcoming_invoice.dart';
import '../utils/log_utils.dart';
import '../utils/url_utils_native.dart' if (dart.library.html) '../utils/url_utils_web.dart';
import 'functions_repository.dart';
import 'user_repository.dart';

/// Stripe関連の操作をまとめたクラス (Singleton)
class StripeRepository {
  static StripeRepository? _instance;
  StripeRepository._internal();
  final _functionsRepository = FunctionsRepository();

  /// コンストラクタ
  factory StripeRepository() {
    return _instance ??= StripeRepository._internal();
  }

  /// Stripeのカスタマーポータル画面に遷移する
  Future redirectToCustomerPortal(String returnUrl) async {
    String? url;
    try {
      final functions = FirebaseFunctions.instanceFor(
        app: Firebase.app(),
        region: 'asia-northeast1',
      );
      final callable = functions.httpsCallable('ext-firestore-stripe-subscriptions-createPortalLink');
      final result = await callable.call(
        {
          'returnUrl': returnUrl,
        },
      );
      url = result.data != null ? result.data['url'] : null;
    } on FirebaseFunctionsException catch (e) {
      logger.d('caught firebase functions exception');
      logger.d(e.code);
      logger.d(e.message);
      logger.d(e.details);
    } catch (e) {
      logger.d('caught generic exception');
      logger.d(e);
    }

    if (url == null) {
      throw ('URL取得に失敗しています。サーバーエラーもしくはバグです。運営にお問い合わせください！');
    }
    await URLUtils.launch(urlString: url, shouldOpenNewTab: false);
  }

  /// StripeのCheckout画面に遷移する
  Future<String> fetchCheckoutURL({
    required String? customerId,
    required String priceId,
    required String successUrl,
    required String cancelUrl,
    String mode = 'subscription',
    required String publishableKey,
  }) async {
    try {
      if (customerId == null || customerId == 'null') {
        // firebase extensionのsyncの設定がNoの時のユーザーが来ない限りは基本的に空のことはない
        final id = await _createCustomer();
        customerId = id;
      }
      final checkoutSession = {
        'customer': customerId,
        'allow_promotion_codes': true,
        'billing_address_collection': 'auto',
        'success_url': successUrl,
        'cancel_url': cancelUrl,
        'mode': mode,
        'line_items': [
          {
            'price': priceId,
            'quantity': 1,
          },
        ],
      };
      final url = await _createCheckoutURL(checkoutSession);
      return url;
    } catch (e) {
      logger.d('caught generic exception');
      logger.d(e);
      throw ('エラーが発生しました。再度お試し下さい');
    }
  }

  Future<String> fetchDestinationCheckoutURL({
    required String successUrl,
    required String cancelUrl,
    required String publishableKey,
    required String customerId,
    required String targetUserId,
    required String accountId,
    required String planId,
    required String title,
    required int amount,
    required double commissionRate,
  }) async {
    try {
      // payment_intent_dataがfirebase extensionだと認識されなかったので、APIに変更した
      final checkoutSession = {
        'allow_promotion_codes': true,
        'billing_address_collection': 'auto',
        'success_url': successUrl,
        'cancel_url': cancelUrl,
        'mode': 'payment',
        'line_items': [
          {
            'price_data': {
              'currency': 'jpy',
              'product_data': {
                'name': title,
              },
              'unit_amount': amount,
            },
            'quantity': 1,
          },
        ],
        'payment_intent_data': {
          'application_fee_amount': (amount * commissionRate).ceil(), // 小数点切り上げ
          'transfer_data': {
            'destination': accountId,
          },
          'metadata': {
            'userId': targetUserId,
            'planId': planId,
            'planName': title,
          },
        },
        'customer': customerId,
      };
      final url = await _createCheckoutURL(checkoutSession);
      return url;
    } catch (e) {
      logger.d('caught generic exception');
      logger.d(e);
      throw ('エラーが発生しました。再度お試し下さい');
    }
  }

  //////////// StripeAPI Method ////////////

  /// 決済アイテムのリストを取得する
  Future<Map<String, dynamic>?> _fetchSubscriptionItems(StripeSubscription? subscription) async {
    if (subscription == null) {
      return null;
    }

    try {
      final result = await _functionsRepository.call(
        functionName: 'stripe-getSubscriptionItems',
      );
      return result.data;
    } catch (e) {
      // do nothing
    }
    return null;
  }

  // 差額のプレビュー
  Future<StripeUpcomingInvoice> previewProration({
    required String customerId,
    required String subscriptionId,
    required String itemId,
    required String newPriceId,
    String? couponId,
  }) async {
    final List<Map> items = [
      {
        'id': itemId,
        'price': newPriceId, // Switch to new price
      }
    ];

    final param = {
      'customer': customerId,
      'subscription': subscriptionId,
      'subscription_items': items,
      'subscription_proration_date': '${DateTime.now().millisecondsSinceEpoch ~/ 1000}',
      'subscription_billing_cycle_anchor': 'now',
      'subscription_proration_behavior': 'create_prorations',
    };

    if (couponId != null) {
      param['coupon'] = couponId;
    }

    final result = await _functionsRepository.call(
      functionName: 'stripe-previewProration',
      parameters: param,
    );
    final data = result.data;
    return StripeUpcomingInvoice.json(data);
  }

  /// 与信枠を確認する
  Future<Map<String, dynamic>> _checkIsCardValid(
    int unitAmount,
    String customerId,
  ) async {
    if (unitAmount == 0) {
      // 無料プランへの変更はノーチェックでok
      return {};
    }
    final result = await _functionsRepository.call(
      functionName: 'stripe-checkIsCardValid',
      parameters: {
        'amount': unitAmount,
        'currency': 'jpy',
        'customer': customerId,
        'description': '与信枠の確保',
        'confirm': 'true',
        'capture_method': 'manual',
        'payment_method_types': [
          'card',
          'link',
        ], // これがないとエラーになる
      },
    );
    return result.data;
  }

  /// 決済情報を更新する
  Future<Map<String, dynamic>> _updateSubscription(Map<String, String?> bodyMap) async {
    final result = await _functionsRepository.call(
      functionName: 'stripe-updateSubscription',
      parameters: bodyMap,
    );
    return result.data;
  }

  /// サブスクリプションスケジュールをキャンセル
  Future<Map<String, dynamic>> _updateSubscriptionSchedule({required Map<String, dynamic>? parameters}) async {
    final result = await _functionsRepository.call(
      functionName: 'stripe-updateSubscriptionSchedule',
      parameters: parameters,
    );
    return result.data;
  }

  //////////// Specific Method ////////////

  /// プランを即時変更する
  /// エラーが起きた場合は例外を投げる
  Future changePriceImmediately({
    required String customerId,
    required StripeSubscription subscription,
    required Price price,
    String? couponId,
  }) async {
    // 与信枠の確保
    // クレジットカードがエラーならエラーが帰ってくる
    await _checkIsCardValid(
      price.unitAmount!,
      customerId,
    );

    // 更新対象のsubscriptionItemを取得する
    final subscriptionItems = await _fetchSubscriptionItems(subscription);
    if (subscriptionItems == null) {
      throw ('現状のプラン情報を取得できませんでした');
    }
    final subscriptionItemId = subscriptionItems['data'][0]['id']; // 決済情報は1つしかないので0番目固定

    final Map<String, String?> data = {
      'items[0][id]': subscriptionItemId,
      'items[0][price]': price.id!,
      'billing_cycle_anchor': 'now',
      'proration_behavior': 'create_prorations', // 即時アップデートで日割計算する
    };

    if (couponId != null) {
      data['coupon'] = couponId;
    }

    // 決済情報に紐付くプランを変更する
    await _updateSubscription(data);
  }

  /// プランの変更を予約する
  /// エラーが起きた場合は例外を投げる
  Future reservePrice({
    required String customerId,
    required StripeSubscription currentSubscription,
    required Price newPrice,
    String? couponId,
  }) async {
    // 与信枠の確保
    // クレジットカードがエラーならエラーが帰ってくる
    await _checkIsCardValid(
      newPrice.unitAmount!,
      customerId,
    );
    final schedules = await fetchActiveSubscriptionSchedules(
      customerId: customerId,
    );
    final firstSchedule = schedules.firstOrNull;

    if (firstSchedule != null) {
      // サブスクリプションスケジュールがある場合は更新
      final id = firstSchedule.id;

      final existingPhases = firstSchedule.phases.map((phase) => {
        'start_date': phase.startDate.millisecondsSinceEpoch ~/ 1000,
        'end_date': phase.endDate.millisecondsSinceEpoch ~/ 1000,
        'items': phase.items.map((item) => {
          'price': item.price,
          'quantity': 1,
        }).toList(),
      }).toList();

      final newPhase = {
        'start_date': existingPhases.last['end_date'], // 直前のendをstartに使う
        'proration_behavior': 'none',
        'items': [
          {
            'price': newPrice.id,
            'quantity': 1,
          }
        ],
      };

      final phases = [...existingPhases, newPhase];
      await _updateSubscriptionSchedule(parameters: {
        'id': id,
        'phases': phases,
      });

    } else {
      // 新しいプランのスケジュールを作る
      final startDate = currentSubscription.currentPeriodEnd!.millisecondsSinceEpoch ~/ 1000;
      final Map<String, dynamic> data = {
        'from_subscription': currentSubscription.id,
        'priceId': newPrice.id,
        'proration_behavior': 'none', // 日割り計算無し
        'start_date': '$startDate', // 今のプランの終わり
        'description': '${newPrice.description}',
      };
      if (couponId != null) {
        data['coupon'] = couponId;
      }

      await _functionsRepository.call(
        functionName: 'stripe-createSubscriptionSchedules',
        parameters: data,
      );
    }
  }

  /// プランの変更の予約を解除する
  Future releaseSubscriptionSchedule(String subscriptionScheduleId) async {
    final Map<String, String?> data = {
      'id': subscriptionScheduleId,
    };
    final _ = await _functionsRepository.call(
      functionName: 'stripe-releaseSubscriptionSchedule',
      parameters: data,
    );
  }

  /// エラーが起きた場合は例外を投げる
  Future cancelReservationOldWay(StripeSubscription subscription) async {
    // 更新対象のsubscriptionItemを取得する
    final subscriptionItems = await _fetchSubscriptionItems(subscription);
    if (subscriptionItems == null) {
      throw ('プランの変更の予約を解除できませんでした');
    }
    final subscriptionItemId = subscriptionItems['data'][0]['id']; // 決済情報は1つしかないので0番目固定
    await _updateSubscription({
      'items[0][id]': subscriptionItemId,
      'items[0][price]': subscription.currentPrice.id,
      'metadata': '',
      'proration_behavior': 'none', // 日割り計算無し
      'billing_cycle_anchor': 'unchanged', // 無料プランの予約解除の際、unchangedを指定しないと元のプランの即時決済が走ってしまう
    });
  }

  /// 予約一覧を取得する
  Future<List<StripeSubscriptionSchedule>> fetchReservations({
    required String customerId,
  }) async {
    final activeSubscriptionSchedules = await fetchActiveSubscriptionSchedules(customerId: customerId);

    // 未来に発火予定のスケジュール（つまり予約）だけに絞り込む
    return activeSubscriptionSchedules
        .where((schedule) => schedule.phases.any((phase) => phase.startDate.compareTo(DateTime.now()) > 0))
        .toList();
  }

  Future<List<StripeSubscriptionSchedule>> fetchActiveSubscriptionSchedules({
    required String customerId,
  }) async {
    final Map<String, dynamic> data = {
      'customer': customerId,
    };
    final result = await _functionsRepository.call(
      functionName: 'stripe-fetchSubscriptionSchedules',
      parameters: data,
    );
    final listData = result.data['data'] as List;
    final subscriptionSchedules = listData
        .map((data) => StripeSubscriptionSchedule.json(data))
        .where((schedule) => schedule.status == 'active')
        .toList();
    return subscriptionSchedules;
  }

  /// 退会予約を申込む
  Future withdraw({
    required String customerId,
  }) async {
    final schedules = await fetchActiveSubscriptionSchedules(
      customerId: customerId,
    );
    final scheduleId = schedules.firstOrNull?.id;

    if (scheduleId != null) {
      // サブスクリプションスケジュールを更新
      await _updateSubscriptionSchedule(parameters: {
        'id': scheduleId,
        'end_behavior': 'cancel',
      });
    } else {
      // サブスクリプションを更新
      await _updateSubscription({
        'cancel_at_period_end': 'true',
      });
    }
  }

  /// 退会の申込みをキャンセルする
  /// エラーが起きた場合は例外を投げる
  Future cancelWithdraw({
    required String customerId,
  }) async {
    final schedules = await fetchActiveSubscriptionSchedules(
      customerId: customerId,
    );
    final scheduleId = schedules.firstOrNull?.id;

    if (scheduleId != null) {
      await _updateSubscriptionSchedule(
        parameters: {
          'scheduleId': scheduleId,
          'endBehavior': 'release',
        },
      );
    } else {
      // サブスクリプションを更新
      await _updateSubscription({
        'cancel_at_period_end': 'false',
      });
    }
  }

  Future<String> createStripeAccountAndGetLink() async {
    final baseUrl = URLUtils.getBaseUrl();
    final returnUrl = '$baseUrl/teacher';
    
    try {
      final uid = UserRepository().myUid;
      final email = FirebaseAuth.instance.currentUser?.email;
      final result = await _functionsRepository.call(
        functionName: 'stripe-createStripeConnectedAccountAndLink',
        parameters: {
          'uid': uid,
          'email': email,
          'return_url': returnUrl,
        },
      );
      return result.data; // link
    } on FirebaseFunctionsException catch (_) {
      // todo: ここでエラーをキャッチして、Stripeのエラーを表示する
      rethrow;
    }
  }

  Future<String> createStripeLoginLink(accountId) async {
    try {
      final result = await _functionsRepository.call(
        functionName: 'stripe-createStripeLoginLink',
        parameters: {
          'account_id': accountId,
        },
      );
      return result.data; // link
    } on FirebaseFunctionsException catch (_) {
      // todo: ここでエラーをキャッチして、Stripeのエラーを表示する
      rethrow;
    }
  }

  Future<String> _createCheckoutURL(Map<String, dynamic> data) async {
    try {
      final result = await _functionsRepository.call(
        functionName: 'stripe-createCheckoutURL',
        parameters: data,
      );
      return result.data; // url
    } on FirebaseFunctionsException catch (_) {
      // todo: ここでエラーをキャッチして、Stripeのエラーを表示する
      rethrow;
    }
  }

  Future<String> _createCustomer() async {
    final authUser = FirebaseAuth.instance.currentUser;
    final result = await _functionsRepository.call(
      functionName: 'stripe-createCustomerAndSaveToFirestore',
      parameters: {
        'uid': authUser?.uid,
        'email': authUser?.email,
      },
    );
    return result.data; // customerId
  }

  Future<String> searchPromotionCode(String code) async {
    final result = await _functionsRepository.call(
      functionName: 'stripe-searchPromotionCode',
      parameters: {
        'promotionCode': code,
      },
    );
    return result.data; // couponId
  }
}
