import 'dart:typed_data';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:async';

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

/// Web用ファイル選択ユーティリティ
class FilePickerUtils {
  /// ファイル選択ダイアログを表示
  static Future<FilePickerResult?> selectFile() async {
    try {
      final completer = Completer<FilePickerResult?>();
      
      // HTMLファイル入力要素を作成
      final input = html.FileUploadInputElement();
      input.accept = 'image/jpeg,image/png,image/webp'; // Gemini対応画像形式のみ
      input.multiple = false;

      input.onChange.listen((e) async {
        final files = input.files;
        if (files == null || files.isEmpty) {
          completer.complete(null);
          return;
        }

        final file = files[0];
        final reader = html.FileReader();

        reader.onLoadEnd.listen((e) {
          final bytes = reader.result as Uint8List;
          completer.complete(FilePickerResult(
            name: file.name,
            bytes: bytes,
            size: file.size,
          ));
        });

        reader.onError.listen((e) {
          completer.completeError(Exception('ファイル読み込みエラー'));
        });

        reader.readAsArrayBuffer(file);
      });

      // キャンセル時の処理（5秒後にタイムアウト）
      Timer(const Duration(seconds: 5), () {
        if (!completer.isCompleted) {
          completer.complete(null);
        }
      });

      // ファイル選択ダイアログを開く
      input.click();

      return await completer.future;
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