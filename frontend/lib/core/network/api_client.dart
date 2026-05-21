import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://192.168.110.225:8080/api/v1', // emulator Android
  );

  final Dio _dio;
  final FlutterSecureStorage _storage;

  ApiClient({Dio? dio, FlutterSecureStorage? storage})
    : _dio = dio ?? Dio(BaseOptions(baseUrl: baseUrl)),
      _storage = storage ?? const FlutterSecureStorage() {
    _dio.interceptors.add(_AuthInterceptor(_storage, _dio));
  }

  Dio get dio => _dio;
}

class _AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;
  final Dio _dio;

  _AuthInterceptor(this._storage, this._dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Tandai semua request dari Flutter agar backend bisa membedakan dari NextJS
    options.headers['X-Client-Type'] = 'flutter';

    final token = await _storage.read(key: 'access_token');
    if (token != null && token != 'null') {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Coba refresh token
      final refreshed = await _tryRefresh();
      if (refreshed) {
        // Retry request asal
        final token = await _storage.read(key: 'access_token');
        err.requestOptions.headers['Authorization'] = 'Bearer $token';
        final response = await _dio.fetch(err.requestOptions);
        handler.resolve(response);
        return;
      }
      // Refresh gagal — hapus token, redirect ke login
      await _storage.deleteAll();
    }
    handler.next(err);
  }

  Future<bool> _tryRefresh() async {
    try {
      final refreshToken = await _storage.read(key: 'refresh_token');
      if (refreshToken == null) return false;

      final response = await Dio().post(
        '${ApiClient.baseUrl}/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      final newToken = response.data['data']['access_token'];
      await _storage.write(key: 'access_token', value: newToken);
      return true;
    } catch (_) {
      return false;
    }
  }
}
