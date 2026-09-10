import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/presentation/welcome/welcome_model.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class WelcomePage extends StatelessWidget {
  static const String route = '/welcome';

  const WelcomePage({
    Key? key,
    this.appBar,
  }) : super(key: key);

  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WelcomeModel>(
      create: (_) => WelcomeModel(),
      builder: (context, child) {
        return Scaffold(
          appBar: appBar,
          body: Consumer<WelcomeModel>(
            builder: (context, model, child) {
              return SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        'ようこそFlutter大学へ！（このページは入会から１ヶ月後に消えます）',
                        style: MultiLineStyle(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        '👶入ったらまずやること',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),
                      RoundedMoveButton(
                        isMobile: true,
                        title: '動画',
                        textColor: youtubeRedColor,
                        iconData: FontAwesome5.youtube,
                        onTap: () async {
                          URLUtils.launch(
                              urlString: 'https://youtu.be/xzUASfvj9j0');
                        },
                      ),
                      const SizedBox(height: 8),
                      RoundedMoveButton(
                        isMobile: true,
                        textColor: githubBlackColor,
                        iconData: Icons.library_books_outlined,
                        title: 'テキスト',
                        onTap: () async {
                          URLUtils.launch(
                              urlString:
                                  'https://github.com/flutteruniv/docs/blob/master/welcome.md');
                        },
                      ),
                      const SizedBox(
                        height: 64,
                      ),
                      Text(
                        '🌏Flutter大学の全体像',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),
                      RoundedMoveButton(
                        isMobile: true,
                        textColor: youtubeRedColor,
                        iconData: FontAwesome5.youtube,
                        title: '動画',
                        onTap: () async {
                          URLUtils.launch(
                              urlString: 'https://youtu.be/qLUT2qMCQ1Q');
                        },
                      ),
                      const SizedBox(height: 8),
                      RoundedMoveButton(
                        isMobile: true,
                        textColor: githubBlackColor,
                        iconData: Icons.library_books_outlined,
                        title: 'テキスト',
                        onTap: () async {
                          URLUtils.launch(
                              urlString:
                                  'https://github.com/flutteruniv/docs/blob/master/README.md');
                        },
                      ),
                      const SizedBox(
                        height: 80,
                      ), // お問い合わせボタンとかぶるので下の幅は広めにとる
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
