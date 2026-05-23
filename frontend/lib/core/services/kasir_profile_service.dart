import '../network/api_client.dart';

class KasirProfileService {
  final ApiClient _client;

  KasirProfileService({ApiClient? client}) : _client = client ?? ApiClient();

  /// Mengambil profil kasir
  Future<Map<String, dynamic>> getProfil() async {
    // Sesuaikan dengan endpoint asli backend untuk kasir
    final response = await _client.dio.get('/kasir/profil'); 
    return response.data['data'];
  }

  /// Fungsi logout untuk kasir (jika endpointnya terpisah)
  Future<void> logout() async {
    await _client.dio.post('/auth/logout'); // Sesuaikan endpoint logoutmu
  }
}