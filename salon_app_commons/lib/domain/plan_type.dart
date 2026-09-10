enum PlanType {
  training,
  trainingLight,
  aiTraining,
  community,
  learning,
  free;

  String get displayName {
    switch (this) {
      case PlanType.free:
        return '無料プラン';
      case PlanType.community:
        return 'コミュニティプラン';
      case PlanType.learning:
        return '課題学習プラン';
      case PlanType.trainingLight:
        return 'ライト修行プラン';
      case PlanType.training:
        return '修行プラン';
      case PlanType.aiTraining:
        return 'AI修行プラン';
    }
  }

  String? get revenueCatId {
    switch (this) {
      case PlanType.community:
        return 'flutteruniv_community_1m';
      case PlanType.learning:
        return 'flutteruniv_learning_1m';
      case PlanType.trainingLight:
        return 'flutteruniv_traininglight_1m';
      case PlanType.training:
        return 'flutteruniv_training_1m';
      case PlanType.aiTraining:
        return 'flutteruniv_aitraining_1m';
      case PlanType.free:
        return null;
    }
  }

  int get nativeAmount {
    switch (this) {
      case PlanType.community:
        return 3000;
      case PlanType.learning:
        return 6000;
      case PlanType.trainingLight:
      case PlanType.aiTraining:
        return 12000;
      case PlanType.training:
        return 15400;
      case PlanType.free:
        return 0;
    }
  }

  String get descriptionForNative {
    switch (this) {
      case PlanType.community:
        return 'Slackに参加 / GitHubの閲覧 / 共同開発 / グループ勉強会 / アーカイブ動画 / 交流会に参加可能';
      case PlanType.learning:
        return 'コミュニティプランの内容に加えて、限定教材を閲覧可能';
      case PlanType.trainingLight:
        return '課題学習プランの内容に加えて、質問zoomに月4回参加可';
      case PlanType.training:
        return '課題学習プランの内容に加えて、質問zoomで質問し放題 / Githubのissueで質問し放題 / 月１のマンツーマン';
      case PlanType.aiTraining:
        return '課題学習プランの内容に加えて、AI質問チャットが使い放題 / 必要に応じて人間の講師もサポート';
      case PlanType.free:
        return '';
    }
  }

  String get imageURLForNative {
    switch (this) {
      case PlanType.community:
        return 'https://blog.flutteruniv.com/wp-content/uploads/2023/03/online_nomikai_man.png';
      case PlanType.learning:
        return 'https://blog.flutteruniv.com/wp-content/uploads/2023/03/computer_tokui_boy.png';
      case PlanType.trainingLight:
        return 'https://blog.flutteruniv.com/wp-content/uploads/2023/08/sushi_school.png';
      case PlanType.training:
        return 'https://blog.flutteruniv.com/wp-content/uploads/2023/03/taki_syugyou.png';
      case PlanType.aiTraining:
        return 'https://blog.flutteruniv.com/wp-content/uploads/2025/06/ChatGPT-Image-2025%E5%B9%B46%E6%9C%8822%E6%97%A5-15_33_49.png';
      case PlanType.free:
        return '';
    }
  }

  static PlanType fromRevenueCatId(String? id) {
    return PlanType.values.firstWhere((element) => element.revenueCatId == id);
  }

  bool get isPaid {
    return this != PlanType.free;
  }

  bool get isLearningOrHigher {
    return this == PlanType.learning ||
        this == PlanType.trainingLight ||
        this == PlanType.training ||
        this == PlanType.aiTraining;
  }
}
