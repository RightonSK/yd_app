import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

import 'mentor_plan_upserting_model.dart';

class MentorPlanUpsertingPage extends StatelessWidget {
  static const String route = '/mentor_plan_upserting';
  final PreferredSizeWidget appBar;
  final String? planId;

  const MentorPlanUpsertingPage({
    Key? key,
    required this.appBar,
    this.planId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MentorPlanUpsertingModel>(
        create: (context) => MentorPlanUpsertingModel(planId),
        builder: (context, child) {
          return Scaffold(
            appBar: appBar,
            body: Consumer<MentorPlanUpsertingModel>(
                builder: (context, model, child) {
              return Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: Column(
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 560),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SafeArea(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'プランタイトル',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 10),
                                      CommonTextFormField(
                                        controller: model.planTitleController,
                                        hintText: '30分質問プラン',
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        '料金',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      CommonTextFormField(
                                        controller: model.priceController,
                                        hintText: '1000',
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          const Text('FUTでの購入可否'),
                                          Checkbox(
                                            value: model.isChecked,
                                            onChanged: (bool? value) {
                                              model.setIsChecked(value!);
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        'FUT',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      if (model.isChecked)
                                        CommonTextFormField(
                                          enabled: model.isChecked,
                                          controller: model.futAmountController,
                                          hintText: '0',
                                        ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          const Text('単発'),
                                          Checkbox(
                                            value: true,
                                            onChanged: (bool? value) {
                                              // 何もしない// Call the correct method with the value
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        'プラン内容',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      CommonTextFormField(
                                        controller:
                                            model.planDescriptionController,
                                        hintText: 'わかりやすいように簡潔に書いてください',
                                        lines: 7,
                                        maxLength: 1000,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: planId == null
                              ? RoundedMoveButton(
                                  isMobile: true,
                                  isLoading: model.isLoading,
                                  title: 'プランを作成する',
                                  onTap: () async {
                                    try {
                                      model.startLoading();
                                      await model.addMentorPlan();
                                      await showTextDialog(
                                        context,
                                        'プランを作成しました!',
                                      );
                                      // 前のページに戻る
                                      context.pop();
                                    } catch (e) {
                                      showTextDialog(context, e.toString());
                                    } finally {
                                      model.endLoading();
                                    }
                                  },
                                )
                              : RoundedMoveButton(
                                  isMobile: true,
                                  isLoading: model.isLoading,
                                  title: 'プランを更新する',
                                  onTap: () async {
                                    try {
                                      model.startLoading();
                                      // planId is already checked whether null or not.
                                      await model.updateMentorPlan(planId!);
                                      await showTextDialog(
                                        context,
                                        'プランを更新しました!',
                                      );
                                      context.pop();
                                    } catch (e) {
                                      showTextDialog(context, e.toString());
                                    } finally {
                                      model.endLoading();
                                    }
                                  },
                                ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        });
  }
}
