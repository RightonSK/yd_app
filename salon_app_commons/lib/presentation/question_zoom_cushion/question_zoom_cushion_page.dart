import 'package:flutter/material.dart';

import '../cushion/cushion_page.dart';
import 'question_zoom_cushion_model.dart';

class QuestionZoomCushionPage extends StatelessWidget {
  static const String route = '/question_zoom';

  const QuestionZoomCushionPage({
    Key? key,
    required this.appBar,
    required this.onTapChangePlan,
    required this.onTapReserveButton,
  }) : super(key: key);
  final PreferredSizeWidget appBar;
  final void Function(BuildContext context) onTapChangePlan;
  final void Function(BuildContext context)? onTapReserveButton;

  @override
  Widget build(BuildContext context) {
    return CushionPage<QuestionZoomCushionModel>(
      appBar: appBar,
      cushionModel: QuestionZoomCushionModel(),
      onTapChangePlanOnQuestionZoom: onTapChangePlan,
      onTapReserveButtonOnQuestionZoom: onTapReserveButton,
    );
  }
}
