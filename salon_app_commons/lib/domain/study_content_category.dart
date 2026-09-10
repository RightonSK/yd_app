enum StudyContentCategory {
  material,
  illustration,
  blog,
  clip,
  studyMeeting,
  presentation,
  zenn,
  sampleCodes;

  static const Map labels = {
    StudyContentCategory.material: '教材',
    StudyContentCategory.illustration: 'イラスト教材',
    StudyContentCategory.clip: '質問切り抜き',
    StudyContentCategory.studyMeeting: '勉強会',
    StudyContentCategory.presentation: '発表会',
    StudyContentCategory.blog: '週刊Flutter大学',
    StudyContentCategory.zenn: 'Zennの『Flutter』フィード',
    StudyContentCategory.sampleCodes: 'サンプルコード',
  };
  static const Map urlPaths = {
    StudyContentCategory.material: 'materials',
    StudyContentCategory.illustration: 'illustration',
    StudyContentCategory.clip: 'clip_videos',
    StudyContentCategory.studyMeeting: 'lecture_videos',
    StudyContentCategory.presentation: 'presentation_videos',
    StudyContentCategory.blog: 'blogs',
    StudyContentCategory.zenn: 'zenn',
    StudyContentCategory.sampleCodes: 'sample_codes',
  };

  String get label => labels[this];
  String get urlPath => urlPaths[this];

  operator [](String key) =>
      StudyContentCategory.values.firstWhere((e) => e.name == key);
}
