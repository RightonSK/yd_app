import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class MyEmailUpdatePage extends StatelessWidget {
  MyEmailUpdatePage({
    super.key,
    this.userEmail,
    required this.appBar,
  });

  final PreferredSizeWidget appBar;
  final String? userEmail;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    emailController.text = userEmail ?? '';
    return ChangeNotifierProvider<MyEmailUpdateModel>(
        create: (_) => MyEmailUpdateModel()..init(userEmail),
        child: Consumer<MyEmailUpdateModel>(builder: (context, model, child) {
          return Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: appBar,
            body: Stack(children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 500,
                  ),
                  child: SingleChildScrollView(
                      child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text('新しいメールアドレス'),
                        TextField(
                          autofocus: true,
                          controller: emailController,
                          onChanged: (text) {
                            model.userEmail = text;
                          },
                        ),
                        const SizedBox(height: 16),
                        model.isNeedPassword
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                    const Text('パスワード'),
                                    TextField(
                                      focusNode: focus,
                                      obscureText: true,
                                      controller: passwordController,
                                      onChanged: (text) {
                                        model.password = text;
                                      },
                                    ),
                                  ])
                            : const SizedBox(),
                        Center(
                          child: RoundedActionButton(
                            width: double.infinity,
                            backgroundColor: primaryNavyColor,
                            textColor: Colors.white,
                            isMobile: false,
                            title: 'メールアドレスを変更する',
                            onTap: () async {
                              model.startLoading();
                              try {
                                await model.update();
                                await _showTextDialog(
                                    model, context, 'メールアドレスを変更しました');
                                Navigator.of(context).pop();
                              } catch (e) {
                                _showTextDialog(model, context, e.toString());
                                if (model.isNeedPassword) {
                                  FocusScope.of(context).requestFocus(focus);
                                }
                              } finally {
                                model.endLoading();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  )),
                ),
              ),
              model.isLoading
                  ? Container(
                      color: Colors.black.withOpacity(0.3),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : const SizedBox()
            ]),
          );
        }));
  }
}

_showTextDialog(model, context, message) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
