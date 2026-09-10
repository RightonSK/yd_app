import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class MyPasswordUpdatePage extends StatelessWidget {
  final PreferredSizeWidget appBar;

  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController newPasswordConfirmController =
      TextEditingController();
  final focus = FocusNode();

  MyPasswordUpdatePage({
    Key? key,
    required this.appBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyPasswordUpdateModel>(
      create: (context) => MyPasswordUpdateModel(),
      child: Consumer<MyPasswordUpdateModel>(
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: appBar,
            body: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 500,
                    ),
                    child: SingleChildScrollView(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextField(
                            obscureText: true,
                            controller: currentPasswordController,
                            autofocus: true,
                            onChanged: (text) {
                              model.currentPassword = text;
                            },
                            decoration: const InputDecoration(
                              labelText: "現在のパスワード",
                            ),
                          ),
                          TextField(
                            obscureText: true,
                            controller: newPasswordController,
                            onChanged: (text) {
                              model.newPassword = text;
                            },
                            decoration: const InputDecoration(
                                labelText: "新しいパスワード", hintText: "6文字以上"),
                          ),
                          TextField(
                            obscureText: true,
                            controller: newPasswordConfirmController,
                            onChanged: (text) {
                              model.newPasswordConfirm = text;
                            },
                            decoration: const InputDecoration(
                              labelText: "新しいパスワード(確認)",
                            ),
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: RoundedActionButton(
                              width: double.infinity,
                              backgroundColor: primaryNavyColor,
                              textColor: Colors.white,
                              isMobile: false,
                              title: 'パスワードを変更する',
                              onTap: () async {
                                model.startLoading();
                                try {
                                  await model.update();
                                  await _showTextDialog(
                                      model, context, 'パスワードを変更しました');
                                  Navigator.of(context).pop();
                                } catch (e) {
                                  _showTextDialog(model, context, e.toString());
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
              ],
            ),
          );
        },
      ),
    );
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
