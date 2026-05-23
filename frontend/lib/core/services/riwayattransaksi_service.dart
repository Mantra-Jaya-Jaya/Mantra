import '../../../core/network/api_client.dart';

class RiwayatTransaksiService {
  final ApiClient _client;

  RiwayatTransaksiService({ApiClient? client}) : _client = client ?? ApiClient();

  /// Mengambil data detail transaksi produk berdasarkan ID Produk
  Future<Map<String, dynamic>> getDetailTransaksiProduk(int productId) async {
    // URL disesuaikan dengan route backend Go: "/kasir/laporan/produk/:id_produk"
    final response = await _client.dio.get('/kasir/laporan/produk/$productId'); 
    
    return response.data['data'] ?? response.data;
  }
}