import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// Removed complex cropper settings - using simple crop_your_image widget

Future<Uint8List?> pickPhotoFile(BuildContext context) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  return pickedFile?.readAsBytes();
}
