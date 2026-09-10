import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:fluttericon/typicons_icons.dart';

import '../salon_app_commons.dart';

enum UserBadge {
  // 年数系
  oneMonthContinue,
  threeMonthContinue,
  halfYearContinue,
  oneYearContinue,
  twoYearContinue,
  threeYearContinue,
  fourYearContinue,
  fiveYearContinue,

  // 発表系
  joinJointDev,
  presentationStudyMeeting,
  presentationPersonalDevZoom,
  joinQuestionZoom,
  joinStudyMeeting,
  joinPartyZoom,
  joinPersonalDevZoom,
  joinGather,

  // オフライン
  goFlutterHouse,
  goShigaBesso,
  goTokyoParty,
  goSapporoParty,
  goSendaiParty,
  goNagoyaParty,
  goOsakaParty,
  goFukuokaParty,
  goOkinawaParty,

  // achievement
  wonTheHackathon,

  // ??
  secret;

  String get nameJP {
    switch (this) {
      case UserBadge.oneMonthContinue:
        return '1ヶ月継続';
      case UserBadge.threeMonthContinue:
        return '3ヶ月継続';
      case UserBadge.halfYearContinue:
        return '半年継続';
      case UserBadge.oneYearContinue:
        return '1年継続';
      case UserBadge.twoYearContinue:
        return '2年継続';
      case UserBadge.threeYearContinue:
        return '3年継続';
      case UserBadge.fourYearContinue:
        return '4年継続';
      case UserBadge.fiveYearContinue:
        return '5年継続';

      case UserBadge.joinJointDev:
        return '共同開発に参加';
      case UserBadge.presentationStudyMeeting:
        return '共同勉強会で発表';
      case UserBadge.presentationPersonalDevZoom:
        return '個人開発発表会\nで発表';
      case UserBadge.joinQuestionZoom:
        return '質問Zoomに参加';
      case UserBadge.joinStudyMeeting:
        return '共同勉強会に参加';
      case UserBadge.joinPartyZoom:
        return 'オンライン交流会\nに参加';
      case UserBadge.joinPersonalDevZoom:
        return '個人開発発表会\nに参加';
      case UserBadge.joinGather:
        return 'Gatherに入る';

      case UserBadge.goFlutterHouse:
        return 'フラハ恵比寿に訪問';
      case UserBadge.goShigaBesso:
        return '滋賀の別荘に訪問';
      case UserBadge.goTokyoParty:
        return '東京オフ会に参加';
      case UserBadge.goSapporoParty:
        return '札幌オフ会に参加';
      case UserBadge.goSendaiParty:
        return '仙台オフ会に参加';
      case UserBadge.goNagoyaParty:
        return '名古屋オフ会に参加';
      case UserBadge.goOsakaParty:
        return '大阪オフ会に参加';
      case UserBadge.goFukuokaParty:
        return '福岡オフ会に参加';
      case UserBadge.goOkinawaParty:
        return '沖縄オフ会に参加';

      case UserBadge.wonTheHackathon:
        return 'ハッカソン優勝';

      case UserBadge.secret:
        return 'Coming soon';
    }
  }

  IconData get icon {
    switch (this) {
      case UserBadge.oneMonthContinue:
        return Icons.timelapse;
      case UserBadge.threeMonthContinue:
        return Icons.timelapse;
      case UserBadge.halfYearContinue:
        return Icons.timelapse;
      case UserBadge.oneYearContinue:
        return Icons.timelapse;
      case UserBadge.twoYearContinue:
        return Icons.timelapse;
      case UserBadge.threeYearContinue:
        return Icons.timelapse;
      case UserBadge.fourYearContinue:
        return Icons.timelapse;
      case UserBadge.fiveYearContinue:
        return Icons.timelapse;

      case UserBadge.joinJointDev:
        return Icons.people_outline_outlined;
      case UserBadge.presentationStudyMeeting:
        return Icons.record_voice_over;
      case UserBadge.presentationPersonalDevZoom:
        return Icons.record_voice_over;
      case UserBadge.joinQuestionZoom:
        return Icons.code;
      case UserBadge.joinStudyMeeting:
        return Icons.hearing;
      case UserBadge.joinPartyZoom:
        return Typicons.beer;
      case UserBadge.joinPersonalDevZoom:
        return Icons.hearing;
      case UserBadge.joinGather:
        return Icons.work;

      case UserBadge.goFlutterHouse:
        return Icons.home;
      case UserBadge.goShigaBesso:
        return Icons.water_damage_outlined;
      case UserBadge.goTokyoParty:
        return Icons.cell_tower;
      case UserBadge.goSapporoParty:
        return RpgAwesome.fish;
      case UserBadge.goSendaiParty:
        return RpgAwesome.meat;
      case UserBadge.goNagoyaParty:
        return RpgAwesome.roast_chicken;
      case UserBadge.goOsakaParty:
        return FontAwesome5.glasses;
      case UserBadge.goFukuokaParty:
        return Icons.ramen_dining;
      case UserBadge.goOkinawaParty:
        return FontAwesome5.umbrella_beach;

      case UserBadge.wonTheHackathon:
        return Icons.emoji_events;

      case UserBadge.secret:
        return Icons.help;
    }
  }

