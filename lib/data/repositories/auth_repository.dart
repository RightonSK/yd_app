import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yd_app/data/datasources/auth_mock_api.dart';
import 'package:yd_app/domain/entities/user.dart';

class AuthRepository {
  final AuthMockApi _api = AuthMockApi();

  Future<User?> login(String userId, String password) {
    return _api.login(userId, password);
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});
