import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class AccountSettingModel extends ChangeNotifier {
  bool isLoadingForGithub = false;
  bool isLoadingForChangePaymentMethod = false;
  bool isLoading = false;

  // Data properties
  User? user;
  AbstractSubscription? subscription;
  List<StripeSubscriptionSchedule> reservations = [];

  final _userRepo = UserRepository();
  final _stripeRepo = StripeRepository();

  void startLoadingForGithub() {
    isLoadingForGithub = true;
    notifyListeners();
  }

  void endLoadingForGithub() {
    isLoadingForGithub = false;
    notifyListeners();
  }

  /// Initialize the model by fetching all required data
  Future<void> init() async {
    isLoading = true;
    notifyListeners();

    try {
      await _fetchUserData();
    } catch (e) {
      logger.e('Failed to fetch user data: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch user data, subscription, and reservations
  Future<void> _fetchUserData() async {
    // Fetch user data
    user = await _userRepo.fetchMyUser();

    if (user != null) {
      // Fetch subscription data
      subscription = await _userRepo.fetchSubscriptionFlesh();

      // Fetch reservations if user has stripeId
      if (user!.stripeId != null) {
        reservations = await _stripeRepo.fetchReservations(
          customerId: user!.stripeId!,
        );
      }
    }
  }

  Future redirectToCustomerPortal() async {
    isLoadingForChangePaymentMethod = true;
    notifyListeners();

    try {
      final url = URLUtils.getBaseUrl() + AccountSettingPage.route;
      await StripeRepository().redirectToCustomerPortal(url);
    } catch (e) {
      rethrow;
    } finally {
      isLoadingForChangePaymentMethod = false;
      notifyListeners();
    }
  }
}
