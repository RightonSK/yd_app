import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class LocaleSettingWidget extends StatelessWidget {
  const LocaleSettingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          child: Text(
            '日本語',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 11,
                  color: primaryNavyColor,
                  fontWeight: LocaleSettings.currentLocale == AppLocale.ja
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
          ),
          onPressed: () {
            LocaleSettings.setLocale(AppLocale.ja);
          },
        ),
        TextButton(
          child: Text(
            'English',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 11,
                  color: primaryNavyColor,
                  fontWeight: LocaleSettings.currentLocale != AppLocale.ja
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
          ),
          onPressed: () {
            LocaleSettings.setLocale(AppLocale.en);
          },
        ),
      ],
    );
  }
}
