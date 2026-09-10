import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/utils/dialog_utils.dart';
import 'package:salon_app_commons/widget/rounded_move_button.dart';

import 'reset_password_model.dart';

class ResetPasswordPage extends StatelessWidget {
  static const String route = '/reset_password';

  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mailController = TextEditingController();

    return ChangeNotifierProvider<ResetPasswordModel>(
      create: (_) => ResetPasswordModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('パスワードを忘れた方はこちら'),
        ),
        body: Consumer<ResetPasswordModel>(builder: (context, model, child) {
          return SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 32,
                  ),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'example@gmail.com',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                      ),
                      controller: mailController,
                      onChanged: (text) {
                        model.mail = text.trim();
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  RoundedMoveButton(
                    isMobile: true,
                    title: '再設定する',
                    isLoading: model.isLoading,
                    onTap: () async {
                      model.startLoading();
                      try {
                        await model.resetPassword();
                        await showTextDialog(context, '再設定メールを送信しました!');
                      } catch (e) {
                        showTextDialog(context, e.toString());
                      } finally {
                        model.endLoading();
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
