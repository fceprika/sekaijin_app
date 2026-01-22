import 'dart:convert';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../services/auth_service.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;
  final AuthService _authService;

  AuthRepositoryImpl(this._remoteDatasource, this._authService);

  @override
  Future<(Failure?, User?)> login(String email, String password) async {
    try {
      final response = await _remoteDatasource.login(email, password);

      if (!response.success || response.token == null) {
        return (
          AuthFailure(message: response.message),
          null,
        );
      }

      await _authService.saveToken(response.token!);

      if (response.user != null) {
        await _authService.saveUser(jsonEncode(response.user!.toJson()));
      }

      return (null, response.user);
    } on NetworkException catch (e) {
      return (NetworkFailure(message: e.message), null);
    } on AuthException catch (e) {
      return (AuthFailure(message: e.message), null);
    } on ValidationException catch (e) {
      return (ValidationFailure(message: e.message, errors: e.errors), null);
    } on ServerException catch (e) {
      return (ServerFailure(message: e.message, statusCode: e.statusCode), null);
    } catch (e) {
      return (const ServerFailure(message: 'Une erreur inattendue est survenue'), null);
    }
  }

  @override
  Future<(Failure?, void)> logout() async {
    try {
      await _remoteDatasource.logout();
      await _authService.clearAll();
      return (null, null);
    } on NetworkException catch (e) {
      await _authService.clearAll();
      return (NetworkFailure(message: e.message), null);
    } catch (e) {
      await _authService.clearAll();
      return (null, null);
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return await _authService.isAuthenticated();
  }

  @override
  Future<User?> getCurrentUser() async {
    final userJson = await _authService.getUser();
    if (userJson == null) return null;

    try {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (_) {
      return null;
    }
  }
}
