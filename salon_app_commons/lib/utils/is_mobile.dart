// 画面サイズから判別(ブラウザを小さくする場合もあるからレイアウト系は基本こっちの方がよさそう)
import 'package:flutter/foundation.dart';
import 'package:responsive_builder/responsive_builder.dart';

bool checkIsMobile(SizingInformation sizingInformation) {
  bool isMobile = false;
  switch (sizingInformation.deviceScreenType) {
    case DeviceScreenType.desktop:
      break;
    case DeviceScreenType.tablet:
    case DeviceScreenType.mobile:
    case DeviceScreenType.watch:
      isMobile = true;
      break;
    default:
      break;
  }
  return isMobile;
}

// OSから判別
bool isMobile = defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android;
