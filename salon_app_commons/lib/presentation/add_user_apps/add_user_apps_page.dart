import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

import 'add_user_apps_model.dart';

class AddUserAppsPage extends StatelessWidget {
  static const String route = '/add_user_apps';

  final PreferredSizeWidget appBar;
  const AddUserAppsPage({Key? key, required this.appBar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddUserAppsModel>(
      create: (_) => AddUserAppsModel(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar,
        body: Consumer<AddUserAppsModel>(builder: (context, model, child) {
          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 500,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        autofocus: true,
                        decoration: const InputDecoration(hintText: 'アプリのiOSのURL'),
                        onChanged: (text) {
                          model.iOSURL = text.trim();
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextField(
                        decoration: const InputDecoration(hintText: 'アプリのAndroidのURL'),
                        onChanged: (text) {
                          model.androidURL = text;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      RoundedMoveButton(
                        width: double.infinity,
                        backgroundColor: primaryNavyColor,
                        textColor: Colors.white,
                        isMobile: true,
                        title: '追加申請する',
                        onTap: () async {
                          model.startLoading();
                          try {
                            await model.send();
                            await showTextDialog(context, 'アプリを追加申請しました。');
                            Navigator.of(context).pop();
                          } catch (e) {
                            logger.d(e);
                            showTextDialog(context, e.toString());
                            model.endLoading();
                          }
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
