import '../utils/format_utils.dart';

enum FUTReasons {
  jointDev1st,
  jointDev2nd,
  jointDev3rd,
  jointDev4th,
  jointDev5th,

  presentationStudyMeeting,
  joinStudyMeeting,

  presentationPersonalDevMeeting,
  joinPersonalDevMeeting,

  joinPartyMeeting,

  joinMorningGather,

  clipVideo,
  viewAd,
  madeSlackTimes,
  invite,
  invited,
  mentor1on1,
  addUserToVideo,

  present,
  giftFromMember,
  adjust,

  exchangeToSticker, //　ステッカーに消費
  exchangeToMagCup, //　マグカップに消費
  exchangeToTShirt, //　Tシャツに消費
  exchangeToBook, //　本に消費
  exchangeTo2025Calendar; // 2025年カレンダーに消費

  int? get futAmount {
    switch (this) {
      case FUTReasons.jointDev1st:
        return 1000;
      case FUTReasons.jointDev2nd:
        return 500;
      case FUTReasons.jointDev3rd:
        return 300;
      case FUTReasons.jointDev4th:
        return 200;
      case FUTReasons.jointDev5th:
        return 100;
      case FUTReasons.presentationStudyMeeting:
        return 500;
      case FUTReasons.joinStudyMeeting:
        return 50;
      case FUTReasons.presentationPersonalDevMeeting:
        return 250;
      case FUTReasons.joinPersonalDevMeeting:
        return 50;
      case FUTReasons.joinPartyMeeting:
        return 50;
      case FUTReasons.joinMorningGather:
        return 10;
      case FUTReasons.clipVideo:
        return 50;
      case FUTReasons.viewAd:
        return 1;
      case FUTReasons.madeSlackTimes:
        return 50;
      case FUTReasons.invite:
        return 200;
      case FUTReasons.invited:
        return 100;
      case FUTReasons.mentor1on1:
        return 100;
      case FUTReasons.addUserToVideo:
        return 10;
      case FUTReasons.present:
        return null;
      case FUTReasons.giftFromMember:
        return null;
      case FUTReasons.exchangeToTShirt:
        return -3000;
      case FUTReasons.exchangeToBook:
        return -3000;
      case FUTReasons.exchangeToMagCup:
        return -1000;
      case FUTReasons.exchangeToSticker:
        return -500;
      case FUTReasons.exchangeTo2025Calendar:
        return -300;
      case FUTReasons.adjust:
        return null;
    }
  }

  @override
  String toString() => FormatUtils.camelCaseToSnakeCase(name);
}
