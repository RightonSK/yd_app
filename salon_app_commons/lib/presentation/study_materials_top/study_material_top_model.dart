import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

import '../web_top/web_top_model.dart';

class StudyMaterialsTopModel extends ChangeNotifier {
  final videoRepo = VideoRepository();
  final sampleCodeRepo = SampleCodesRepository();

  // 全部格納しておく
  List<Video> _allLectureVideos = [];
  List<Video> _allClipVideos = [];
  List<Video> _allPresentationVideos = [];

  // filterされる可能性もあるやつ
  List<Video> lectureVideos = [];
  List<Video> clipVideos = [];
  List<Video> presentationVideos = [];

  List<SampleCode>? sampleCodes;

  bool isPaidError = false;

  Future init(BuildContext context) async {
    await fetchSampleCodes();
    await fetchStudyMaterialChapterList(context);
  }

  Future fetchSampleCodes() async {
    sampleCodes = await sampleCodeRepo.fetchAll();
  }

  Future fetchStudyMaterialChapterList(BuildContext context) async {
    _allLectureVideos = await videoRepo.fetchLectureVideos();
    _allClipVideos = await videoRepo.fetchClipVideos();
    _allPresentationVideos = await videoRepo.fetchPresentationVideos();
    _setAllVideos();

    final subscription = context.read<WebTopModel>().subscription!;
    isPaidError = subscription.isErrorStatus;

    notifyListeners();
  }

  void _setAllVideos() {
    lectureVideos = _allLectureVideos;
    clipVideos = _allClipVideos;
    presentationVideos = _allPresentationVideos;
  }

  void filterByKeyword(String keyword) {
    if (keyword.isEmpty) {
      _setAllVideos();
      notifyListeners();
      return;
    }

    final lowercaseKeyword = keyword.toLowerCase();
    logger.d('lowercaseKeyword: $lowercaseKeyword');

    final filtered = _allLectureVideos.where((material) {
      final title = material.title;
      final lowercaseTitle = title.toLowerCase();
      return lowercaseTitle.contains(lowercaseKeyword);
    }).toList();
    lectureVideos = filtered;

    final filtered2 = _allClipVideos.where((material) {
      final title = material.title;
      final lowercaseTitle = title.toLowerCase();
      return lowercaseTitle.contains(lowercaseKeyword);
    }).toList();
    clipVideos = filtered2;

    final filtered3 = _allPresentationVideos.where((material) {
      final title = material.title;
      final lowercaseTitle = title.toLowerCase();
      return lowercaseTitle.contains(lowercaseKeyword);
    }).toList();
    presentationVideos = filtered3;

    notifyListeners();
  }
}
