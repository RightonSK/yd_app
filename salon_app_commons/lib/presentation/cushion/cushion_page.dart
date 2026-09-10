import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class CushionPage<T extends CushionModel> extends StatelessWidget {
  const CushionPage({
    Key? key,
    required this.appBar,
    required this.cushionModel,
    this.backgroundColor = primaryNavyColor,
    this.onTapChangePlanOnQuestionZoom,
    this.onTapReserveButtonOnQuestionZoom,
  }) : super(key: key);
  final PreferredSizeWidget appBar;
  final T cushionModel;
  final Color backgroundColor;
  final void Function(BuildContext context)? onTapChangePlanOnQuestionZoom;
  final void Function(BuildContext context)? onTapReserveButtonOnQuestionZoom;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (_) => cushionModel..init(context),
      builder: (context, child) {
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: appBar,
          body: Consumer<T>(builder: (context, model, child) {
            if (model.isLoading) {
              return LoadingPage(backgroundColor: backgroundColor);
            } else if (model.isPaidError) {
              return const PaymentErrorPage();
            } else {
              final imageURL = model.event?.imageURL;
              final hasRight =
                  model.isTrainingPlan || model.isLightTrainingPlan;
              final isReserved = model.isReserved;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FittedBox(
                          child: SizedBox(
                            width: 600,
                            height: 300,
                            child: imageURL != null
                                ? Image.network(
                                    imageURL,
                                    fit: BoxFit.contain,
                                  )
                                : FlutterUnivLoadingIndicator(
                                    backgroundColor: backgroundColor,
                                  ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        // 質問zoomの場合
                        if (onTapChangePlanOnQuestionZoom != null)
                          Column(
                            children: [
                              if (hasRight && isReserved)
                                RoundedMoveButton(
                                  isLoading: model.isButtonLoading,
                                  isMobile: true,
                                  title: '入室する',
                                  onTap: model.isMeetingTime
                                      ? () async {
                                          model.startButtonLoading();

                                          try {
                                            await model.pushToZoomPage();
                                          } catch (e) {
                                            showTextDialog(
                                                context, e.toString());
                                          } finally {
                                            model.endButtonLoading();
                                          }
                                        }
                                      : null,
                                )
                              else if (hasRight &&
                                  onTapReserveButtonOnQuestionZoom != null)
                                PleaseReserveZoomWidget(
                                    onTapReserve:
                                        onTapReserveButtonOnQuestionZoom!)
                              else
                                YouCantJoinThisZoomWidget(
                                  onTapChangePlan:
                                      onTapChangePlanOnQuestionZoom!,
                                ),
                            ],
                          ),
                        // 質問zoom以外の場合
                        if (onTapChangePlanOnQuestionZoom == null)
                          RoundedMoveButton(
                            isLoading: model.isButtonLoading,
                            isMobile: true,
                            title: '入室する',
                            onTap: model.isMeetingTime
                                ? () async {
                                    model.startButtonLoading();
                                    await model.pushToZoomPage();
                                    model.endButtonLoading();
                                  }
                                : null,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }),
        );
      },
    );
  }
}

class YouCantJoinThisZoomWidget extends StatelessWidget {
  const YouCantJoinThisZoomWidget({
    Key? key,
    required this.onTapChangePlan,
  }) : super(key: key);

  final void Function(BuildContext context) onTapChangePlan;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'あなたは参加できません',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: primaryYellowColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          'Flutter修行プランの方のみが質問zoomに参加できます',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
              ),
        ),
        const SizedBox(
          height: 16,
        ),
        RoundedMoveButton(
          isMobile: true,
          title: 'プラン変更はこちら',
          onTap: () {
            onTapChangePlan(context);
          },
        ),
      ],
    );
  }
}

class PleaseReserveZoomWidget extends StatelessWidget {
  const PleaseReserveZoomWidget({
    Key? key,
    required this.onTapReserve,
  }) : super(key: key);

  final void Function(BuildContext context) onTapReserve;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '予約が必要です',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: primaryYellowColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          '予約ページから希望の時間の30分前までに予約をしてください。',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
              ),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          '■注意事項\n・質問回答が終了したらその日のセッションは終了します。\n・予約が0の場合は実施されません。\n・最大1時間延長することはありますが、1人に対する対応時間は最大30分です。',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
              ),
        ),
        const SizedBox(
          height: 16,
        ),
        RoundedMoveButton(
          isMobile: true,
          title: '予約はこちら',
          onTap: () {
            onTapReserve(context);
          },
        ),
      ],
    );
  }
}
