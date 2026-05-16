import 'package:dio/dio.dart';

class ApiError {
  final String code;
  final String message;

  ApiError({required this.code, required this.message});

  factory ApiError.fromDioException(DioException e) {
    final data = e.response?.data;
    return ApiError(
      code: data?['error']?['code'] ?? 'SERVER_001',
      message: data?['message'] ?? 'Terjadi kesalahan, coba lagi',
    );
  }

  // Pesan khusus per kode error auth
  String get userMessage {
    switch (code) {
      case 'AUTH_001': return 'Username atau password salah';
      case 'AUTH_003': return 'Sesi habis, silakan login kembali';
      case 'CONF_001': return 'Username sudah digunakan';
      case 'CONF_002': return 'Email sudah terdaftar';
      case 'VAL_002':  return 'Konfirmasi password tidak cocok';
      case 'VAL_003':  return 'Format email tidak valid';
      default:         return message;
    }
  }
}
