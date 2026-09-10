import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

/// ログイン
class SlackInputPage extends StatelessWidget {
  static const String route = '/slack_input';

  final _emailController = TextEditingController(text: '');

  final String? planName;
  final PreferredSizeWidget appBar;

  SlackInputPage(this.planName, {Key? key, required this.appBar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SlackInputModel>(
        create: (_) => SlackInputModel(),
        builder: (context, child) {
          return Scaffold(
            appBar: appBar,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 8),
                  const NewUserInputIndicator(2),
                  const SizedBox(height: 16),
                  Text(
                    'Slackの招待メールを開いてSlackに入会後、\nこちらにメールアドレスを入力してください。',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '※迷惑メール等に分類されている場合があるので「すべてのメール」をご確認ください。',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        hintText: 'SlackアカウントのEmailアドレス',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Consumer<SlackInputModel>(
                        builder: (context, model, child) {
                      return RoundedMoveButton(
                        isMobile: true,
                        isLoading: model.isLoading,
                        title: '確認する',
                        onTap: () async {
                          model.startLoading();

                          try {
                            await model.updateEmail(_emailController.text);
                            await model.reloadUserState();

                            // GitHub確認へ遷移
                            // GitHubIdが登録されている場合も、organization登録をチェックさせたい
                            String route = GithubInputPage.route;
                            if (planName != null) {
                              route += '?plan=$planName';
                            }
                            context.go(route);

                            await AnalyticsUtils.sendLog(
                                AnalyticsEvent.btnRegisterSlack);
                          } catch (e) {
                            showTextDialog(context, e.toString());
                          } finally {
                            model.endLoading();
                          }
                        },
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
