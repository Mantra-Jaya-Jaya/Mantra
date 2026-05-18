import 'package:frontend/core/network/api_client.dart';

class AktivitasItem {
  final String nomorInvoice;
  final String metodePembayaran;
  final String waktu;
  final int totalBayar;

  AktivitasItem({
    required this.nomorInvoice,
    required this.metodePembayaran,
    required this.waktu,
    required this.totalBayar,
  });

  factory AktivitasItem.fromJson(Map<String, dynamic> json) {
    return AktivitasItem(
      nomorInvoice: json['nomor_invoice'] ?? '',
      metodePembayaran: json['metode_pembayaran'] ?? '',
      waktu: json['waktu'] ?? '',
      totalBayar: json['total_bayar'] ?? 0,
    );
  }
}

class DashboardKasirData {
  final String namaKasir;
  final int totalPendapatan;
  final int jumlahTransaksi;
  final int totalItemTerjual;
  final List<AktivitasItem> aktivitasTerkini;

  DashboardKasirData({
    required this.namaKasir,
    required this.totalPendapatan,
    required this.jumlahTransaksi,
    required this.totalItemTerjual,
    required this.aktivitasTerkini,
  });

  factory DashboardKasirData.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? {};
    final statistik = json['statistik_hari_ini'] ?? {};
    final List aktivitas = json['aktivitas_terkini'] ?? [];

    return DashboardKasirData(
      namaKasir: user['nama_kasir'] ?? 'Kasir',
      totalPendapatan: statistik['total_pendapatan'] ?? 0,
      jumlahTransaksi: statistik['jumlah_transaksi'] ?? 0,
      totalItemTerjual: statistik['total_item_terjual'] ?? 0,
      aktivitasTerkini:
          aktivitas.map((e) => AktivitasItem.fromJson(e)).toList(),
    );
  }
}

class DashboardKasirService {
  final ApiClient _client;

  DashboardKasirService({ApiClient? client}) : _client = client ?? ApiClient();

  /// Ambil data dashboard kasir.
  /// Endpoint: GET /kasir/dashboard
  Future<DashboardKasirData> getDashboard() async {
    final response = await _client.dio.get('/kasir/dashboard');
    return DashboardKasirData.fromJson(response.data['data']);
  }
}
