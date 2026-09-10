import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/presentation/about_fut/about_fut_model.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class AboutFUTPage extends StatelessWidget {
  static const String route = '/about_fut';
  final PreferredSizeWidget appBar;

  const AboutFUTPage({
    Key? key,
    required this.appBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AboutFutModel>(
      create: (_) => AboutFutModel(),
      child: Consumer<AboutFutModel>(builder: (context, model, _) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: primaryNavyColor,
              appBar: AppBar(
                centerTitle: true,
                title: const Text('FUTについて'),
              ),
              body: AboutFUTBody(
                onTapAdButton: () async {
                  final isYes = await showConfirmDialog(
                    context,
                    '広告を見てFUTをゲットしますか？',
                  );

                  if (isYes) {
                    model.startLoading();
                    try {
                      await model.showRewardedAd(context);
                      model.rewardedAd?.dispose();
                    } catch (e) {
                      showErrorDialogAndInquiryChat(context, e);
                    } finally {
                      model.endLoading();
                    }
                  }
                },
                onTapTimesInput: () async {
                  context.push(SlackTimesInputPage.route);
                },
                onTapInvite: () async {
                  context.push(InvitePage.route);
                },
              ),
            ),
            model.isLoading
                ? Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : const SizedBox()
          ],
        );
      }),
    );
  }
}
