import 'dart:developer';
import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio;
  String? _token;

  ApiClient(String baseUrl)
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 15),
          headers: {'Content-Type': 'application/json'},
        )) {
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: false,
      requestHeader: true,
      responseHeader: false,
    ));

    // Add auth interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_token != null) {
          options.headers['Authorization'] = 'Bearer $_token';
          log('🔑 Token added to request: ${options.uri}');
        } else {
          log('⚠️ No token available for request: ${options.uri}');
        }
        handler.next(options);
      },
    ));
  }

  void setToken(String? token) {
    _token = token;
    log('🔐 Token set in ApiClient: ${token?.substring(0, 20)}...');
  }

  String? get token => _token;

  Dio get dio => _dio;
}
