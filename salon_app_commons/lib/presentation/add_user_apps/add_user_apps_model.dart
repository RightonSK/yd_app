import 'package:flutter/cupertino.dart';
import 'package:salon_app_commons/repository/user_repository.dart';
import 'package:salon_app_commons/repository/user_apps_repository.dart';

class AddUserAppsModel extends ChangeNotifier {
  String iOSURL = '';
  String androidURL = '';
  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future send() async {
    if (iOSURL.isEmpty && androidURL.isEmpty) {
      throw ('urlをどちらか入力してください');
    }
    final user = await UserRepository().fetchMyUser();
    final uid = user?.id;
    
    if (uid == null) {
      throw ('ユーザー情報が取得できませんでした');
    }

    await UserAppsRepository().saveUserApp(
      userId: uid,
      iOSURL: iOSURL.isNotEmpty ? iOSURL : null,
      androidURL: androidURL.isNotEmpty ? androidURL : null,
    );
  }
}
