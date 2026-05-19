import 'package:frontend/core/network/api_client.dart';

// Model Promo/Diskon
class PromoModel {
  final int idDiskon;
  final String namaDiskon;
  final String bannerUrl;
  final String tglSelesai;

  PromoModel({
    required this.idDiskon,
    required this.namaDiskon,
    required this.bannerUrl,
    required this.tglSelesai,
  });

  factory PromoModel.fromJson(Map<String, dynamic> json) {
    return PromoModel(
      idDiskon: json['id_diskon'] ?? 0,
      namaDiskon: json['nama_diskon'] ?? '',
      bannerUrl: json['banner_url'] ?? '',
      tglSelesai: json['tgl_selesai'] ?? '',
    );
  }
}

// Model Kategori
class KategoriModel {
  final int idKategori;
  final String namaKategori;
  final String iconKategori;

  KategoriModel({
    required this.idKategori,
    required this.namaKategori,
    required this.iconKategori,
  });

  factory KategoriModel.fromJson(Map<String, dynamic> json) {
    return KategoriModel(
      idKategori: json['id_kategori'] ?? 0,
      namaKategori: json['nama_kategori'] ?? '',
      iconKategori: json['icon_kategori'] ?? '',
    );
  }
}

// Model Barang (ringkasan untuk list)
class BarangModel {
  final String idBarang;
  final String namaBarang;
  final int hargaTerendah;
  final int hargaTertinggi;
  final int hargaDiskon;
  final bool punyaDiskon;
  final String gambarBarang;

  BarangModel({
    required this.idBarang,
    required this.namaBarang,
    required this.hargaTerendah,
    required this.hargaTertinggi,
    required this.hargaDiskon,
    required this.punyaDiskon,
    required this.gambarBarang,
  });

  factory BarangModel.fromJson(Map<String, dynamic> json) {
    return BarangModel(
      idBarang: (json['id_barang'] ?? json['public_id'] ?? '').toString(),
      namaBarang: json['nama_barang'] ?? '',
      hargaTerendah: json['harga_terendah'] ?? 0,
      hargaTertinggi: json['harga_tertinggi'] ?? 0,
      hargaDiskon: json['harga_diskon'] ?? 0,
      punyaDiskon: json['punya_diskon'] ?? false,
      gambarBarang: json['gambar_barang'] ?? '',
    );
  }
}

class KatalogService {
  final ApiClient _client;

  KatalogService({ApiClient? client}) : _client = client ?? ApiClient();

  /// Ambil promo yang sedang aktif.
  /// Endpoint: GET /customer/promo
  Future<List<PromoModel>> getPromoAktif() async {
    final response = await _client.dio.get('/customer/promo');
    final List data = response.data['data'] ?? [];
    return data.map((e) => PromoModel.fromJson(e)).toList();
  }

  /// Ambil daftar kategori barang.
  /// Endpoint: GET /customer/kategori
  Future<List<KategoriModel>> getKategori({int? limit}) async {
    final response = await _client.dio.get(
      '/customer/kategori',
      queryParameters: limit != null ? {'limit': limit} : null,
    );
    final List data = response.data['data'] ?? [];
    return data.map((e) => KategoriModel.fromJson(e)).toList();
  }

  /// Ambil daftar barang dengan pagination.
  /// Endpoint: GET /customer/barang?page=&limit=
  Future<List<BarangModel>> getDaftarBarang({int page = 1, int limit = 10}) async {
    final response = await _client.dio.get(
      '/customer/barang',
      queryParameters: {'page': page, 'limit': limit},
    );
    final List data = response.data['data'] ?? [];
    return data.map((e) => BarangModel.fromJson(e)).toList();
  }
}
