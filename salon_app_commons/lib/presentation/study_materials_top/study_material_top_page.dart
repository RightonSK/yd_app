import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

import 'books_card.dart';
import 'free_materials_card.dart';
import 'sample_codes_card.dart';
import 'study_material_multi_card.dart';
import 'study_material_top_model.dart';

class StudyMaterialsTopPage extends StatelessWidget {
  static const String route = '/materials';

  const StudyMaterialsTopPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StudyMaterialsTopModel>(
      create: (_) => StudyMaterialsTopModel()..init(context),
      builder: (context, child) {
        return Scaffold(
          body: Consumer<StudyMaterialsTopModel>(builder: (context, model, child) {
            final clipVideos = model.clipVideos;
            final lectureVideos = model.lectureVideos;
            final presentationVideos = model.presentationVideos;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    FutureBuilder<bool>(
                      future: PermissionUtils.hasCalendlyPermission(),
                      builder: (context, snapshot) {
                        if (snapshot.data == true) {
                          return const StudyScheduleCard();
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const StudyQuestionChatCard(),
                    const StudyMentorPlanCard(),
                    const SizedBox(height: 8),
                    const FreeMaterialsCard(),
                    const BooksCard(),
                    const SampleCodesCard(),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: "検索したい動画のキーワードを入力",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (text) {
                          model.filterByKeyword(text);
                        },
                      ),
                    ),
                    if (clipVideos.isNotEmpty)
                      StudyMaterialMultiCard(
                        id: 'clip_videos',
                        title: '質問zoom切り抜き',
                        description: '質問zoomを質問ごとに切り抜いた動画です',
                        videos: clipVideos,
                      ),
                    if (lectureVideos.isNotEmpty)
                      StudyMaterialMultiCard(
                        id: 'lecture_videos',
                        title: '共同勉強会',
                        description: '毎週水曜日に開催されている共同勉強会の過去動画です',
                        videos: lectureVideos,
                      ),
                    if (presentationVideos.isNotEmpty)
                      StudyMaterialMultiCard(
                        id: 'presentation_videos',
                        title: '発表会',
                        description: '個人開発や共同開発の発表会の過去動画です',
                        videos: presentationVideos,
                      ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class StudyScheduleCard extends StatelessWidget {
  const StudyScheduleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          context.go(SchedulePage.route);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: themeNavy.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.calendar_month,
                  size: 32,
                  color: themeNavy,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'kboyへの質問Zoom予約',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '【2025年6月までの修行プランの方向け】kboyへの質問zoomの予約はこちらから',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: themeNavy,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StudyQuestionChatCard extends StatelessWidget {
  const StudyQuestionChatCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          context.go(QuestionChatListPage.route);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: themeNavy.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.smart_toy,
                  size: 32,
                  color: themeNavy,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AI質問チャット',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'AI修行プランで利用可能',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: themeNavy,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StudyMentorPlanCard extends StatelessWidget {
  const StudyMentorPlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          context.go(MentorPlanListPage.route);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: themeNavy.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.school,
                  size: 32,
                  color: themeNavy,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'メンターに相談',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Flutter大学のメンバー同士で相談できる機能です。',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: themeNavy,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
