import 'package:flutter/material.dart';
import 'package:salon_app_commons/presentation/cushion/cushion_page.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

import 'morning_gather_model.dart';

class MorningGatherPage extends StatelessWidget {
  static const String route = '/morning_gather';

  const MorningGatherPage({
    required this.appBar,
    Key? key,
  }) : super(key: key);

  final PreferredSizeWidget appBar;

  @override
  Widget build(BuildContext context) {
    return CushionPage<MorningGatherModel>(
      appBar: appBar,
      cushionModel: MorningGatherModel(),
      backgroundColor: morningYellowColor,
    );
  }
}
