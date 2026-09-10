import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

/// NotFound 画面
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.redAccent,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Not Found",
              style: BoldMultiLineStyle(
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "右下のボタンから運営にお問い合わせください",
              style: MultiLineStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
