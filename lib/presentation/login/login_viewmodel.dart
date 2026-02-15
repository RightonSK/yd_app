import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yd_app/data/repositories/auth_repository.dart';
import 'package:yd_app/domain/entities/user.dart';

class LoginState {
  final String userId;
  final String password;
  final bool isLoading;
  final String? errorMessage;
  final User? loggedInUser;

  const LoginState({
    this.userId = '',
    this.password = '',
    this.isLoading = false,
    this.errorMessage,
    this.loggedInUser,
  });

  LoginState copyWith({
    String? userId,
    String? password,
    bool? isLoading,
    String? errorMessage,
    User? loggedInUser,
  }) {
    return LoginState(
      userId: userId ?? this.userId,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      loggedInUser: loggedInUser ?? this.loggedInUser,
    );
  }
}

class LoginViewModel extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  void setUserId(String value) {
    state = state.copyWith(userId: value);
  }

  void setPassword(String value) {
    state = state.copyWith(password: value);
  }

  Future<bool> login() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final repo = ref.read(authRepositoryProvider);
    final user = await repo.login(state.userId, state.password);

    if (user != null) {
      state = state.copyWith(isLoading: false, loggedInUser: user);
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'ユーザーIDまたはパスワードが正しくありません',
      );
      return false;
    }
  }
}

final loginViewModelProvider =
    NotifierProvider<LoginViewModel, LoginState>(LoginViewModel.new);
