import '../../../core/network/api_client.dart';

class SummaryService {
  final ApiClient _client;

  SummaryService({ApiClient? client}) : _client = client ?? ApiClient();

  /// Mengambil data laporan ringkasan untuk kasir
  Future<Map<String, dynamic>> getLaporanRingkasan() async {
    // Sesuai dengan route di backend: v1.GET("/kasir/laporan", ...)
    // Base URL dan prefix /api/v1 biasanya sudah diatur di dalam ApiClient
    final response = await _client.dio.get('/kasir/laporan'); 
    return response.data['data'];
  }
}