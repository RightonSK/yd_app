import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:salon_app_commons/presentation/annual_recap/annual_recap_page.dart';
import 'package:salon_app_commons/presentation/welcome/welcome_page.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

import 'presentation/question_chat/question_chat_page.dart';
import 'presentation/question_chat_list/question_chat_list_page.dart';
import 'presentation/study_materials_top/study_material_top_page.dart';
import 'presentation/web_top/web_top_menu.dart';
import 'presentation/web_top/web_top_page.dart';

class CommonRoute {
  static String? getWaitingPageRedirectRoute({
    required UserState userState,
    required String memberStateRoute,
  }) {
    final nextRoute = _getCurrentRoute(
      userState: userState,
      memberStateRoute: memberStateRoute,
    );
    logger.d(nextRoute);

    if (nextRoute == WaitingPage.route || nextRoute == LoginPage.route) {
      return null;
    }
    return nextRoute;
  }

  static String _getCurrentRoute({
    required UserState userState,
    required String memberStateRoute,
  }) {
    switch (userState) {
      case UserState.waiting: // 取得中
        return WaitingPage.route;

      case UserState.noLogin: // 未ログインならログイン画面に遷移する
        return LoginPage.route;

      case UserState.noVerified: // メールアドレス未認証なら認証画面に遷移する
        return SentVerificationPage.route;

      case UserState.noSubscription: // 未課金ならCheckout画面にリダイレクトする
        return SelectPlanPage.route;

      case UserState.noNickname:
        return NicknameInputPage.route;

      case UserState.noGithubId:
        return GithubInputPage.route;

      case UserState.noSlackEmail:
        return SlackInputPage.route;

      case UserState.notAnswerQuestionnaire:
        return QuestionnairePage.route;

      case UserState.freePlan:
        return PreventFreePlanPage.route;

      case UserState.member:
        return memberStateRoute;
    }
  }

