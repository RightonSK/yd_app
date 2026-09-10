import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import '../utils/log_utils.dart';

/// ストレージ
class StorageRepository {
  static StorageRepository? _instance;
  StorageRepository._();
  factory StorageRepository() {
    return _instance ??= StorageRepository._();
  }

  final _storage = FirebaseStorage.instance;

  /// バイナリをアップロードする
  Future<String> uploadData(String path, Uint8List data) async {
    final snapshot = await _storage.ref(path).putData(data);
    final url = await snapshot.ref.getDownloadURL();
    return url.toString();
  }

  /// ファイルを削除する
  Future delete(String path) async {
    try {
      await _storage.ref(path).delete();
    } catch (e) {
      // do nothing
      logger.d(e);
    }
  }
}
