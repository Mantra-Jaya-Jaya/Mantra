import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ==================== MODEL DETAIL ====================
class TransactionHistoryModel {
  final String invoiceNumber;
  final String date;
  final double totalPrice;
  final int quantity;

  TransactionHistoryModel({
    required this.invoiceNumber,
    required this.date,
    required this.totalPrice,
    required this.quantity,
  });
}

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
}

// ==================== PAGE DETAIL ====================
class RiwayatTransaksi extends StatefulWidget {
  final String productName; // Menerima data dari summary.dart

  const RiwayatTransaksi({
    super.key,
    required this.productName, // Constructor named parameter wajib ada
  });

  @override
  State<RiwayatTransaksi> createState() => _RiwayatTransaksiState();
}

class _RiwayatTransaksiState extends State<RiwayatTransaksi> {
  ProductDetailData? _detailData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDetailData();
  }

  Future<void> _loadDetailData() async {
    await Future.delayed(const Duration(milliseconds: 400));

    if (mounted) {
      setState(() {
        // Data dummy disesuaikan dengan gambar UI
        _detailData = ProductDetailData(
          productName: widget.productName, 
          category: "Coffee & Beverage",
          imageUrl: "https://images.unsplash.com/photo-1541167760496-1628856ab772?w=100",
          totalSold: 142,
          currentPeriodSold: 24,
          riwayatTransaksi: [
            TransactionHistoryModel(invoiceNumber: "INV-1042", date: "24 Oct 2023, 14:20", totalPrice: 38000, quantity: 1),
            TransactionHistoryModel(invoiceNumber: "INV-1039", date: "24 Oct 2023, 13:05", totalPrice: 76000, quantity: 2),
            TransactionHistoryModel(invoiceNumber: "INV-1035", date: "24 Oct 2023, 11:45", totalPrice: 38000, quantity: 1),
            TransactionHistoryModel(invoiceNumber: "INV-1022", date: "23 Oct 2023, 18:30", totalPrice: 114000, quantity: 3),
            TransactionHistoryModel(invoiceNumber: "INV-1018", date: "23 Oct 2023, 16:15", totalPrice: 38000, quantity: 1),
          ],
        );
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      // Menggunakan AppBar standar Flutter agar tombol back otomatis muncul & berfungsi
      appBar: AppBar(
        title: const Text(
          "Transaksi Produk",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFAF510C), // Warna cokelat oranye khas kuliner
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context), // Fungsi tombol back
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFAF510C)))
          : _detailData == null
              ? const Center(child: Text("Data detail tidak tersedia"))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderCard(),
                      const SizedBox(height: 16),
                      _buildStatsRow(),
                      const SizedBox(height: 24),
                      const Text(
                        "Riwayat Transaksi",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1A1C1C)),
                      ),
                      const SizedBox(height: 12),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _detailData!.riwayatTransaksi.length,
                        itemBuilder: (context, index) {
                          return _buildTransactionItem(_detailData!.riwayatTransaksi[index]);
                        },
                      ),
                    ],
                  ),
                ),
    );
  }

  // ==================== CARD INFO PRODUK ====================
  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              _detailData!.imageUrl,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 56,
                height: 56,
                color: const Color(0xFFF3EDE5),
                child: const Icon(Icons.coffee, color: Color(0xFFAF510C), size: 28),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _detailData!.productName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1A1C1C)),
                ),
                const SizedBox(height: 4),
                Text(
                  _detailData!.category,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF55585D)), // Dipergelap dari abu tipis
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== STATS ROW (TOTAL SOLD & CURRENT) ====================
  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFAF510C),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Sold",
                  style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12), // Kontras dinaikkan
                ),
                const SizedBox(height: 6),
                Text(
                  "${_detailData!.totalSold}",
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Current Period",
                  style: TextStyle(color: Color(0xFF4B5563), fontSize: 12), // Diubah ke Abu-abu kontras medium
                ),
                const SizedBox(height: 6),
                Text(
                  "${_detailData!.currentPeriodSold}",
                  style: const TextStyle(color: Color(0xFFAF510C), fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==================== ITEM LIST TRANSAKSI ====================
  Widget _buildTransactionItem(TransactionHistoryModel tx) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEFE3),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tx.invoiceNumber,
                  style: const TextStyle(color: Color(0xFFAF510C), fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                tx.date,
                style: const TextStyle(fontSize: 12, color: Color(0xFF4B5563)), // Lebih gelap agar terbaca jelas
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                currencyFormat.format(tx.totalPrice),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1A1C1C)),
              ),
              const SizedBox(height: 6),
              Text(
                "Qty: ${tx.quantity}",
                style: const TextStyle(fontSize: 11, color: Color(0xFF55585D)), // Diperjelas kontrasnya
              ),
            ],
          ),
        ],
      ),
    );
  }
}