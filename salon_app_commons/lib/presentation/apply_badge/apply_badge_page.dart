import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class ApplyBadgePage extends StatelessWidget {
  static const String route = '/apply_badge/:name';

  final String badgeName;

  const ApplyBadgePage({Key? key, required this.badgeName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserBadge badge = UserBadge.values.byName(badgeName);
    return ChangeNotifierProvider<ApplyBadgeModel>(
        create: (_) => ApplyBadgeModel(),
        builder: (context, child) {
          return Scaffold(
            appBar: const LogoAppBar(
              isUnderRegister: false,
              isLogin: true,
            ),
            body: Consumer<ApplyBadgeModel>(builder: (context, model, child) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              '以下のバッジを受け取りますか？',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            SizedBox(
                              height: 64,
                              child: UserBadgeWidget(badge, true),
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            RoundedMoveButton(
                              isLoading: model.isLoading,
                              isMobile: true,
                              title: 'バッジを受け取る',
                              onTap: () async {
                                model.startLoading();
                                await model.applyBadge(badge);
                                model.endLoading();
                                await showTextDialog(
                                  context,
                                  '「${badge.nameJP}」を受け取りました！\n取得したバッジ一覧はアプリから確認できます',
                                );
                                // 発表の場合は、FUTも付与もサジェスト
                                switch (badge) {
                                  case UserBadge.presentationStudyMeeting:
                                  case UserBadge.presentationPersonalDevZoom:
                                    final isYes = await showConfirmDialog(
                                      context,
                                      '発表の動画に自分のユーザーを紐付けると、ボーナスFUTももらえます！動画一覧ページに飛びますか？',
                                    );
                                    if (isYes) {
                                      if (kIsWeb) {
                                        context.go('/materials');
                                      } else {
                                        // モバイルは未対応
                                      }
                                    }
                                    break;
                                  default:
                                    break;
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        });
  }
}
