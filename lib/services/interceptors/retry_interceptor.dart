import 'dart:async';

import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final Dio _dio;
  final int maxRetries;
  final Duration baseDelay;

  RetryInterceptor(
    this._dio, {
    this.maxRetries = 2,
    this.baseDelay = const Duration(milliseconds: 300),
  });

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final requestOptions = err.requestOptions;
    final method = requestOptions.method.toUpperCase();

    final isIdempotent = method == 'GET' || method == 'HEAD';
    final isNetworkError = err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError;

    final retryCount = (requestOptions.extra['retry_count'] as int?) ?? 0;

    if (isIdempotent && isNetworkError && retryCount < maxRetries) {
      requestOptions.extra['retry_count'] = retryCount + 1;

      final delay = baseDelay * (retryCount + 1);
      await Future.delayed(delay);

      try {
        final response = await _dio.fetch(requestOptions);
        return handler.resolve(response);
      } on DioException catch (e) {
        return handler.next(e);
      }
    }

    return handler.next(err);
  }
}
