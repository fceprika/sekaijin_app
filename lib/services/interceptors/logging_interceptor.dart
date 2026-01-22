import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      developer.log(
        '>>> REQUEST [${options.method}] ${options.uri}',
        name: 'API',
      );
      if (options.data != null) {
        developer.log('Body: ${options.data}', name: 'API');
      }
      if (options.queryParameters.isNotEmpty) {
        developer.log('Query: ${options.queryParameters}', name: 'API');
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      developer.log(
        '<<< RESPONSE [${response.statusCode}] ${response.requestOptions.uri}',
        name: 'API',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      developer.log(
        '!!! ERROR [${err.response?.statusCode}] ${err.requestOptions.uri}',
        name: 'API',
      );
      developer.log('Message: ${err.message}', name: 'API');
    }
    handler.next(err);
  }
}
