import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';
import 'package:salon_app_commons/presentation/web_top/web_top_model.dart';
import 'package:url_launcher/url_launcher.dart';

class LogoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LogoAppBar({
    Key? key,
    required this.isLogin,
    required this.isUnderRegister,
    this.automaticallyImplyLeading = true,
    this.onTapHamburgerMenu,
  }) : super(key: key);

  final bool isLogin;
  final bool isUnderRegister;
  final bool automaticallyImplyLeading;
  final void Function()? onTapHamburgerMenu;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      if (isUnderRegister) {
        return const LogoutAppBar();
      }
      return AppBar();
    }

    return AppBar(
      title: Row(
        children: [
          if (onTapHamburgerMenu != null)
            Padding(
              padding: const EdgeInsets.only(left: 4, right: 28),
              child: InkWell(
                onTap: onTapHamburgerMenu,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Tooltip(
                  message: 'メニューを折りたたむ',
                  child: Image.asset(
                    "resources/menu.png",
                    width: 22,
                    height: 22,
                  ),
                ),
              ),
            ),
          InkWell(
            onTap: () {
              context.go('/');
            },
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Tooltip(
              message: 'Flutter大学LPへ',
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'resources/logo_transparent.png',
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Flutter',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 16),
                  ),
                  Text(
                    '大学',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: [
        _actionButton(context),
        const SizedBox(width: 16),
      ],
      automaticallyImplyLeading: automaticallyImplyLeading,
    );
  }

  Widget _actionButton(BuildContext context) {
    if (isLogin) {
      return Row(
        children: [
          InkWell(
            child: const Tooltip(
              message: 'お問い合わせ',
              child: Icon(
                Icons.help_outline,
              ),
            ),
            onTap: () {
              URLUtils.showChannelButton();
              URLUtils.showChannelMessenger();
            },
          ),
          const SizedBox(width: 12),
          InkWell(
            child: const Tooltip(
              message: 'Flutter大学ドキュメント',
              child: Icon(
                Icons.library_books_outlined,
              ),
            ),
            onTap: () {
              URLUtils.launch(urlString: 'https://github.com/flutteruniv/docs/blob/master/README.md');
            },
          ),
          const SizedBox(width: 12),
          InkWell(
            child: const Tooltip(
              message: 'Googleカレンダーを追加',
              child: Icon(
                Icons.calendar_month,
              ),
            ),
            onTap: () {
              URLUtils.launch(
                urlString:
                    'https://calendar.google.com/calendar/u/0?cid=NGl1cG5jNTJtNnRuYWdmMW44YTNxOHV2bnNAZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ',
              );
            },
          ),
          const SizedBox(width: 12),
          InkWell(
            child: Tooltip(
              message: 'このアプリのGitHubリポジトリ',
              child: Image.asset(
                'resources/github.png',
                width: 22,
                height: 22,
              ),
            ),
            onTap: () {
              URLUtils.launch(urlString: 'https://github.com/flutteruniv/salon_app_web');
            },
          ),
          const SizedBox(width: 12),
          PopupMenuButton<HeaderMenu>(
            child: const CircleAvatar(
              backgroundColor: primaryNavyColor,
              radius: 20,
              child: Icon(
                Icons.person,
                size: 24,
                color: Colors.white,
              ),
            ),
            onSelected: (menu) async {
              switch (menu) {
                case HeaderMenu.logout:
                  final isYes = await showConfirmDialog(context, '本当にログアウトしますか？');

                  if (isYes) {
                    await UserRepository().logout();
                    context.go('/');
                  }
                  break;
                default:
                  // Update WebTopModel to set selectedIndex = -1 for header menu pages
                  try {
                    final webTopModel = context.read<WebTopModel>();
                    webTopModel.setHeaderMenuIndex();
                  } catch (e) {
                    // WebTopModel might not be available in some contexts
                    logger.d('WebTopModel not available: $e');
                  }
                  context.go(menu.route);
                  break;
              }
            },
            itemBuilder: (context) {
              if (isUnderRegister) {
                final underRegisterMenu = [HeaderMenu.logout];
                return underRegisterMenu.map((menu) {
                  return PopupMenuItem(
                    value: menu,
                    child: Text(menu.label),
                  );
                }).toList();
              } else {
                return HeaderMenu.values.map((menu) {
                  return PopupMenuItem(
                    value: menu,
                    child: Text(menu.label),
                  );
                }).toList();
              }
            },
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}

enum HeaderMenu {
  myPage,
  teacherPage,
  accountSetting,
  logout,
}

extension HeaderMenuHelper on HeaderMenu {
  static const Map labels = {
    HeaderMenu.myPage: 'マイページ',
    HeaderMenu.teacherPage: '講師設定',
    HeaderMenu.accountSetting: 'アカウント設定',
    HeaderMenu.logout: 'ログアウト',
  };

  static const Map routes = {
    HeaderMenu.myPage: MyPage.route,
    HeaderMenu.teacherPage: TeacherPage.route,
    HeaderMenu.accountSetting: AccountSettingPage.route,
    HeaderMenu.logout: LoginPage.route,
  };

  String get label => labels[this];
  String get route => routes[this];
}

class LogoutAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LogoutAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          onPressed: () async {
            //　お問い合わせ
            didTappedInquiry();
          },
          icon: const Icon(Icons.help),
        ),
        IconButton(
          onPressed: () async {
            final isYes = await showConfirmDialog(context, 'ログアウトしますか？');
            if (isYes) {
              try {
                await UserRepository().logout();
                context.go(LoginPage.route);
              } catch (e) {
                await showTextDialog(context, e.toString());
              }
            }
          },
          icon: const Icon(Icons.logout),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// カスタムトークンを返す
Future<String?> _getCustomToken() async {
  String? token;
  try {
    final functions = FirebaseFunctions.instanceFor(
      app: Firebase.app(),
      region: 'asia-northeast1',
    );
    final callable = functions.httpsCallable('api-getCustomToken');
    final result = await callable.call();
    token = result.data != null ? result.data['token'] : null;
  } on FirebaseFunctionsException catch (e) {
    logger.d('caught firebase functions exception');
    logger.d(e.code);
    logger.d(e.message);
    logger.d(e.details);
  } catch (e) {
    logger.d('caught generic exception');
    logger.d(e);
  }
  return token;
}

/// 入会Webのお問い合わせ画面に遷移する
Future didTappedInquiry() async {
  try {
    final token = await _getCustomToken();
    if (token == null) {
      throw ('エラーが発生しました');
    }
    final url = Uri.parse(_getInquiryUrl(token));
    logger.d(url);

    // ブラウザ連携
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw ('エラーが発生しました');
    }
  } catch (e) {
    // エラーが起きたときはローディングを止める
    rethrow;
  }
}

/// 入会Webのお問い合わせのURLを返す
String _getInquiryUrl(String token) {
  final String webBaseUrl = isDevEnvironment ? 'https://kboy-salon-app.web.app' : 'https://flutteruniv.com';
  return '$webBaseUrl/inquiry?token=$token';
}
