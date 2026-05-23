import '../network/api_client.dart';

class ProfileService {
  final ApiClient _client;

  ProfileService({ApiClient? client}) : _client = client ?? ApiClient();

  /// Mengambil profil customer
  Future<Map<String, dynamic>> getProfil() async {
    final response = await _client.dio.get('/customer/profil');
    return response.data['data'];
  }

  /// Memperbarui akun customer
  Future<Map<String, dynamic>> updateAkun({
    required String namaLengkap,
    required String noTelp,
    required String email,
  }) async {
    final response = await _client.dio.put(
      '/customer/akun',
      data: {'nama_lengkap': namaLengkap, 'no_telp': noTelp, 'email': email},
    );
    return response.data['data'];
  }

  Future<List<Map<String, dynamic>>> getAlamat() async {
    final response = await _client.dio.get('/customer/alamat');
    final data = response.data['data'] as List?;
    return data?.map((e) => e as Map<String, dynamic>).toList() ?? [];
  }

  /// Menambahkan alamat baru
  Future<Map<String, dynamic>> tambahAlamat({
    required String label,
    required String nama,
    required String telepon,
    required String alamatLengkap,
    bool isUtama = false,
  }) async {
    final response = await _client.dio.post(
      '/customer/alamat',
      data: {
        'label_alamat': label,
        'nama_penerima': nama,
        'no_telp_penerima': telepon,
        'alamat_lengkap': alamatLengkap,
        'is_utama': isUtama,
      },
    );
    return response.data['data'];
  }

  /// Memperbarui alamat yang ada
  Future<Map<String, dynamic>> updateAlamat(
    String idAlamat, {
    required String label,
    required String nama,
    required String telepon,
    required String alamatLengkap,
    bool isUtama = false,
  }) async {
    final response = await _client.dio.put(
      '/customer/alamat/$idAlamat',
      data: {
        'label_alamat': label,
        'nama_penerima': nama,
        'no_telp_penerima': telepon,
        'alamat_lengkap': alamatLengkap,
        'is_utama': isUtama,
      },
    );
    return response.data['data'];
  }

  /// Menghapus alamat
  Future<void> hapusAlamat(String idAlamat) async {
    await _client.dio.delete('/customer/alamat/$idAlamat');
  }
}