  // FIXME: まとめ途中
  static List<GoRoute> routes = [
    GoRoute(
      path: ResetPasswordPage.route,
      pageBuilder: (context, state) {
        return noTransitionPageOnWeb(
          child: const ResetPasswordPage(),
        );
      },
    ),
    GoRoute(
      path: TermPage.route,
      pageBuilder: (context, state) {
        return noTransitionPageOnWeb(
          child: const TermPage(),
        );
      },
    ),
    GoRoute(
      path: PrivacyPolicyPage.route,
      pageBuilder: (context, state) {
        return noTransitionPageOnWeb(
          child: const PrivacyPolicyPage(),
        );
      },
    ),
    GoRoute(
      path: TokushoPage.route,
      pageBuilder: (context, state) {
        return noTransitionPageOnWeb(
          child: const TokushoPage(),
        );
      },
    ),
    GoRoute(
      path: AboutFUTPage.route,
      pageBuilder: (context, state) {
        return noTransitionPageOnWeb(
          child: const AboutFUTPage(
            appBar: LogoAppBar(
              isUnderRegister: false,
              isLogin: true,
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: QuestionZoomCushionPage.route,
      pageBuilder: (context, state) {
        return noTransitionPageOnWeb(
          child: QuestionZoomCushionPage(
              appBar: const LogoAppBar(
                isUnderRegister: false,
                isLogin: true,
              ),
              onTapChangePlan: (context) {
                if (isMobile) {
                  // ダイアログを出す
                  showTextDialog(context, 'クレジットカード決済の方はwebからプラン変更をお願いします。アプリで課金をした方は設定からサブスクリプションを変更してください。');
                } else {
                  // MARK: webでしか使われない（アプリがわでチェンジプランしたらAppleの違反なので）
                  context.go('/changePlan');
                }
              },
              onTapReserveButton: (context) {
                context.go(SchedulePage.route);
              }),
        );
      },
    ),
    GoRoute(
      path: GatherCushionPage.route,
      pageBuilder: (context, state) {
        return noTransitionPageOnWeb(
          child: const GatherCushionPage(
            appBar: LogoAppBar(
              isUnderRegister: false,
              isLogin: true,
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: StudyMeetingCushionPage.route,
      pageBuilder: (context, state) {
        return noTransitionPageOnWeb(
          child: const StudyMeetingCushionPage(
            appBar: LogoAppBar(
              isUnderRegister: false,
              isLogin: true,
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: MorningGatherPage.route,
      pageBuilder: (context, state) {
        return noTransitionPageOnWeb(
          child: const MorningGatherPage(
            appBar: LogoAppBar(
              isUnderRegister: false,
              isLogin: true,
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: PersonalDevZoomPage.route,
      pageBuilder: (context, state) {
        return noTransitionPageOnWeb(
          child: const PersonalDevZoomPage(
            appBar: LogoAppBar(
              isUnderRegister: false,
              isLogin: true,
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: PartyZoomCushionPage.route,
      pageBuilder: (context, state) {
        return noTransitionPageOnWeb(
          child: const PartyZoomCushionPage(
            appBar: LogoAppBar(
              isUnderRegister: false,
              isLogin: true,
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: MyFUTPage.route,
      pageBuilder: (context, state) {
        return noTransitionPageOnWeb(
          child: const MyFUTPage(
            appBar: LogoAppBar(
              isUnderRegister: false,
              isLogin: true,
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: WithdrawPage.route,
      pageBuilder: (context, state) {
        return noTransitionPageOnWeb(
          child: const WithdrawPage(
            appBar: LogoAppBar(
              isLogin: true,
              isUnderRegister: false,
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: ZennInputPage.route,
      pageBuilder: (context, state) {
        return noTransitionPageOnWeb(
          child: const ZennInputPage(
            appBar: LogoAppBar(
              isLogin: true,
              isUnderRegister: false,
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: AnnualRecapPage.route,
      pageBuilder: (context, state) {
        return noTransitionPageOnWeb(
          child: const AnnualRecapPage(
            appBar: LogoAppBar(
              isLogin: true,
              isUnderRegister: false,
            ),
          ),
        );
      },
    ),
    // 2025/01/10追加
    GoRoute(
      path: SignUpPage.route,
      pageBuilder: (context, state) {
        final inviteId = state.uri.queryParameters['invite_id'];

        return noTransitionPageOnWeb(
          isUniqueKey: false,
          child: SignUpPage(
            inviteId: inviteId,
            appBar: const LogoAppBar(
              isUnderRegister: false,
              isLogin: false,
            ),
            onTapLogin: (BuildContext context) async {
              context.go(LoginPage.route);
            },
          ),
        );
      },
    ),
    GoRoute(
        path: LoginPage.route,
        pageBuilder: (context, state) {
          final path = state.uri.queryParameters['path'];
          logger.d('Routes: to ${LoginPage.route}, path=$path');
          return noTransitionPageOnWeb(
            child: LoginPage(
              path: path,
              appBar: const LogoAppBar(
                isUnderRegister: false,
                isLogin: false,
              ),
            ),
          );
        }),
    GoRoute(
      path: WaitingPage.route,
      pageBuilder: (context, state) {
        return noTransitionPageOnWeb(
          child: const WaitingPage(
            appBar: LogoAppBar(
              isUnderRegister: false,
              isLogin: false,
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: SentVerificationPage.route,
      pageBuilder: (context, state) => noTransitionPageOnWeb(
        child: const SentVerificationPage(
          appBar: LogoAppBar(isLogin: true, isUnderRegister: true),
        ),
      ),
    ),
    GoRoute(
      path: ThanksPage.route,
      pageBuilder: (context, state) => noTransitionPageOnWeb(
        child: const ThanksPage(
          appBar: LogoAppBar(
            isUnderRegister: true,
            isLogin: true,
          ),
        ),
      ),
    ),
    GoRoute(
      path: NicknameInputPage.route,
      pageBuilder: (context, state) {
        final planName = state.uri.queryParameters['plan'];
        return noTransitionPageOnWeb(
          isUniqueKey: false,
          child: NicknameInputPage(
            planName,
            appBer: const LogoAppBar(
              isUnderRegister: true,
              isLogin: true,
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: SlackInputPage.route,
      pageBuilder: (context, state) {
        final planName = state.uri.queryParameters['plan'];
        return noTransitionPageOnWeb(
          isUniqueKey: false,
          child: SlackInputPage(
            planName,
            appBar: const LogoAppBar(
              isUnderRegister: true,
              isLogin: true,
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: GithubInputPage.route,
      pageBuilder: (context, state) {
        final planName = state.uri.queryParameters['plan'];
        return noTransitionPageOnWeb(
          isUniqueKey: false,
          child: GithubInputPage(
            planName,
            appBar: const LogoAppBar(
              isUnderRegister: true,
              isLogin: true,
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: GithubInputRecoverPage.route,
      pageBuilder: (context, state) {
        final planName = state.uri.queryParameters['plan'];
        return noTransitionPageOnWeb(
          isUniqueKey: false,
          child: GithubInputRecoverPage(
            planName,
            appBar: const LogoAppBar(
              isUnderRegister: true,
              isLogin: true,
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: TwitterSharePage.route,
      pageBuilder: (context, state) {
        final planName = state.uri.queryParameters['plan'];
        return noTransitionPageOnWeb(
          isUniqueKey: false,
          child: TwitterSharePage(
            planName,
            appBar: const LogoAppBar(
              isUnderRegister: true,
              isLogin: true,
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: AddCalendarPage.route,
      pageBuilder: (context, state) => noTransitionPageOnWeb(
        isUniqueKey: false,
        child: AddCalendarPage(
          appBar: const LogoAppBar(
            isUnderRegister: true,
            isLogin: true,
          ),
          onTapNextPage: (BuildContext context) async {
            if (isMobile) {
              // 質問ページへ遷移
              context.push(QuestionnairePage.route);
            } else {
              // webの場合はダウンロードページ出してる
              context.go('/app_download');
            }
          },
        ),
      ),
    ),
    GoRoute(
      path: QuestionnairePage.route,
      pageBuilder: (context, state) => noTransitionPageOnWeb(
        isUniqueKey: false,
        child: QuestionnairePage(
          appBar: const LogoAppBar(
            isUnderRegister: true,
            isLogin: true,
          ),
          onTapNextPage: (BuildContext context) {
            if (isMobile) {
              context.go('/'); // モバイルはTopPageへ遷移
            } else {
              context.go(FeedPage.route); // webはFeedPageへ遷移
            }
          },
        ),
      ),
    ),
    GoRoute(
      path: PreventFreePlanPage.route,
      pageBuilder: (context, state) {
        return noTransitionPageOnWeb(
          child: const PreventFreePlanPage(
            appBar: LogoAppBar(
              isUnderRegister: true,
              isLogin: true,
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: VideoDetailPage.route(':chapterId', ':contentId'),
      pageBuilder: (context, state) {
        final chapterId = state.pathParameters['chapterId']!;
        final contentId = state.pathParameters['contentId']!;
        final chapter = state.extra;
        logger.d('Routes: to ${VideoDetailPage.route}, chapterId=$chapterId, contentId=$contentId');
        return noTransitionPageOnWeb(
          child: VideoDetailPage(
            const LogoAppBar(
              isUnderRegister: false,
              isLogin: true,
            ),
            chapterId,
            contentId,
            chapter as List<Video>?,
          ),
        );
      },
    ),
    GoRoute(
      path: SlackTimesInputPage.route,
      pageBuilder: (context, state) => noTransitionPageOnWeb(
        child: const SlackTimesInputPage(
          appBar: LogoAppBar(
            isUnderRegister: false,
            isLogin: true,
          ),
        ),
      ),
    ),
    GoRoute(
      path: InvitePage.route,
      pageBuilder: (context, state) => noTransitionPageOnWeb(
        child: const InvitePage(
          appBar: LogoAppBar(
            isUnderRegister: false,
            isLogin: true,
          ),
        ),
      ),
    ),
    GoRoute(
      path: AddUserAppsPage.route,
      builder: (context, state) => const AddUserAppsPage(
        appBar: LogoAppBar(
          isUnderRegister: false,
          isLogin: true,
        ),
      ),
    ),
    GoRoute(
      path: BadgeListPage.route,
      builder: (context, state) {
        final badges = state.extra as List<UserBadge>?;
        return BadgeListPage(
          appBar: const LogoAppBar(
            isUnderRegister: false,
            isLogin: true,
          ),
          badges: badges,
        );
      },
    ),
    GoRoute(
      path: UserAppDetailPage.route,
      builder: (context, state) {
        final app = state.extra as UserApp;
        return UserAppDetailPage(
          app: app,
        );
      },
    ),
    GoRoute(
      path: WithdrawQuestionnairePage.route,
      builder: (context, state) {
        final extra = state.extra;

        return WithdrawQuestionnairePage(
          appBar: const LogoAppBar(
            isUnderRegister: false,
            isLogin: true,
          ),
          subscription: extra as AbstractSubscription?,
        );
      },
    ),
    GoRoute(
      path: GithubUpdatePage.route,
      builder: (context, state) => const GithubUpdatePage(
        appBar: LogoAppBar(
          isUnderRegister: false,
          isLogin: true,
        ),
      ),
    ),

    //
    // ここから-- webしかない
    GoRoute(
      path: RewardsPage.route,
      pageBuilder: (context, state) {
        return noTransitionPageOnWeb(
          child: const RewardsPage(),
        );
      },
    ),
    GoRoute(
      path: ZoomListPage.route,
      pageBuilder: (context, state) => noTransitionPageOnWeb(
        child: const ZoomListPage(),
      ),
    ),
    GoRoute(
      path: TeacherPage.route,
      pageBuilder: (context, state) {
        if (kIsWeb) {
          return NoTransitionPage(
            key: UniqueKey(),
            child: const WebTopPage(route: TeacherPage.route),
          );
        } else {
          return NoTransitionPage(
            key: UniqueKey(),
            child: const TeacherPage(),
          );
        }
      },
    ),

    // ここまで-- webしかない
    //

    GoRoute(
      path: '/users/:userParam',
      pageBuilder: (context, state) {
        final userParam = state.pathParameters['userParam']!;
        // default tab value in query param is profile.
        final tabName = state.uri.queryParameters['tab'] ?? 'profile';
        
        // Determine if userParam is a userId (typically numeric/UUID) or nickname
        // UserIds are typically Firebase UIDs (alphanumeric with length 28) or UUIDs
        // Nicknames are user-friendly strings
        final isUserId = userParam.length == 28 || 
                        RegExp(r'^[a-zA-Z0-9]{20,}$').hasMatch(userParam) ||
                        RegExp(r'^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$').hasMatch(userParam);
        
        return noTransitionPageOnWeb(
          child: MemberDetailPage(
            appBar: const LogoAppBar(
              isUnderRegister: false,
              isLogin: true,
            ),
            nickname: isUserId ? null : userParam,
            userId: isUserId ? userParam : null,
            tabName: tabName,
            onTapLinkToMap: (prefecture) async {
              await showTextDialog(context, 'モバイルアプリだとMapを見ることができます');
            },
          ),
        );
      },
    ),
    GoRoute(
      path: MentorPlanUpsertingPage.route,
      pageBuilder: (context, state) {
        final String? planId = state.uri.queryParameters['plan_id'];
        return noTransitionPageOnWeb(
          child: MentorPlanUpsertingPage(
            appBar: const LogoAppBar(
              isUnderRegister: false,
              isLogin: true,
            ),
            planId: planId,
          ),
        );
      },
    ),
    GoRoute(
      path: MemberThanksPage.route,
      pageBuilder: (context, state) {
        final String? slackId = state.uri.queryParameters['slack_id'];
        final String? title = state.uri.queryParameters['title'];
        final String? priceText = state.uri.queryParameters['priceText'];

        return noTransitionPageOnWeb(
          child: MemberThanksPage(
            appBar: const LogoAppBar(
              isUnderRegister: false,
              isLogin: true,
            ),
            slackId: slackId,
            title: title,
            priceText: priceText,
          ),
        );
      },
    ),
    GoRoute(
      path: ApplyBadgePage.route,
      pageBuilder: (context, state) {
        final badgeName = state.pathParameters['name']!;
        return NoTransitionPage(
          key: UniqueKey(),
          child: ApplyBadgePage(badgeName: badgeName),
        );
      },
    ),
    //
    // ----------- webのメニューにあるやつ
    GoRoute(
      path: MyPage.route,
      pageBuilder: (context, state) {
        if (kIsWeb) {
          return NoTransitionPage(
            key: UniqueKey(),
            child: const WebTopPage(route: MyPage.route),
          );
        } else {
          // 基本モバイルアプリの場合、タブで表示されているので、pathでアクセスされることはない。
          return NoTransitionPage(
            key: UniqueKey(),
            child: const Scaffold(),
          );
        }
      },
    ),
    GoRoute(
      path: StudyMaterialsTopPage.route,
      pageBuilder: (context, state) {
        if (kIsWeb) {
          return NoTransitionPage(
            key: UniqueKey(),
            child: const WebTopPage(route: StudyMaterialsTopPage.route),
          );
        } else {
          // FIXME: 現状モバイルにこのpathはないが、統合の可能性あり
          return NoTransitionPage(
            key: UniqueKey(),
            child: const Scaffold(),
          );
        }
      },
    ),
    GoRoute(
      path: MentorPlanListPage.route,
      pageBuilder: (context, state) {
        if (kIsWeb) {
          return NoTransitionPage(
            key: UniqueKey(),
            child: const WebTopPage(route: MentorPlanListPage.route),
          );
        } else {
          // モバイルはWebTopPageで囲まれていない
          return NoTransitionPage(
            key: UniqueKey(),
            child: MentorPlanListPage(
              appBar: AppBar(),
            ),
          );
        }
      },
    ),
    GoRoute(
      path: AccountSettingPage.route,
      pageBuilder: (context, state) {
        if (kIsWeb) {
          return NoTransitionPage(
            key: UniqueKey(),
            child: const WebTopPage(route: AccountSettingPage.route),
          );
        } else {
          // 現状モバイルはここにアクセスする想定ではない
          return NoTransitionPage(
            key: UniqueKey(),
            child: const AccountSettingPage(),
          );
        }
      },
    ),
    GoRoute(
      path: WelcomePage.route,
      pageBuilder: (context, state) {
        if (kIsWeb) {
          return NoTransitionPage(
            key: UniqueKey(),
            child: const WebTopPage(route: WelcomePage.route),
          );
        } else {
          // 基本モバイルアプリの場合、タブで表示されているので、pathでアクセスされることはない。
          return NoTransitionPage(
            key: UniqueKey(),
            child: WelcomePage(
              appBar: AppBar(
                title: const Text('はじめての方へ'),
              ),
            ),
          );
        }
      },
    ),
    GoRoute(
      path: FeedPage.route,
      pageBuilder: (context, state) {
        if (kIsWeb) {
          return NoTransitionPage(
            key: UniqueKey(),
            child: const WebTopPage(route: FeedPage.route),
          );
        } else {
          // 基本モバイルアプリの場合、タブで表示されているので、pathでアクセスされることはない。
          return NoTransitionPage(
            key: UniqueKey(),
            child: FeedPage(
              appBar: AppBar(
                title: const Text('フィード'),
              ),
              googleToken: kGoogleToken,
              calendarId: kCalendarId,
            ),
          );
        }
      },
    ),
    GoRoute(
      path: QuestionChatPage.route(':roomId'),
      pageBuilder: (context, state) {
        final roomId = state.pathParameters['roomId']!;

        if (roomId == 'new') {
          if (kIsWeb) {
            return NoTransitionPage(
              key: UniqueKey(),
              child: const Scaffold(
                appBar: LogoAppBar(
                  isUnderRegister: false,
                  isLogin: true,
                ),
                body: QuestionChatPage(),
              ),
            );
          } else {
            return NoTransitionPage(
              key: UniqueKey(),
              child: QuestionChatPage(
                appBar: AppBar(
                  title: const Text('新しい質問'),
                ),
              ),
            );
          }
        }

        if (kIsWeb) {
          return NoTransitionPage(
            key: UniqueKey(),
            child: Scaffold(
              appBar: const LogoAppBar(
                isUnderRegister: false,
                isLogin: true,
              ),
              body: QuestionChatPage(
                roomId: roomId,
              ),
            ),
          );
        } else {
          return NoTransitionPage(
            key: UniqueKey(),
            child: QuestionChatPage(
              roomId: roomId,
              appBar: AppBar(
                title: const Text('質問詳細'),
              ),
            ),
          );
        }
      },
    ),
    GoRoute(
      path: QuestionChatListPage.route,
      pageBuilder: (context, state) {
        if (kIsWeb) {
          return NoTransitionPage(
            key: UniqueKey(),
            child: const WebTopPage(route: QuestionChatListPage.route),
          );
        } else {
          return NoTransitionPage(
            key: UniqueKey(),
            child: QuestionChatListPage(
              appBar: AppBar(
                title: const Text('質問履歴'),
              ),
            ),
          );
        }
      },
    ),
    GoRoute(
      path: CommunityPage.route,
      pageBuilder: (context, state) {
        if (kIsWeb) {
          return NoTransitionPage(
            key: UniqueKey(),
            child: const WebTopPage(route: CommunityPage.route),
          );
        } else {
          // 基本モバイルアプリの場合、タブで表示されているので、pathでアクセスされることはない。
          return NoTransitionPage(
            key: UniqueKey(),
            child: CommunityPage(
              appBar: AppBar(
                title: const Text('コミュニティ'),
              ),
            ),
          );
        }
      },
    ),
    GoRoute(
      path: SchedulePage.route,
      pageBuilder: (context, state) {
        if (kIsWeb) {
          return NoTransitionPage(
            key: UniqueKey(),
            child: const WebTopPage(route: SchedulePage.route),
          );
        } else {
          // 基本モバイルアプリの場合、タブで表示されているので、pathでアクセスされることはない。
          return NoTransitionPage(
            key: UniqueKey(),
            child: SchedulePage(
              appBar: AppBar(
                title: const Text('スケジュール'),
              ),
            ),
          );
        }
      },
    ),
    // ----------- メニューにあるやつ ここまで
    //
    //
  ];

  static Page<void> noTransitionPageOnWeb({
    required Widget child,
    bool isUniqueKey = true,
  }) {
    if (isMobile) {
      return MaterialPage<void>(
        child: child,
      );
    }
    return NoTransitionPage(
      key: isUniqueKey ? UniqueKey() : null,
      child: child,
    );
  }
}
