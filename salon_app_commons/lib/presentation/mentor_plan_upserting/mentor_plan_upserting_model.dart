import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class MentorPlanUpsertingModel extends ChangeNotifier {
  final String? planId;
  final planTitleController = TextEditingController();
  final priceController = TextEditingController();
  final futAmountController = TextEditingController();
  final planDescriptionController = TextEditingController();
  MentorPlan? mentorPlan;
  bool isChecked = false;

  MentorPlanUpsertingModel(this.planId) {
    initialize();
  }

  Future<void> initialize() async {
    await fetchMentorPlan();

    // Basically these mentor plan's fields below won't be empty or null.
    if (planTitleController.text.isEmpty) {
      planTitleController.text = mentorPlan!.title;
    }
    if (planDescriptionController.text.isEmpty) {
      planDescriptionController.text = mentorPlan!.description;
    }
    if (priceController.text.isEmpty) {
      priceController.text = mentorPlan!.price.toString();
    }
    if (futAmountController.text.isEmpty) {
      futAmountController.text = mentorPlan!.futAmount.toString();
    }
  }

  Future<void> fetchMentorPlan() async {
    final userId = UserRepository().myUid;
    if (planId == null) {
      return;
    }

    mentorPlan = await MentorPlanRepository().fetchPlan(userId, planId);
  }

  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> addMentorPlan() async {
    final title = planTitleController.text;
    final description = planDescriptionController.text;
    final price = int.tryParse(priceController.text);
    final futAmount = int.tryParse(futAmountController.text);

    if (title.isEmpty) {
      throw 'タイトルを入力してください';
    }

    if (description.isEmpty) {
      throw 'プラン内容を入力してください';
    }

    if (price == null) {
      throw '金額を正しく入力してください';
    }

    if (price < 100) {
      throw '金額は100円以上にしてください';
    }

    if (isChecked && futAmount == null) {
      throw 'FUTを正しく入力してください';
    }
    await UserRepository().addMentorPlan(title, description, price, futAmount);
  }

  Future<void> updateMentorPlan(String planId) async {
    final title = planTitleController.text;
    final description = planDescriptionController.text;
    final price = int.tryParse(priceController.text);
    final futAmount = int.tryParse(futAmountController.text);

    if (title.isEmpty) {
      throw 'タイトルを入力してください';
    }

    if (description.isEmpty) {
      throw 'プラン内容を入力してください';
    }

    if (price == null) {
      throw '金額を正しく入力してください';
    }

    if (price < 100) {
      throw '金額は100円以上にしてください';
    }

    if (isChecked && futAmount == null) {
      throw 'FUTを正しく入力してください';
    }

    await UserRepository()
        .updateMentorPlan(planId, title, description, price, futAmount);
  }

  void setIsChecked(bool value) {
    isChecked = value;
    notifyListeners();
  }
}
