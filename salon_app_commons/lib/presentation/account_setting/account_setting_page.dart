import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

import 'account_setting_model.dart';

class AccountSettingPage extends StatelessWidget {
  static const String route = '/account_setting';

  const AccountSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AccountSettingModel>(
      create: (_) => AccountSettingModel()..init(),
      builder: (context, child) {
        return Scaffold(
          body: Consumer<AccountSettingModel>(
            builder: (context, model, child) {
              // Show loading indicator while fetching data
              if (model.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final user = model.user;
              final subscription = model.subscription;
              final reservations = model.reservations;

              // Show empty scaffold if data is not available
              if (user == null || subscription == null) {
                return const Scaffold(
                  body: Center(
                    child: Text('アカウント情報が読み込めませんでした'),
                  ),
                );
              }

              final currentPlanName = subscription.planType.displayName;
              return SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Card(
                        child: Container(
                          constraints: const BoxConstraints(
                            maxWidth: 400,
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              IntrinsicWidth(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.email_outlined,
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          FirebaseAuth.instance.currentUser
                                                  ?.email ??
                                              '未設定',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(3),
                                          child: Image.asset(
                                            'resources/slack.png',
                                            width: 19,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          user.slackEmail ?? '未設定',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(3),
                                          child: Image.asset(
                                            'resources/github.png',
                                            width: 19,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        InkWell(
                                          onTap: user.githubUsername != null
                                              ? () async {
                                                  final url =
                                                      'https://github.com/${user.githubUsername ?? ''}';
                                                  URLUtils.launch(
                                                      urlString: url);
                                                }
                                              : null,
                                          child: Text(
                                            user.githubUsername ?? '未設定',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.computer,
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MyPlanDetailPage(
                                                  appBar: const LogoAppBar(
                                                    isLogin: true,
                                                    isUnderRegister: false,
                                                  ),
                                                  subscription: subscription,
                                                  reservations: reservations,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            currentPlanName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      RoundedMoveButton(
                        isMobile: true,
                        isLoading: model.isLoadingForGithub,
                        title: 'GitHub連携',
                        textColor: githubBlackColor,
                        iconData: FontAwesome5.github,
                        onTap: () async {
                          // 画面遷移
                          context.push(GithubUpdatePage.route);
                        },
                      ),
                      const SizedBox(height: 16),
                      RoundedMoveButton(
                        isMobile: true,
                        iconData: Icons.email,
                        title: 'メールアドレス変更',
                        onTap: () async {
                          // アプリのを使いまわしているので、Navigator1.0
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyEmailUpdatePage(
                                appBar: const LogoAppBar(
                                  isLogin: true,
                                  isUnderRegister: false,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      RoundedMoveButton(
                        isMobile: true,
                        iconData: Icons.password,
                        title: 'パスワード変更',
                        onTap: () async {
                          // アプリのを使いまわしているので、Navigator1.0
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyPasswordUpdatePage(
                                appBar: const LogoAppBar(
                                  isLogin: true,
                                  isUnderRegister: false,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      RoundedMoveButton(
                        isMobile: true,
                        iconData: Icons.next_plan,
                        title: 'プラン変更',
                        onTap: () async {
                          // WEBのみにある
                          context.push('/changePlan');
                        },
                      ),
                      const SizedBox(height: 16),
                      RoundedMoveButton(
                        isMobile: true,
                        iconData: Icons.credit_card,
                        isLoading: model.isLoadingForChangePaymentMethod,
                        title: '支払い方法変更',
                        onTap: () async {
                          try {
                            await model.redirectToCustomerPortal();
                          } catch (e) {
                            showErrorDialogAndInquiryChat(context, e);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      RoundedMoveButton(
                        isMobile: true,
                        iconData: Icons.card_giftcard_outlined,
                        title: 'メンバー優待',
                        onTap: () async {
                          context.push(RewardsPage.route);
                        },
                      ),
                      const SizedBox(height: 16),
                      RoundedMoveButton(
                        isMobile: true,
                        iconData: Icons.rocket_launch,
                        title: '退会',
                        onTap: () async {
                          context.push(WithdrawPage.route);
                        },
                      ),
                      const SizedBox(
                        height: 80,
                      ), // お問い合わせボタンとかぶるので下の幅は広めにとる
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
