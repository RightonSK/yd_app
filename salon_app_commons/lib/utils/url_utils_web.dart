// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

/// 便利機能
class URLUtils {
  /// ベースURLを返す
  static String getBaseUrl() {
    final origin = html.window.location.origin;
    return origin;
  }

  static String getCurrentUrl() {
    final origin = html.window.location.href;
    return origin;
  }

  /// AppStoreのURLを返す
  static const String APP_URL_IOS =
      'https://apps.apple.com/jp/app/id1532391360';

  /// GooglePlayのURLを返す
  static const String APP_URL_ANDROID =
      'https://play.google.com/store/apps/details?id=jp.kboy.kboyflutteruniv';

  static Future launch({
    required String urlString,
    bool shouldOpenNewTab = true,
  }) async {
    html.window.open(urlString, shouldOpenNewTab ? '_blank' : '_self');
  }

  static void changeURLHistory(String path) {
    html.window.history.pushState(null, "", path); // urlの書き換え
  }

  static void hideChannelButton() {
    js.context.callMethod('ChannelIO', ['hideChannelButton']);
  }

  static void showChannelButton() {
    js.context.callMethod('ChannelIO', ['showChannelButton']);
  }

  static void showChannelMessenger() {
    js.context.callMethod('ChannelIO', ['showMessenger']);
  }
}
