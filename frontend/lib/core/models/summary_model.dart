// summary_model.dart
import 'package:flutter/material.dart';

class ProductModel {
  final int idProduk;
  final String nama;
  final String deskripsi;
  final int terjual;
  final String imageUrl;

  ProductModel({
    required this.idProduk,
    required this.nama,
    required this.deskripsi,
    required this.terjual,
    required this.imageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      idProduk: json['id_produk'] ?? 0,
      nama: json['nama_produk'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      terjual: json['jumlah_terjual'] ?? 0,
      imageUrl: json['gambar'] ?? '',
    );
  }
}

class SummaryData {
  final double totalPendapatan;
  final double persentasePendapatan;
  final int totalTransaksi;
  final int persentaseTransaksi;
  final double rataRataPesanan;
  final String statusRataRata;
  final List<double> chartData;
  final List<String> chartLabels;
  final List<ProductModel> produkTerlaris;

  SummaryData({
    required this.totalPendapatan,
    required this.persentasePendapatan,
    required this.totalTransaksi,
    required this.persentaseTransaksi,
    required this.rataRataPesanan,
    required this.statusRataRata,
    required this.chartData,
    required this.chartLabels,
    required this.produkTerlaris,
  });

  factory SummaryData.fromJson(Map<String, dynamic> json) {
    final header = json['header_statistik'] ?? {};
    final grafik = json['grafik_pendapatan'] as List? ?? [];
    final produk = json['produk_terlaris'] as List? ?? [];

    List<String> labels = [];
    List<double> values = [];
    for (var item in grafik) {
      labels.add(item['label'] ?? '');
      values.add((item['nilai'] ?? 0).toDouble());
    }

    return SummaryData(
      totalPendapatan: (header['total_pendapatan'] ?? 0).toDouble(),
      persentasePendapatan: (header['persentase_kenaikan_pendapatan'] ?? 0).toDouble(),
      totalTransaksi: header['total_transaksi'] ?? 0,
      persentaseTransaksi: (header['persentase_kenaikan_transaksi'] ?? 0).toInt(),
      rataRataPesanan: (header['rata_rata_pesanan'] ?? 0).toDouble(),
      statusRataRata: header['status_rata_rata'] ?? 'stabil',
      chartLabels: labels,
      chartData: values,
      produkTerlaris: produk.map((p) => ProductModel.fromJson(p)).toList(),
    );
  }
}