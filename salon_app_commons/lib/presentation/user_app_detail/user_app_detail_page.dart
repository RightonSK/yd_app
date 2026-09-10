import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widget/multi_user_row_widget.dart';
import '../../widget/user_row_widget.dart';
import 'user_app_detail_model.dart';

class UserAppDetailPage extends StatelessWidget {
  static const String route = '/user_app_detail';
  final UserApp app;
  const UserAppDetailPage({
    super.key,
    required this.app,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserAppDetailModel>(
      create: (_) => UserAppDetailModel()..fetchMember(app),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(app.appTitle ?? ''),
        ),
        body: Consumer<UserAppDetailModel>(builder: (context, model, child) {
          if (model.isLoading) {
            return const FlutterUnivLoadingIndicator();
          }
          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 500,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: SizedBox(
                              width: 88,
                              height: 88,
                              child: app.appIconImageURL != null &&
                                      app.appIconImageURL!.isNotEmpty
                                  ? FadeInImage.memoryNetwork(
                                      placeholder: kTransparentImage,
                                      image: app.appIconImageURL!,
                                      fit: BoxFit.cover,
                                      imageErrorBuilder:
                                          (context, error, stackTrace) {
                                        // フィードのエラーハンドリング
                                        return ColorFiltered(
                                          colorFilter: const ColorFilter.mode(
                                            Colors.grey,
                                            BlendMode.saturation,
                                          ),
                                          child: Image.asset(
                                            'resources/logo.jpg',
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      },
                                    )
                                  : ColorFiltered(
                                      colorFilter: const ColorFilter.mode(
                                        Colors.grey,
                                        BlendMode.saturation,
                                      ),
                                      child: Image.asset(
                                        'resources/logo.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  app.appTitle ?? '',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                if (app.isTeam == true)
                                  Row(
                                    children: const [
                                      Icon(Icons.people),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        '共同開発',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                const SizedBox(height: 4),
                                if (model.members.isNotEmpty)
                                  MultiUserRowWidget(model.members),
                                if (model.member != null)
                                  Row(
                                    children: [
                                      UserRowWidget(model.member!),
                                      const Spacer()
                                    ],
                                  ),
                                const SizedBox(height: 8),
                                Builder(builder: (context) {
                                  final webButton = InkWell(
                                    child: SizedBox(
                                      height: 60,
                                      child: FittedBox(
                                        fit: BoxFit.cover,
                                        child: Column(
                                          children: const [
                                            Icon(
                                              Icons.public_outlined,
                                              color: themeNavy,
                                            ),
                                            Text(
                                              'Web',
                                              style: TextStyle(
                                                  fontSize: 8,
                                                  color: themeNavy),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    onTap: () async {
                                      final url = Uri.parse(app.webURL ?? '');
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(url);
                                      } else {
                                        showErrorDialogAndInquiryChat(
                                          context,
                                          'URLの読み込みに失敗しました',
                                        );
                                      }
                                    },
                                  );

                                  final iOSDownloadButton = InkWell(
                                    child: SizedBox(
                                      height: 30,
                                      child: Image.asset(
                                        'salon_app_commons/resources/download_on_the_appstore.png',
                                      ),
                                    ),
                                    onTap: () async {
                                      final url = Uri.parse(app.iOSURL ?? '');
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(url);
                                      } else {
                                        showErrorDialogAndInquiryChat(
                                          context,
                                          'URLの読み込みに失敗しました',
                                        );
                                      }
                                    },
                                  );

                                  final androidDownloadButton = InkWell(
                                    child: SizedBox(
                                      height: 30,
                                      child: Image.asset(
                                        'salon_app_commons/resources/get_it_on_google_play.png',
                                      ),
                                    ),
                                    onTap: () async {
                                      final url =
                                          Uri.parse(app.androidURL ?? '');
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(url);
                                      } else {
                                        showErrorDialogAndInquiryChat(
                                          context,
                                          'URLの読み込みに失敗しました',
                                        );
                                      }
                                    },
                                  );

                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (app.webURL != null &&
                                          app.webURL!.isNotEmpty)
                                        webButton,
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      if (kIsWeb)
                                        Row(
                                          children: [
                                            iOSDownloadButton,
                                            const SizedBox(width: 4),
                                            androidDownloadButton,
                                          ],
                                        ),
                                      if (!kIsWeb &&
                                          Platform.isAndroid &&
                                          app.androidURL != null)
                                        androidDownloadButton,
                                      if (!kIsWeb &&
                                          Platform.isIOS &&
                                          app.iOSURL != null)
                                        iOSDownloadButton,
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (app.github != null && app.github!.isNotEmpty)
                        const SizedBox(height: 8),
                      if (app.github != null && app.github!.isNotEmpty)
                        _githubLink(context, app.github!),
                      if (app.slackId != null && app.slackId!.isNotEmpty)
                        const SizedBox(height: 8),
                      if (app.slackId != null && app.slackId!.isNotEmpty)
                        _slackLink(context, app.slackId!),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          app.getDisplayReleaseDate(),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        app.appDescription!,
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _githubLink(BuildContext context, String githubLink) {
    const githubHost = 'https://github.com/';
    final url = app.github;

    final String githubName;
    if (url == null) {
      githubName = '';
    } else {
      githubName = url.substring(githubHost.length, url.length);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(3),
          child: Image.asset(
            'resources/github.png',
            width: 18,
          ),
        ),
        const SizedBox(
          width: 2,
        ),
        InkWell(
          onTap: app.github != null
              ? () async {
                  if (url == null) {
                    return;
                  }
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url));
                  } else {
                    showErrorDialogAndInquiryChat(
                      context,
                      'URLの読み込みに失敗しました',
                    );
                  }
                }
              : null,
          child: Text(
            githubName,
          ),
        ),
      ],
    );
  }

  Widget _slackLink(BuildContext context, String slackId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Icon(
          FontAwesome5.slack,
        ),
        const SizedBox(
          width: 6,
        ),
        InkWell(
          child: const Text(
            'slackチャンネル',
            style: TextStyle(
              color: primaryNavyColor,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
          onTap: () async {
            final url = 'slack://channel?team=T012UQWDRQC&id=${app.slackId}';
            URLUtils.launch(urlString: url, shouldOpenNewTab: true);
          },
        ),
      ],
    );
  }
}
