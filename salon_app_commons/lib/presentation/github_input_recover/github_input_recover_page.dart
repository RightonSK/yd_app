import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

/// ログイン
class GithubInputRecoverPage extends StatelessWidget {
  static const String route = '/github_input_recover';

  final _githubNameController = TextEditingController(text: '');

  final String? planName;
  final PreferredSizeWidget appBar;
  GithubInputRecoverPage(this.planName, {Key? key, required this.appBar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GithubInputRecoverModel>(
        create: (_) => GithubInputRecoverModel(),
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
                  Text(
                    'GitHub招待メールを開き\nGitHub Organizationに登録後、\nこちらにGitHub Usernameを入力してください。',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _githubNameController,
                      decoration: const InputDecoration(
                        hintText: "GitHub Username",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Consumer<GithubInputRecoverModel>(
                        builder: (context, model, child) {
                      return SizedBox(
                        width: 300,
                        child: RoundedMoveButton(
                          isMobile: true,
                          isLoading: model.isLoading,
                          title: '確認する',
                          onTap: () async {
                            model.startLoading();

                            try {
                              await model
                                  .updateGithubName(_githubNameController.text);

                              // TwitterShareに遷移
                              if (planName != null) {
                                context.go(
                                  '${TwitterSharePage.route}?plan=$planName',
                                );
                              } else {
                                context.go(TwitterSharePage.route);
                              }
                              await AnalyticsUtils.sendLog(
                                  AnalyticsEvent.btnRegisterGitHub);
                            } catch (e) {
                              showTextDialog(context, e.toString());
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
