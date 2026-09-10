import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../salon_app_commons.dart';

/// ログイン
class LoginPage extends StatelessWidget {
  static const String route = '/login';

  final _emailController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');

  final String? path;
  final PreferredSizeWidget appBar;
  LoginPage({
    Key? key,
    this.path,
    required this.appBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginModel>(
      create: (_) => LoginModel(),
      builder: (context, child) {
        return Scaffold(
          appBar: appBar,
          body: SingleChildScrollView(
            child: Center(
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32),
                    Text(
                      'Login',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontSize: 42,
                            color: Colors.white,
                            height: 1,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'ログイン',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          hintText: "メールアドレス",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                        ),
                        autofillHints: const [AutofillHints.username],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 300,
                      child: Consumer<LoginModel>(builder: (context, model, child) {
                        return TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: "パスワード",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                          ),
                          onFieldSubmitted: (text) async {
                            await onLoginTapped(context, model);
                          },
                          autofillHints: const [AutofillHints.password],
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    Consumer<LoginModel>(builder: (context, model, child) {
                      return RoundedMoveButton(
                        isMobile: true,
                        title: 'ログイン',
                        isLoading: model.isLoading,
                        onTap: () async {
                          await onLoginTapped(context, model);
                        },
                      );
                    }),
                    const SizedBox(
                      height: 16,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        context.push(ResetPasswordPage.route);
                      },
                      child: const Text(
                        "パスワードを忘れた方はこちら",
                        style: MultiLineStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Column(
                      children: [
                        const SizedBox(
                          width: 300,
                          child: Divider(
                            color: Colors.white,
                            thickness: 2,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Consumer<LoginModel>(builder: (context, model, child) {
                          return RoundedMoveButton(
                            isMobile: true,
                            isLoading: model.isLoadingForGithub,
                            title: 'GitHubログイン',
                            textColor: githubBlackColor,
                            iconData: FontAwesome5.github,
                            onTap: () async {
                              model.startLoadingForGithub();

                              try {
                                await model.loginWithGitHub();
                                await goNextPage(context);
                              } catch (e) {
                                await showErrorDialogAndInquiryChat(
                                  context,
                                  e,
                                );
                              } finally {
                                model.endLoadingForGithub();
                              }
                            },
                          );
                        }),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        // pushするとwebで新規登録の画面遷移がうまく動かないのでgoしてる
                        context.go(SignUpPage.route);
                      },
                      child: const Text(
                        "新規登録はこちらから",
                        style: MultiLineStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future onLoginTapped(BuildContext context, LoginModel model) async {
    model.startLoading();

    try {
      await model.login(
        _emailController.text,
        _passwordController.text,
      );
      await goNextPage(context);
    } catch (e) {
      showTextDialog(context, e.toString());
    } finally {
      model.endLoading();
    }
  }

  Future goNextPage(BuildContext context) async {
    if (path != null) {
      context.go(path!);
    } else {
      context.go(WaitingPage.route);
    }
  }
}
