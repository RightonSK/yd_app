import 'package:flutter/material.dart';

class AppConstants {
  static const String appTitle = '家電販売サポート';

  static final ThemeData theme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
    ),
  );
}
