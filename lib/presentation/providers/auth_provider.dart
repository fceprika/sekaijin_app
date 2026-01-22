import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errors/failures.dart';
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';

// Services
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final apiServiceProvider = Provider<ApiService>((ref) {
  final authService = ref.watch(authServiceProvider);
  return ApiService(authService);
});

// Datasources
final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AuthRemoteDatasourceImpl(apiService.dio);
});

// Repositories
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDatasource = ref.watch(authRemoteDatasourceProvider);
  final authService = ref.watch(authServiceProvider);
  return AuthRepositoryImpl(remoteDatasource, authService);
});

// Auth State
sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final User user;
  const AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;
  final Failure? failure;
  const AuthError(this.message, {this.failure});
}

// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthInitial());

  Future<void> checkAuthStatus() async {
    state = const AuthLoading();
    final isAuthenticated = await _repository.isAuthenticated();

    if (isAuthenticated) {
      final user = await _repository.getCurrentUser();
      if (user != null) {
        state = AuthAuthenticated(user);
      } else {
        state = const AuthUnauthenticated();
      }
    } else {
      state = const AuthUnauthenticated();
    }
  }

  Future<bool> login(String email, String password) async {
    state = const AuthLoading();

    final (failure, user) = await _repository.login(email, password);

    if (failure != null) {
      state = AuthError(failure.message, failure: failure);
      return false;
    }

    if (user != null) {
      state = AuthAuthenticated(user);
      return true;
    }

    state = const AuthError('Erreur de connexion');
    return false;
  }

  Future<void> logout() async {
    state = const AuthLoading();
    await _repository.logout();
    state = const AuthUnauthenticated();
  }

  void clearError() {
    if (state is AuthError) {
      state = const AuthUnauthenticated();
    }
  }
}

// Auth State Provider
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});
