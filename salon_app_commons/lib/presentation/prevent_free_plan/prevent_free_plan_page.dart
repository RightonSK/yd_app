import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class PreventFreePlanPage extends StatelessWidget {
  static const String route = '/free_plan_end';
  const PreventFreePlanPage({
    Key? key,
    required this.appBar,
  }) : super(key: key);

  final PreferredSizeWidget appBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Container(
        color: Colors.redAccent,
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "無料プランのサポートは終了いたしました🙏",
              style: BoldMultiLineStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              kIsWeb
                  ? '無料プランではない場合は画面を更新してください。\nご不明点があれば右下のボタンからお問い合わせください。'
                  : 'ご不明点があればwebページの右下のボタンからお問い合わせください。',
              style: MultiLineStyle(
                color: Colors.white,
              ),
            ),
            if (kIsWeb)
              const SizedBox(
                height: 16,
              ),
            if (kIsWeb)
              RoundedMoveButton(
                isMobile: true,
                title: 'プラン変更はこちら',
                onTap: () {
                  context.go('/changePlan');
                },
              ),
          ],
        ),
      ),
    );
  }
}
