// riwayat_transaksi_model.dart

class ProductDetailData {
  final String productName;
  final String category;
  final String imageUrl;
  final int totalSold;
  final int currentPeriodSold;
  final List<TransactionHistoryModel> riwayatTransaksi;

  ProductDetailData({
    required this.productName,
    required this.category,
    required this.imageUrl,
    required this.totalSold,
    required this.currentPeriodSold,
    required this.riwayatTransaksi,
  });

  factory ProductDetailData.fromJson(Map<String, dynamic> json) {
    // Membaca objek nested 'produk' dari Go
    final produk = json['produk'] is Map ? json['produk'] as Map<String, dynamic> : {};
    
    // Membaca objek nested 'statistik_produk' dari Go
    final statistik = json['statistik_produk'] is Map ? json['statistik_produk'] as Map<String, dynamic> : {};

    // Membaca array 'riwayat_transaksi' dari Go
    final list = json['riwayat_transaksi'] ?? [];
    List<TransactionHistoryModel> historyList = [];
    if (list is List) {
      historyList = list.map((i) => TransactionHistoryModel.fromJson(i)).toList();
    }

    return ProductDetailData(
      // Dipetakan dari objek 'produk'
      productName: produk['nama_produk'] ?? '-',
      category: produk['kategori'] ?? '-',
      imageUrl: produk['gambar'] ?? '',
      
      // Dipetakan dari objek 'statistik_produk'
      totalSold: _toInt(statistik['total_terjual']),
      currentPeriodSold: _toInt(statistik['terjual_periode_ini']),
      
      riwayatTransaksi: historyList,
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class TransactionHistoryModel {
  final String invoiceNumber;
  final String date;
  final int totalPrice;
  final int quantity;

  TransactionHistoryModel({
    required this.invoiceNumber,
    required this.date,
    required this.totalPrice,
    required this.quantity,
  });

  factory TransactionHistoryModel.fromJson(Map<String, dynamic> json) {
    // Memformat string tanggal "2026-05-09T09:30:00Z" menjadi lebih ringkas jika diperlukan
    String rawDate = json['tanggal_waktu'] ?? '-';
    if (rawDate.length > 10) {
      rawDate = rawDate.substring(0, 10); // Mengambil bagian "2026-05-09" saja
    }

    return TransactionHistoryModel(
      // Dipetakan dari 'nomor_invoice' sesuai JSON Go
      invoiceNumber: json['nomor_invoice'] ?? '-',
      date: rawDate,
      // Dipetakan dari 'subtotal' dan 'quantity' sesuai JSON Go
      totalPrice: _toInt(json['subtotal']),
      quantity: _toInt(json['quantity']),
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}