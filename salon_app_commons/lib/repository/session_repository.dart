import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// セッションを操作する
class SessionRepository {
  static SessionRepository? _instance;
  SessionRepository._();
  static SessionRepository get instance {
    return _instance ??= SessionRepository._();
  }

  /// 保存する
  Future<bool> set(
    String key,
    dynamic value, {
    String prefix = '',
  }) async {
    final absKey = '$prefix.$key';
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      return await prefs.setBool(absKey, value);
    } else if (value is int) {
      return await prefs.setInt(absKey, value);
    } else if (value is double) {
      return await prefs.setDouble(absKey, value);
    } else if (value is String) {
      return await prefs.setString(absKey, value);
    } else if (value is List<String>) {
      return await prefs.setStringList(absKey, value);
    } else if (value is List<Map<String, dynamic>>) {
      List<String> jsons = value.map((map) => jsonEncode(map)).toList();
      return await prefs.setStringList('$absKey.mapList', jsons);
    }
    return false;
  }

  /// 取得する
  Future<T> get<T>(
    String key, {
    String prefix = '',
    required T defaultValue,
  }) async {
    final absKey = '$prefix.$key';
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('$absKey.mapList')) {
      List<String> jsons = prefs.getStringList('$absKey.mapList') ?? [];
      return jsons
          .map((json) => jsonDecode(json) as Map<String, dynamic>)
          .toList() as T;
    }
    final value = prefs.get(absKey) as T;
    return value ?? defaultValue;
  }

  /// 削除する
  Future<bool> remove(String prefix) async {
    final prefs = await SharedPreferences.getInstance();
    for (final key in prefs.getKeys().toList()) {
      if (key.contains(prefix, 0)) {
        if (!await prefs.remove(key)) {
          return false;
        }
      }
    }
    return true;
  }

  /// すべてクリアする
  Future<bool> clear() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }
}
