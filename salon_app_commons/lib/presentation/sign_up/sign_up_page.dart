import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

/// 入会登録
class SignUpPage extends StatelessWidget {
  static const String route = '/signUp';

  final _emailController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');

  final String? inviteId;
  final PreferredSizeWidget appBar;
  final void Function(BuildContext context) onTapLogin;

  SignUpPage({
    Key? key,
    required this.inviteId,
    required this.appBar,
    required this.onTapLogin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignUpModel>(
      create: (_) => SignUpModel(),
      builder: (context, child) {
        return Scaffold(
          appBar: appBar,
          body: Consumer<SignUpModel>(
            builder: (context, model, child) {
              return SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AutofillGroup(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 32),
                          Text(
                            'SignUp',
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontSize: 42,
                                  color: Colors.white,
                                  height: 1,
                                ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            '新規登録',
                            style: MultiLineStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'まずはアカウント登録をお願いいたします',
                            style: MultiLineStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: 300,
                            child: TextField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                hintText: 'メールアドレス',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(),
                              ),
                              autofillHints: const [AutofillHints.username],
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            width: 300,
                            child: TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: 'パスワード(6文字以上)',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(),
                              ),
                              autofillHints: const [AutofillHints.password],
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          termAndPolicyText(context),
                          const SizedBox(
                            height: 16,
                          ),
                          RoundedMoveButton(
                            isMobile: true,
                            title: '登録する',
                            isLoading: model.isLoading,
                            onTap: () async {
                              model.startLoading();
                              try {
                                await model.signUp(
                                  _emailController.text,
                                  _passwordController.text,
                                  inviteId,
                                );
                                await model.sendVerification();

                                context.go(SentVerificationPage.route);

                                await AnalyticsUtils.sendLog(AnalyticsEvent.btnRegister);
                              } catch (e) {
                                showTextDialog(context, e.toString());
                              } finally {
                                model.endLoading();
                              }
                            },
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              onTapLogin(context);
                            },
                            child: const Text(
                              "すでに会員の方はこちらからログイン",
                              style: MultiLineStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget termAndPolicyText(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: Colors.white,
              fontSize: 14,
            ),
        children: [
          TextSpan(
            text: '利用規約',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: primaryYellowColor,
                  decoration: TextDecoration.underline,
                  decorationColor: primaryYellowColor,
                  fontSize: 14,
                ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                context.push(TermPage.route);
              },
          ),
          const TextSpan(text: '、'),
          TextSpan(
            text: 'プライバシーポリシー',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: primaryYellowColor,
                  decorationColor: primaryYellowColor,
                  decoration: TextDecoration.underline,
                  fontSize: 14,
                ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                context.push(PrivacyPolicyPage.route);
              },
          ),
          const TextSpan(text: 'に同意の上ご利用ください'),
        ],
      ),
    );
  }
}
