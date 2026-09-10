import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

import '../../repository/functions_repository.dart';

/// ログイン
class GithubInputPage extends StatelessWidget {
  static const String route = '/github_input';

  final String? planName;
  final PreferredSizeWidget appBar;
  const GithubInputPage(
    this.planName, {
    Key? key,
    required this.appBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GithubInputModel>(
        create: (_) => GithubInputModel(),
        builder: (context, child) {
          return Scaffold(
            appBar: appBar,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 8),
                  const NewUserInputIndicator(3),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '招待メールを開いてGitHub Organizationに登録後、GitHub認証してください。',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Consumer<GithubInputModel>(
                        builder: (context, model, child) {
                      return SizedBox(
                        width: 300,
                        child: RoundedMoveButton(
                          isMobile: true,
                          isLoading: model.isLoading,
                          title: 'GitHub連携の確認',
                          textColor: githubBlackColor,
                          iconData: FontAwesome5.github,
                          onTap: () async {
                            model.startLoading();

                            try {
                              await model
                                  .loginWithGithubAndUpdateGithubUsername();

                              // TwitterShareに遷移
                              String route = TwitterSharePage.route;
                              if (planName != null) {
                                route += '?plan=$planName';
                              }
                              context.go(route);

                              await AnalyticsUtils.sendLog(
                                  AnalyticsEvent.btnRegisterGitHub);
                            } catch (e) {
                              final errorMessage = e.toString();

                              if (errorMessage ==
                                  GitHubError.unavailable.message) {
                                // オーガニゼーションに入ってないだけなので、エラーダイアログだけを表示
                                await showTextDialog(context, errorMessage);
                              } else {
                                await showTextDialog(context,
                                    '$errorMessage\n次のページで再度Githubアカウント名の入力をお試しください');

                                // FirebaseAuthでの認証が機能しなかったので、テキスト入力のページに飛ばす
                                context.go(GithubInputRecoverPage.route);
                              }
                            } finally {
                              model.endLoading();
                            }
                          },
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        });
  }
}