  Color get color {
    switch (this) {
      case UserBadge.oneMonthContinue:
        return const Color(0xFF49b675);
      case UserBadge.threeMonthContinue:
        return const Color(0xFFfc9303);
      case UserBadge.halfYearContinue:
        return const Color(0xFF9c5221);
      case UserBadge.oneYearContinue:
        return const Color(0xFF9a9a9a);
      case UserBadge.twoYearContinue:
        return const Color(0xFFd4af37);
      case UserBadge.threeYearContinue:
        return const Color(0xFFd0f6ff);
      case UserBadge.fourYearContinue:
        return const Color(0xFFc70067); // ルビーレッド
      case UserBadge.fiveYearContinue:
        return const Color(0xFF0068b7); // サファイアブルー

      case UserBadge.joinJointDev:
        return const Color(0xFFd4af37);
      case UserBadge.presentationStudyMeeting:
        return const Color(0xFFd4af37);
      case UserBadge.presentationPersonalDevZoom:
        return const Color(0xFFd4af37);
      case UserBadge.joinQuestionZoom:
        return primaryNavyColor;
      case UserBadge.joinStudyMeeting:
        return primaryNavyColor;
      case UserBadge.joinPartyZoom:
        return primaryNavyColor;
      case UserBadge.joinPersonalDevZoom:
        return primaryNavyColor;
      case UserBadge.joinGather:
        return primaryNavyColor;

      case UserBadge.goFlutterHouse:
        return const Color(0xFFd4af37);
      case UserBadge.goShigaBesso:
        return const Color(0xFFd4af37);
      case UserBadge.goTokyoParty:
        return Colors.red;
      case UserBadge.goSapporoParty:
        return const Color(0xFFd4af37);
      case UserBadge.goSendaiParty:
        return const Color(0xFFd4af37);
      case UserBadge.goNagoyaParty:
        return const Color(0xFFd4af37);
      case UserBadge.goOsakaParty:
        return const Color(0xFFd4af37);
      case UserBadge.goFukuokaParty:
        return const Color(0xFFd4af37);
      case UserBadge.goOkinawaParty:
        return const Color(0xFFd4af37);

      case UserBadge.wonTheHackathon:
        return const Color(0xFFd4af37);

      case UserBadge.secret:
        return const Color(0xFFFFFFFF);
    }
  }

  static UserBadge? getContinueBadge(DateTime createdAt) {
    final allBadges = getAllContinueBadges(createdAt);
    return allBadges.lastOrNull;
  }

  static List<UserBadge> getAllContinueBadges(DateTime createdAt) {
    final duration = DateTime.now().difference(createdAt);
    final sec = duration.inSeconds;

    const secPerMin = 60;
    const secPerHour = secPerMin * 60;
    const secPerDay = secPerHour * 24;
    const sec1Month = secPerDay * 30;
    const secPerYear = secPerDay * 365;

    List<UserBadge> badges = [];

    if (sec >= sec1Month) {
      badges.add(UserBadge.oneMonthContinue);
    }

    if (sec >= sec1Month * 3) {
      badges.add(UserBadge.threeMonthContinue);
    }

    if (sec >= sec1Month * 6) {
      badges.add(UserBadge.halfYearContinue);
    }

    if (sec >= secPerYear) {
      badges.add(UserBadge.oneYearContinue);
    }

    if (sec >= secPerYear * 2) {
      badges.add(UserBadge.twoYearContinue);
    }

    if (sec >= secPerYear * 3) {
      badges.add(UserBadge.threeYearContinue);
    }

    if (sec >= secPerYear * 4) {
      badges.add(UserBadge.fourYearContinue);
    }

    if (sec >= secPerYear * 5) {
      badges.add(UserBadge.fiveYearContinue);
    }
    return badges;
  }
}
