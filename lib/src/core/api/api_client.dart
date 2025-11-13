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
    log('🌐 ApiClient initialized with baseUrl: $baseUrl');

    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: false,
      logPrint: (obj) => log('📡 $obj'),
    ));

    // Add auth interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        log('🚀 Request: ${options.method} ${options.uri}');
        if (_token != null) {
          options.headers['Authorization'] = 'Bearer $_token';
          log('🔑 Token added to request');
        } else {
          log('⚠️ No token available for request');
        }
        handler.next(options);
      },
      onError: (error, handler) {
        log('❌ API Error: ${error.type}');
        log('❌ URL: ${error.requestOptions.uri}');
        log('❌ Status: ${error.response?.statusCode}');
        log('❌ Message: ${error.message}');
        log('❌ Response: ${error.response?.data}');
        handler.next(error);
      },
      onResponse: (response, handler) {
        log('✅ Response: ${response.statusCode} ${response.requestOptions.uri}');
        handler.next(response);
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
