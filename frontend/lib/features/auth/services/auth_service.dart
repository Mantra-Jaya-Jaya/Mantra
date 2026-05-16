import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/models/user_model.dart';

class AuthService {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  AuthService(this._dio, this._storage);

  // LOGIN
  // Endpoint: POST /api/v1/login
  Future<UserModel> login(String username, String password) async {
    final response = await _dio.post('/login', data: {
      'username': username,
      'password': password,
    });

    final data = response.data['data'];

    // Simpan token ke secure storage
    // access_token = JWT, refresh_token = random bytes hex
    await _storage.write(key: 'access_token', value: data['access_token']);
    await _storage.write(key: 'refresh_token', value: data['refresh_token']);
    await _storage.write(key: 'role', value: data['user']['role']);

    return UserModel.fromJson(data['user']);
  }

  // REGISTER
  // Endpoint: POST /api/v1/register
  Future<void> register({
    required String username,
    required String email,
    required String password,
    required String konfirmasiPassword,
    required String namaLengkap,
    required String noTelp,
  }) async {
    await _dio.post('/register', data: {
      'username': username,
      'email': email,
      'password': password,
      'konfirmasi_password': konfirmasiPassword,
      'nama_lengkap': namaLengkap,
      'no_telp': noTelp,
    });
    // Tidak auto-login setelah register — arahkan ke halaman login
  }

  // LOGOUT
  // Endpoint: POST /api/v1/logout
  Future<void> logout() async {
    final refreshToken = await _storage.read(key: 'refresh_token');
    try {
      await _dio.post('/logout', data: {'refresh_token': refreshToken});
    } catch (_) {
      // Tetap hapus token lokal meskipun request gagal
    } finally {
      await _storage.deleteAll();
    }
  }

  // CEK SESI — dipakai di splash screen
  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'access_token');
    return token != null;
  }

  // AMBIL ROLE DARI STORAGE — untuk routing setelah login
  Future<String?> getSavedRole() async {
    return await _storage.read(key: 'role');
  }
}
