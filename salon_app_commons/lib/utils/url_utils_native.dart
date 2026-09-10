import 'package:url_launcher/url_launcher.dart';

class URLUtils {
  /// ベースURLを返す
  /// web用なのでmock
  static String getBaseUrl() {
    return 'https://flutteruniv.com';
  }

  static String getCurrentUrl() {
    return 'https://flutteruniv.com';
  }

  /// AppStoreのURLを返す
  static const String APP_URL_IOS =
      'https://apps.apple.com/jp/app/id1532391360';

  /// GooglePlayのURLを返す
  static const String APP_URL_ANDROID =
      'https://play.google.com/store/apps/details?id=jp.kboy.kboyflutteruniv';

  static Future launch({
    required String urlString,
    bool shouldOpenNewTab = false,
  }) async {
    final uri = Uri.parse(urlString);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: shouldOpenNewTab
            ? LaunchMode.externalApplication
            : LaunchMode.platformDefault,
      );
    } else {
      throw ('エラーが発生しました。再度お試し下さい。 *2');
    }
  }

  static void changeURLHistory(String path) {}

  static void hideChannelButton() {}

  static void showChannelButton() {}

  static void showChannelMessenger() {}
}
