import 'package:flutter/material.dart';
import 'package:salon_app_commons/presentation/gather_cushion/gather_model.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

import '../cushion/cushion_page.dart';

class GatherCushionPage extends StatelessWidget {
  static const String route = '/gather';

  const GatherCushionPage({
    Key? key,
    required this.appBar,
  }) : super(key: key);

  final PreferredSizeWidget appBar;

  @override
  Widget build(BuildContext context) {
    return CushionPage<GatherModel>(
      appBar: appBar,
      backgroundColor: gatherPurpleColor,
      cushionModel: GatherModel(),
    );
  }
}
