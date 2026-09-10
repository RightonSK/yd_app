import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

import 'web_top_menu.dart';
import 'web_top_model.dart';

class WebTopPage extends StatelessWidget {
  const WebTopPage({
    super.key,
    required this.route,
  });

  final String route;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WebTopModel>(
        create: (_) => WebTopModel()..init(route),
        builder: (context, child) {
          return Scaffold(
            appBar: LogoAppBar(
              isUnderRegister: false,
              isLogin: true,
              onTapHamburgerMenu: () {
                final model = context.read<WebTopModel>();
                model.toggleNavigationRail();
              },
            ),
            body: Consumer<WebTopModel>(builder: (context, model, child) {
              return Row(
                children: [
                  ResponsiveBuilder(builder: (context, sizingInformation) {
                    final isMobileSize = checkIsMobile(sizingInformation);
                    model.setIsMobile(isMobileSize);
                    return NavigationRail(
                      elevation: 1,
                      extended: model.isNavigationRailOpen,
                      minWidth: 48,
                      minExtendedWidth: 152,
                      labelType: NavigationRailLabelType.none,
                      unselectedIconTheme: const IconThemeData(
                        color: Colors.black54,
                      ),
                      selectedIconTheme: const IconThemeData(
                        color: themeNavy,
                      ),
                      unselectedLabelTextStyle: const TextStyle(
                        color: Colors.black54,
                      ),
                      selectedLabelTextStyle: const TextStyle(
                        color: themeNavy,
                        fontWeight: FontWeight.bold,
                      ),
                      selectedIndex: model.selectedIndex == -1 ? null : model.selectedIndex,
                      groupAlignment: -1.0,
                      onDestinationSelected: (int index) {
                        logger.d(index);
                        model.setIndex(index);
                      },
                      destinations: WebTopMenu.valuesForMenu(model.isNew)
                          .map(
                            (e) => NavigationRailDestination(
                              icon: Tooltip(
                                message: e.label,
                                child: Icon(
                                  e.icon,
                                  size: 16,
                                ),
                              ),
                              selectedIcon: Tooltip(
                                message: e.label,
                                child: Icon(
                                  e.selectedIcon,
                                  size: 16,
                                ),
                              ),
                              label: SizedBox(
                                width: 100,
                                child: Text(e.label,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    )),
                              ),
                              padding: const EdgeInsets.all(2),
                            ),
                          )
                          .toList(),
                    );
                  }),
                  Expanded(
                    child: Consumer<WebTopModel>(
                      builder: (context, model, child) {
                        final subscription = model.subscription;
                        if (subscription == null) {
                          return const LoadingPage();
                        }

                        if (subscription.isErrorStatus) {
                          return const PaymentErrorPage();
                        }
                        return Column(
                          children: [
                            if (model.shouldShowQuestionnaire)
                              InkWell(
                                onTap: () async {
                                  context.go(QuestionnairePage.route);
                                },
                                child: Container(
                                  height: 40,
                                  color: primaryYellowColor,
                                  child: const Center(
                                    child: Text(
                                      '新入会の方へアンケートをお願いしております。「こちら」をタップしてください。',
                                      style: MultiLineStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              )
                            else if (model.shouldShowGithubSetupIsNotEnough)
                              InkWell(
                                onTap: () async {
                                  context.go(WaitingPage.route);
                                },
                                child: Container(
                                  height: 40,
                                  color: githubBlackColor,
                                  child: const Center(
                                    child: Text(
                                      'Github連携が完了していません。「こちら」をタップしてください',
                                      style: MultiLineStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              )
                            else if (model.shouldShowSetupIsNotEnough)
                              InkWell(
                                onTap: () async {
                                  context.go(WaitingPage.route);
                                },
                                child: Container(
                                  height: 40,
                                  color: Colors.redAccent,
                                  child: const Center(
                                    child: Text(
                                      '入会時のセットアップが完了していません。「こちら」をタップしてください',
                                      style: MultiLineStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              )
                            else if (model.shouldUpdateJobSeekingStatus)
                              InkWell(
                                onTap: () async {
                                  // 求職状況のアンケートダイアログを表示
                                  await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return JobSeekingStatusDialog(
                                        model: model,
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  height: 40,
                                  color: Colors.green,
                                  child: const Center(
                                    child: Text(
                                      '最近の求職状況が更新されていません。「こちら」をタップしてください',
                                      style: MultiLineStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            Expanded(
                              child: _buildPageContent(context, model),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
          );
        });
  }

  Widget _buildPageContent(BuildContext context, WebTopModel model) {
    logger.d(model.selectedIndex);

    // If selectedIndex is -1, route is not in sidebar menu
    if (model.selectedIndex == -1) {
      // Handle header menu pages that are not in sidebar
      switch (route) {
        case MyPage.route:
          final uid = UserRepository().myUid;
          if (uid == null) {
            return const NotFoundPage();
          }
          return MemberDetailPage(
            userId: uid,
            tabName: 'profile',
            onTapLinkToMap: (prefecture) async {
              await showTextDialog(context, 'モバイルアプリだとMapを見ることができます');
            },
          );
        case AccountSettingPage.route:
          return const AccountSettingPage();
        case QuestionChatListPage.route:
          return const QuestionChatListPage();
        case SchedulePage.route:
          return const SchedulePage();
        case MentorPlanListPage.route:
          return const MentorPlanListPage();
        case TeacherPage.route:
          return const TeacherPage();
        default:
          return const NotFoundPage();
      }
    }

    // Normal sidebar menu pages
    return WebTopMenu.valuesForMenu(model.isNew)[model.selectedIndex].page();
  }
}

class JobSeekingStatusDialog extends StatelessWidget {
  const JobSeekingStatusDialog({
    super.key,
    required this.model,
  });

  final WebTopModel model;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        '最近の求職状況を教えてください',
        style: BoldMultiLineStyle(),
      ),
      content: DefaultTextStyle.merge(
        style: const MultiLineStyle(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<JobSeekingStatus>(
                isExpanded: true,
                hint: const Text('選択してください'),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: JobSeekingStatus.values
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e.label,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (JobSeekingStatus? value) {
                  model.setJobSeekingStatus(value);
                },
                value: model.newJobSeekingStatus,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('キャンセル'),
        ),
        TextButton(
          onPressed: () async {
            await model.updateJobSeekingStatus();
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
