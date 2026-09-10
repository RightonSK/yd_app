import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

import '../study_materials_top/study_material_top_page.dart';
import '../welcome/welcome_page.dart';

const String kGoogleToken = String.fromEnvironment('googleToken');
const String kCalendarId = String.fromEnvironment('googleCalendarId');

enum WebTopMenu {
  feed,
  studyMaterialsTop,
  community,
  myPage,
  welcome,
  ;

  String get route {
    switch (this) {
      case WebTopMenu.welcome:
        return WelcomePage.route;
      case WebTopMenu.feed:
        return FeedPage.route;
      case WebTopMenu.community:
        return CommunityPage.route;
      case WebTopMenu.studyMaterialsTop:
        return StudyMaterialsTopPage.route;
      case WebTopMenu.myPage:
        return MyPage.route;
    }
  }

  Widget page() {
    switch (this) {
      case WebTopMenu.welcome:
        return const WelcomePage();
      case WebTopMenu.feed:
        return const FeedPage(
          googleToken: kGoogleToken,
          calendarId: kCalendarId,
        );
      case WebTopMenu.community:
        return const CommunityPage();
      case WebTopMenu.studyMaterialsTop:
        return const StudyMaterialsTopPage();
      case WebTopMenu.myPage:
        return MemberDetailPage(
          tabName: 'profile',
          onTapLinkToMap: (prefecture) async {
            // FIXME: For web, show a dialog instead of opening map
          },
        );
    }
  }

  String get label {
    switch (this) {
      case WebTopMenu.welcome:
        return 'はじめての方へ';
      case WebTopMenu.feed:
        return 'フィード';
      case WebTopMenu.community:
        return 'コミュニティ';
      case WebTopMenu.studyMaterialsTop:
        return '学習';
      case WebTopMenu.myPage:
        return 'マイページ';
    }
  }

  IconData get icon {
    switch (this) {
      case WebTopMenu.welcome:
        return Icons.child_care_outlined;
      case WebTopMenu.feed:
        return Icons.feed_outlined;
      case WebTopMenu.community:
        return Icons.people_outline;
      case WebTopMenu.studyMaterialsTop:
        return Icons.school_outlined;
      case WebTopMenu.myPage:
        return Icons.person_outline;
    }
  }

  IconData get selectedIcon {
    switch (this) {
      case WebTopMenu.welcome:
        return Icons.child_care;
      case WebTopMenu.feed:
        return Icons.feed;
      case WebTopMenu.community:
        return Icons.people;
      case WebTopMenu.studyMaterialsTop:
        return Icons.school;
      case WebTopMenu.myPage:
        return Icons.person;
    }
  }

  static List<WebTopMenu> valuesForMenu(bool isNew) {
    if (isNew) {
      return WebTopMenu.values;
    }
    // それ以外は末尾の要素を省く
    return WebTopMenu.values.sublist(0, WebTopMenu.values.length - 1);
  }
}
