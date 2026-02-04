import 'package:dio/dio.dart';

import '../../core/errors/exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final exception = _handleError(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: exception,
      ),
    );
  }

  Exception _handleError(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(message: 'Délai de connexion dépassé');

      case DioExceptionType.connectionError:
        return NetworkException();

      case DioExceptionType.badResponse:
        return _handleBadResponse(err.response);

      case DioExceptionType.cancel:
        return ServerException(message: 'Requête annulée');

      default:
        return ServerException(
          message: err.message ?? 'Une erreur est survenue',
        );
    }
  }

  Exception _handleBadResponse(Response? response) {
    final statusCode = response?.statusCode;
    final data = response?.data;

    switch (statusCode) {
      case 400:
        return ValidationException(
          message: _extractMessage(data) ?? 'Requête invalide',
          errors: _extractErrors(data),
        );

      case 401:
        return AuthException(
          message: _extractMessage(data) ?? 'Session expirée',
        );

      case 403:
        return AuthException(message: 'Accès non autorisé');

      case 404:
        return ServerException(
          message: 'Ressource non trouvée',
          statusCode: statusCode,
        );

      case 422:
        return ValidationException(
          message: _extractMessage(data) ?? 'Données invalides',
          errors: _extractErrors(data),
        );

      case 500:
      case 502:
      case 503:
        return ServerException(
          message: 'Erreur serveur, veuillez réessayer plus tard',
          statusCode: statusCode,
        );

      default:
        return ServerException(
          message: _extractMessage(data) ?? 'Une erreur est survenue',
          statusCode: statusCode,
        );
    }
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] as String?;
    }
    return null;
  }

  Map<String, dynamic>? _extractErrors(dynamic data) {
    if (data is Map<String, dynamic> && data['errors'] != null) {
      return data['errors'] as Map<String, dynamic>?;
    }
    return null;
  }
}
