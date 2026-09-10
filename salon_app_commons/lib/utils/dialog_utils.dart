import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

Future<bool> showActionConfirmTextDialog(
  BuildContext context,
  String message,
  String actionText,
  String negativeText, {
  bool barrierDismissible = true,
}) async {
  return showActionConfirmDialog(
    context,
    SelectableText(
      message,
      style: const MultiLineStyle(),
    ),
    actionText,
    negativeText,
  );
}

Future<bool> showConfirmDialog(
  BuildContext context,
  String message,
) async {
  return showActionConfirmTextDialog(
    context,
    message,
    'はい',
    'いいえ',
  );
}

Future<bool> showActionConfirmDialog(
  BuildContext context,
  Widget child,
  String actionText,
  String negativeText, {
  bool barrierDismissible = true,
}) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (BuildContext context) {
          return AlertDialog(
            title: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: child,
            ),
            actions: <Widget>[
              TextButton(
                child: Text(negativeText),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              _OKButton(title: actionText),
            ],
          );
        },
      ) ??
      false;
}

Future<int?> showThreeOptionDialog(
  BuildContext context, {
  required String message,
  required String actionText1,
  required String actionText2,
  required String negativeText,
  bool barrierDismissible = true,
}) async {
  return await showDialog<int>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext context) {
      return AlertDialog(
        title: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SelectableText(
            message,
            style: const MultiLineStyle(),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(negativeText),
            onPressed: () {
              Navigator.of(context).pop(0);
            },
          ),
          SizedBox(
            height: 40,
            width: 120,
            child: RoundedActionButton(
              isMobile: false,
              title: actionText1,
              textColor: Colors.white,
              backgroundColor: primaryNavyColor,
              onTap: () {
                Navigator.of(context).pop(1);
              },
            ),
          ),
          SizedBox(
            height: 40,
            width: 120,
            child: RoundedActionButton(
              isMobile: false,
              title: actionText2,
              textColor: Colors.white,
              backgroundColor: primaryNavyColor,
              onTap: () {
                Navigator.of(context).pop(2);
              },
            ),
          ),
        ],
      );
    },
  );
}

Future showTextDialog(
  BuildContext context,
  String message, {
  bool barrierDismissible = true,
}) async {
  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext context) {
      return AlertDialog(
        title: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SelectableText(
            message,
            style: const MultiLineStyle(),
          ),
        ),
        backgroundColor: Colors.white,
        actions: const <Widget>[
          _OKButton(),
        ],
      );
    },
  );
}

Future showErrorDialogAndInquiryChat(BuildContext context, dynamic e,
    {bool shouldShowInquiryChat = true}) async {
  await showTextDialog(
    context,
    e.toString(),
  );
  // エラーの時は、お問い合わせを表示する
  if (shouldShowInquiryChat) {
    URLUtils.showChannelButton();
    URLUtils.showChannelMessenger();
  }
}

class _OKButton extends StatelessWidget {
  const _OKButton({
    this.title = 'OK',
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 100,
      child: RoundedActionButton(
        isMobile: false,
        title: title,
        textColor: Colors.white,
        backgroundColor: primaryNavyColor,
        onTap: () {
          Navigator.of(context).pop(true);
        },
      ),
    );
  }
}
