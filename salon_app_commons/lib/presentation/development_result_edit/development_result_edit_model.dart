import 'package:flutter/material.dart';
import 'package:salon_app_commons/domain/development_result.dart';

class DevelopmentResultEditModel extends ChangeNotifier {
  DevelopmentResultEditModel(this._developmentResult);

  bool isProcessing = false;
  final DevelopmentResult? _developmentResult;

  late final titleController =
      TextEditingController(text: _developmentResult?.title ?? '')
        ..addListener(notifyListeners);
  late final urlController =
      TextEditingController(text: _developmentResult?.url ?? '')
        ..addListener(notifyListeners);
  late final descriptionController =
      TextEditingController(text: _developmentResult?.description ?? '')
        ..addListener(notifyListeners);

  void switchProcessing(bool value) {
    isProcessing = value;
    notifyListeners();
  }

  bool get validate {
    return titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        (Uri.tryParse(urlController.text)?.hasAbsolutePath ?? false);
  }

  void registerDevelopmentResult(BuildContext context) {
    if (validate) {
      Navigator.of(context).pop(
        DevelopmentResult(
          title: titleController.text,
          description: descriptionController.text
              .trim()
              .replaceAll(RegExp(r'(\n){3,}'), "\n\n"),
          url: urlController.text,
        ),
      );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    urlController.dispose();
    super.dispose();
  }
}
