import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

/// ファイル選択結果
class FilePickerResult {
  final String name;
  final Uint8List bytes;
  final int size;

  FilePickerResult({
    required this.name,
    required this.bytes,
    required this.size,
  });
}

/// モバイル用ファイル選択ユーティリティ
class FilePickerUtils {
  /// ファイル選択ダイアログを表示
  static Future<FilePickerResult?> selectFile() async {
    try {
      final picker = ImagePicker();
      
      // モバイルでは画像のみサポート（動画は複雑になるため）
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80, // 圧縮して容量を抑える
      );

      if (pickedFile == null) {
        return null;
      }

      final bytes = await pickedFile.readAsBytes();
      
      return FilePickerResult(
        name: pickedFile.name,
        bytes: bytes,
        size: bytes.length,
      );
    } catch (e) {
      throw Exception('ファイル選択エラー: $e');
    }
  }

  /// ファイルタイプを検証（Gemini対応画像形式のみ）
  static bool validateFileType(String fileName) {
    final extension = fileName.toLowerCase().split('.').last;
    const allowedExtensions = [
      'jpg', 'jpeg', 'png', 'webp', // Gemini対応画像形式のみ
    ];
    return allowedExtensions.contains(extension);
  }

  /// ファイルサイズを検証（最大10MB）
  static bool validateFileSize(Uint8List fileBytes) {
    const maxSizeInBytes = 10 * 1024 * 1024; // 10MB
    return fileBytes.length <= maxSizeInBytes;
  }

  /// ファイル拡張子から画像かどうかを判定
  static bool isImageFile(String fileName) {
    final extension = fileName.toLowerCase().split('.').last;
    const imageExtensions = ['jpg', 'jpeg', 'png', 'webp']; // Gemini対応形式のみ
    return imageExtensions.contains(extension);
  }
}