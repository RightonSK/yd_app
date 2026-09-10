import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

import 'github_update_model.dart';

class GithubUpdatePage extends StatelessWidget {
  static const String route = '/github_update';

  final PreferredSizeWidget appBar;
  const GithubUpdatePage({
    Key? key,
    required this.appBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GithubUpdateModel>(
        create: (_) => GithubUpdateModel()..init(),
        builder: (context, child) {
          return Scaffold(
            appBar: appBar,
            body: Consumer<GithubUpdateModel>(builder: (context, model, child) {
              final githubId = model.user?.githubId;
              final githubUsername = model.user?.githubUsername;

              return SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 16),
                      Text(
                        'githubId: $githubId',
                        style: const MultiLineStyle(color: Colors.white),
                      ),
                      Text(
                        'username: $githubUsername',
                        style: const MultiLineStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      RoundedMoveButton(
                        isMobile: true,
                        isLoading: model.isLoading,
                        title: 'GitHub認証する',
                        textColor: githubBlackColor,
                        iconData: FontAwesome5.github,
                        onTap: () async {
                          if (githubId != null) {
                            final isYes = await showConfirmDialog(
                              context,
                              'すでにGitHub認証済みです。連携し直しますか？',
                            );

                            if (!isYes) {
                              // 終了
                              return;
                            }
                            model.startLoading();
                            await model.unlinkGithub();
                          } else {
                            model.startLoading();
                          }

                          try {
                            await model
                                .loginWithGithubAndUpdateGithubUsername();
                            await showTextDialog(context, 'GitHub認証しました。');
                            await model.init();
                          } catch (e) {
                            showTextDialog(context, e.toString());
                          } finally {
                            model.endLoading();
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              );
            }),
          );
        });
  }
}
