import 'package:dio/dio.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/auth_response.dart';

abstract class AuthRemoteDatasource {
  Future<AuthResponse> login(String email, String password);
  Future<void> logout();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final Dio _dio;

  AuthRemoteDatasourceImpl(this._dio);

  @override
  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.data == null) {
        throw ServerException(message: 'Réponse vide du serveur');
      }

      return AuthResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.error is Exception) {
        throw e.error as Exception;
      }
      throw ServerException(
        message: e.message ?? 'Erreur de connexion',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dio.post(ApiEndpoints.logout);
    } on DioException catch (e) {
      if (e.error is Exception) {
        throw e.error as Exception;
      }
      throw ServerException(
        message: e.message ?? 'Erreur lors de la déconnexion',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
