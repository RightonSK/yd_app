import 'package:flutter/material.dart';

import '../cushion/cushion_page.dart';
import 'personal_dev_zoom_model.dart';

class PersonalDevZoomPage extends StatelessWidget {
  static const String route = '/personal_dev_zoom';

  const PersonalDevZoomPage({
    Key? key,
    required this.appBar,
  }) : super(key: key);
  final PreferredSizeWidget appBar;

  @override
  Widget build(BuildContext context) {
    return CushionPage<PersonalDevZoomModel>(
      appBar: appBar,
      cushionModel: PersonalDevZoomModel(),
    );
  }
}
