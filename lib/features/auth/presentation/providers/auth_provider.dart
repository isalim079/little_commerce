import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_commerce/features/auth/data/repositories/auth_repository.dart';

// Auth states
enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final String? errorMessage;

  const AuthState({
    required this.status,
    this.errorMessage,
  });

  // Initial state
  const AuthState.initial()
      : status = AuthStatus.initial,
        errorMessage = null;

  // CopyWith — creates new state with updated fields
  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// The provider
final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  () => AuthNotifier(),
);

class AuthNotifier extends Notifier<AuthState> {
  final _repository = AuthRepository();

  @override
  AuthState build() {
    return const AuthState.initial();
  }

  // Check token on app start
  Future<void> checkAuthStatus() async {
    state = state.copyWith(status: AuthStatus.loading);

    final isLoggedIn = await _repository.isLoggedIn();

    state = state.copyWith(
      status: isLoggedIn
          ? AuthStatus.authenticated
          : AuthStatus.unauthenticated,
    );
  }

  // Login
  Future<void> login({
    required String username,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    final response = await _repository.login(
      username: username,
      password: password,
    );

    if (response.isSuccess) {
      state = state.copyWith(status: AuthStatus.authenticated);
    } else {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: response.error,
      );
    }
  }

  // Logout
  Future<void> logout() async {
    await _repository.logout();
    state = state.copyWith(status: AuthStatus.unauthenticated);
  }
}