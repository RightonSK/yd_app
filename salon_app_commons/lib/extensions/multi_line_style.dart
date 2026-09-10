import 'package:flutter/material.dart';

import '../utils/font.dart';

/// 複数行で文字が見切れる場合に適用するTextStyle
class MultiLineStyle extends TextStyle {
  const MultiLineStyle({
    double? fontSize,
    Color? color,
    FontWeight? fontWeight,
    TextOverflow? overflow,
  }) : super(
          height: 1.5,
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
          fontFamily: Font.notoSansJP,
          overflow: overflow,
        );
}

/// MultiLineStyle の太字バージョン
class BoldMultiLineStyle extends TextStyle {
  const BoldMultiLineStyle({
    double fontSize = 20,
    Color? color,
  }) : super(
          height: 1.5,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: color,
          fontFamily: Font.notoSansJP,
        );
}
