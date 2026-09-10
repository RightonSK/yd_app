import 'package:flutter/material.dart';

import '../cushion/cushion_page.dart';
import 'study_meeting_cushion_model.dart';

class StudyMeetingCushionPage extends StatelessWidget {
  static const String route = '/study_meeting';

  const StudyMeetingCushionPage({
    Key? key,
    required this.appBar,
  }) : super(key: key);
  final PreferredSizeWidget appBar;

  @override
  Widget build(BuildContext context) {
    return CushionPage<StudyMeetingCushionModel>(
      appBar: appBar,
      cushionModel: StudyMeetingCushionModel(),
    );
  }
}
