import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

import '../cushion/cushion_page.dart';
import 'party_zoom_cushion_model.dart';

class PartyZoomCushionPage extends StatelessWidget {
  static const String route = '/party_zoom';

  const PartyZoomCushionPage({
    Key? key,
    required this.appBar,
  }) : super(key: key);
  final PreferredSizeWidget appBar;

  @override
  Widget build(BuildContext context) {
    return CushionPage<PartyZoomCushionModel>(
      appBar: appBar,
      cushionModel: PartyZoomCushionModel(),
      backgroundColor: primaryYellowColor,
    );
  }
}
