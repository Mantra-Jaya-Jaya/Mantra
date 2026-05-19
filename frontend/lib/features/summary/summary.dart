import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/widgets/base_header_widget.dart';
import 'package:frontend/features/summary/riwayattransaksi.dart';

// ==================== MODEL ====================
class ProductModel {
  final String nama;
  final String deskripsi;
  final int terjual;
  final String imageUrl;

  ProductModel(this.nama, this.deskripsi, this.terjual, this.imageUrl);
}

class SummaryData {
  final double totalPendapatan;
  final double persentasePendapatan;
  final int totalTransaksi;
  final int persentaseTransaksi;
  final double rataRataPesanan;
  final bool rataRataStabil;
  final List<double> chartData;
  final List<String> chartLabels;
  final List<ProductModel> produkTerlaris;

  SummaryData({
    required this.totalPendapatan,
    required this.persentasePendapatan,
    required this.totalTransaksi,
    required this.persentaseTransaksi,
    required this.rataRataPesanan,
    required this.rataRataStabil,
    required this.chartData,
    required this.chartLabels,
    required this.produkTerlaris,
  });
}

// ==================== PAGE ====================
class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  SummaryData? _data;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Simulasi delay loading durasi 500ms
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _data = SummaryData(
          totalPendapatan: 12450000,
          persentasePendapatan: 12.5,
          totalTransaksi: 142,
          persentaseTransaksi: 8,
          rataRataPesanan: 87676,
          rataRataStabil: true,
          chartLabels: ['08:00','09:00','10:00','11:00','12:00','13:00','14:00','15:00','16:00','17:00','18:00','19:00','20:00'],
          chartData: [0.18, 0.32, 0.42, 0.50, 0.68, 0.82, 1.0, 0.75, 0.55, 0.42, 0.30, 0.22, 0.12],
          produkTerlaris: [
            ProductModel("Brown Sugar Latte", "Kopi Gula Gula Aren", 42, "https://images.unsplash.com/photo-1541167760496-1628856ab772?w=100"),
            ProductModel("MANTRA Signature", "Blended Special Coffee", 38, "https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=100"),
            ProductModel("Ice Americano", "Kopi Hitam Segar", 35, "https://images.unsplash.com/photo-1499638673689-79a0b5115d87?w=100"),
            ProductModel("Creamy Matcha Pull", "Minuman Matcha Premium", 28, "https://images.unsplash.com/photo-1578314675249-a6910f80cc4e?w=100"),
            ProductModel("Caramel Macchiato", "Sweet Caramel Coffee", 24, "https://images.unsplash.com/photo-1621939514649-280e2ee25f60?w=100"),
          ],
        );
        _isLoading = false; // Loading dimatikan setelah data dipastikan masuk ke state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: BaseHeaderWidget(
        title: "Laporan Penjualan",
        hasRadius: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFAF510C)))
          : (_data == null)
              ? const Center(child: Text("Data tidak tersedia"))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      _buildPendapatanCard(),
                      const SizedBox(height: 14),
                      _buildSmallStatRow(),
                      const SizedBox(height: 24),
                      const Text(
                        "Produk Terlaris",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1A1C1C)),
                      ),
                      const SizedBox(height: 12),
                      ..._data!.produkTerlaris.map((p) => _buildProductItem(p)),
                    ],
                  ),
                ),
    );
  }

  // ==================== CARD TOTAL PENDAPATAN ====================
  Widget _buildPendapatanCard() {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "TOTAL PENDAPATAN",
            style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                currencyFormat.format(_data!.totalPendapatan),
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A1C1C)),
              ),
              const SizedBox(width: 8),
              _buildBadge(
                "+${_data!.persentasePendapatan.toStringAsFixed(1)}%",
                const Color(0xFFDCFCE7),
                const Color(0xFF15803D),
                icon: Icons.trending_up,
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 90,
            child: _buildBarChart(),
          ),
        ],
      ),
    );
  }

  // ==================== BAR CHART CUSTOM ====================
  Widget _buildBarChart() {
    final chartData = _data!.chartData;
    final chartLabels = _data!.chartLabels;
    final maxVal = chartData.reduce((a, b) => a > b ? a : b);
    final highlightIndex = chartData.indexOf(maxVal);

    // Labels yang ditampilkan (tiap 2)
    final visibleLabelIndexes = {0, 2, 4, 6, 8, 10, 12};

    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(chartData.length, (i) {
              final isHighlight = i == highlightIndex;
              final barHeight = (chartData[i] / maxVal);
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: FractionallySizedBox(
                    alignment: Alignment.bottomCenter,
                    heightFactor: barHeight < 0.1 ? 0.1 : barHeight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isHighlight ? const Color(0xFFAF510C) : const Color(0xFFF5D3BC),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: List.generate(chartLabels.length, (i) {
            return Expanded(
              child: Text(
                visibleLabelIndexes.contains(i) ? chartLabels[i] : '',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 7.5, color: Color(0xFF9CA3AF)),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ==================== 2 STAT KECIL ====================
  Widget _buildSmallStatRow() {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return Row(
      children: [
        Expanded(
          child: _buildSmallStat(
            icon: Icons.receipt_long_outlined,
            badge: "+${_data!.persentaseTransaksi}%",
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF15803D),
            label: "Total Transaksi",
            value: "${_data!.totalTransaksi}",
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _buildSmallStat(
            icon: Icons.analytics_outlined,
            badge: "Stabil",
            badgeBg: const Color(0xFFF3F4F6),
            badgeColor: const Color(0xFF374151),
            label: "Rata-rata Pesanan",
            value: currencyFormat.format(_data!.rataRataPesanan),
            valueSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildSmallStat({
    required IconData icon,
    required String badge,
    required Color badgeBg,
    required Color badgeColor,
    required String label,
    required String value,
    double valueSize = 16,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 20, color: const Color(0xFFAF510C)),
              _buildBadge(badge, badgeBg, badgeColor),
            ],
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 11)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(fontSize: valueSize, fontWeight: FontWeight.bold, color: const Color(0xFF1A1C1C))),
        ],
      ),
    );
  }

  // ==================== BADGE HELPER ====================
  Widget _buildBadge(String text, Color bg, Color textColor, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: textColor),
            const SizedBox(width: 3),
          ],
          Text(text, style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // ==================== PRODUK ITEM ====================
  Widget _buildProductItem(ProductModel product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute( 
            builder: (context) => RiwayatTransaksi(productName: product.nama),
          ),
        );
      },
    
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.imageUrl,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 48,
                  height: 48,
                  color: const Color(0xFFF3EDE5),
                  child: const Icon(Icons.coffee, color: Color(0xFFAF510C), size: 24),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.nama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1A1C1C))),
                  const SizedBox(height: 2),
                  Text(product.deskripsi, style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${product.terjual}",
                  style: const TextStyle(color: Color(0xFFAF510C), fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const Text("Terjual", style: TextStyle(fontSize: 10, color: Color(0xFF9CA3AF))),
              ],
            ),
          ],
        ),
      ),
    );  
  }
}