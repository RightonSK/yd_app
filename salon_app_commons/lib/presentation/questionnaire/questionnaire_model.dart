import 'package:flutter/cupertino.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class QuestionnaireModel extends ChangeNotifier {
  final _userRepo = UserRepository();

  bool isLoading = false;

  EngineerAttribute? engineerAttribute;
  FlutterExperience? flutterExperience;
  TriggerToKnow? triggerToKnow;
  Purpose? purpose;
  JobSeekingStatus? jobSeekingStatus;

  TextEditingController otherCommentController = TextEditingController();

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void setEngineerAttribute(EngineerAttribute? engineerAttribute) {
    this.engineerAttribute = engineerAttribute;
    notifyListeners();
  }

  void setFlutterExperience(FlutterExperience? flutterExperience) {
    this.flutterExperience = flutterExperience;
    notifyListeners();
  }

  void setTriggerToKnow(TriggerToKnow? triggerToKnow) {
    this.triggerToKnow = triggerToKnow;
    notifyListeners();
  }

  void setPurpose(Purpose? purpose) {
    this.purpose = purpose;
    notifyListeners();
  }

  void setJobSeekingStatus(JobSeekingStatus? jobSeekingStatus) {
    this.jobSeekingStatus = jobSeekingStatus;
    notifyListeners();
  }

  bool get canSubmit {
    if (engineerAttribute == null) {
      return false;
    }

    if (flutterExperience == null) {
      return false;
    }

    if (triggerToKnow == null) {
      return false;
    }

    if (purpose == null) {
      return false;
    }

    if (jobSeekingStatus == null) {
      return false;
    }
    return true;
  }

  Future sendQuestionnaire() async {
    final engineerAttribute = this.engineerAttribute;
    final flutterExperience = this.flutterExperience;
    final triggerToKnow = this.triggerToKnow;
    final purpose = this.purpose;
    final jobSeekingStatus = this.jobSeekingStatus;

    if (engineerAttribute == null) {
      throw 'ITエンジニア経験をお聞かせください🙏';
    }

    if (flutterExperience == null) {
      throw 'Flutter経験をお聞かせください🙏';
    }

    if (triggerToKnow == null) {
      throw 'きっかけをお聞かせください🙏';
    }

    if (purpose == null) {
      throw '目的をお聞かせください🙏';
    }

    if (jobSeekingStatus == null) {
      throw '転職活動中かどうかをお聞かせください🙏';
    }
    // アンケート回答フラグON
    await _userRepo.updateQuestionnaireAnswered(
      engineerAttribute: engineerAttribute,
      flutterExperience: flutterExperience,
      triggerToKnow: triggerToKnow,
      purpose: purpose,
      otherCommentWhenJoining: otherCommentController.text,
      jobSeekingStatus: jobSeekingStatus,
    );
    await _userRepo.reloadUserState(
      firebaseUser: FirebaseAuth.instance.currentUser,
    );
  }
}

enum EngineerAttribute {
  newToEngineering,
  experiencedLessThan1Year,
  experienced1Year,
  experienced3Years,
  experienced5Years;

  String get label {
    switch (this) {
      case EngineerAttribute.newToEngineering:
        return 'ITエンジニア未経験';
      case EngineerAttribute.experiencedLessThan1Year:
        return '1年未満のITエンジニア経験がある';
      case EngineerAttribute.experienced1Year:
        return '1年以上のITエンジニア経験がある';
      case EngineerAttribute.experienced3Years:
        return '3年以上のITエンジニア経験がある';
      case EngineerAttribute.experienced5Years:
        return '5年以上のITエンジニア経験がある';
    }
  }
}

enum FlutterExperience {
  lessThan1Month,
  oneToSixMonths,
  sixMonthsToOneYear,
  oneToTwoYears,
  moreThanTwoYears;

  String get label {
    switch (this) {
      case FlutterExperience.lessThan1Month:
        return '1か月未満';
      case FlutterExperience.oneToSixMonths:
        return '1ヶ月〜6ヶ月';
      case FlutterExperience.sixMonthsToOneYear:
        return '6ヶ月〜1年';
      case FlutterExperience.oneToTwoYears:
        return '1年〜2年';
      case FlutterExperience.moreThanTwoYears:
        return '2年以上';
      default:
        return '';
    }
  }
}

enum TriggerToKnow {
  fromFlutterUnivYouTube,
  fromTensai,
  fromBonsai,
  foundWhileResearching,
  referral,
  others;

  String get label {
    switch (this) {
      case TriggerToKnow.fromFlutterUnivYouTube:
        return 'YouTube「Flutter大学」を見た';
      case TriggerToKnow.fromTensai:
        return 'YouTube「天才プログラマーKBOY」を見ていて知った';
      case TriggerToKnow.fromBonsai:
        return 'YouTube「凡才プログラマーKBOY」を見ていて知った';
      case TriggerToKnow.foundWhileResearching:
        return 'Flutterについて調べてたら出てきた';
      case TriggerToKnow.referral:
        return '知り合いが入っている';
      case TriggerToKnow.others:
        return 'その他';
    }
  }
}

enum Purpose {
  wantEngineerColleagues,
  useAtWork,
  wantToCreatePersonalApp,
  wantToCollaborate,
  wantToBecomeEngineerFromScratch,
  wantToImproveEngineeringSkills,
  others;

  String get label {
    switch (this) {
      case Purpose.wantEngineerColleagues:
        return 'エンジニア仲間が欲しいから';
      case Purpose.useAtWork:
        return '仕事で使うから';
      case Purpose.wantToCreatePersonalApp:
        return '個人アプリを作りたいから';
      case Purpose.wantToCollaborate:
        return '共同開発がしたいから';
      case Purpose.wantToBecomeEngineerFromScratch:
        return '未経験からエンジニア就職(転職)がしたいから';
      case Purpose.wantToImproveEngineeringSkills:
        return 'エンジニアとしてスキルを伸ばしたいから';
      case Purpose.others:
        return 'その他';
    }
  }
}

enum JobSeekingStatus {
  notLooking,
  looking,
  lookingForContractEmployment,
  both;

  String get label {
    switch (this) {
      case JobSeekingStatus.notLooking:
        return '正社員としての転職先も業務委託の仕事も探していない';
      case JobSeekingStatus.looking:
        return '正社員として転職を考えている';
      case JobSeekingStatus.lookingForContractEmployment:
        return '業務委託として仕事を探している';
      case JobSeekingStatus.both:
        return '正社員転職も興味あるし、業務委託の仕事も探している';
    }
  }
}
