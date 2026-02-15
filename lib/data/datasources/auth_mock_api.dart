import 'package:yd_app/domain/entities/user.dart';

class AuthMockApi {
  Future<User?> login(String userId, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // モックユーザーデータ
    const mockUsers = {
      'user001': 'password001',
      'user002': 'password002',
      'user003': 'password003',
    };

    if (mockUsers[userId] == password) {
      return User(id: userId, name: '販売員_$userId');
    }
    return null;
  }
}
