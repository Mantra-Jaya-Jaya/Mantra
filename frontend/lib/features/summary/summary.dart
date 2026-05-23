// summary.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/widgets/base_header_widget.dart';
import 'package:frontend/features/summary/riwayattransaksi.dart';
import '../../core/models/summary_model.dart' as model; // Menggunakan alias agar tidak bentrok class
import '../../core/services/summary_service.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  final SummaryService _summaryService = SummaryService();
  model.SummaryData? _data; // Menggunakan model dari file terpisah
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchLaporanData();
  }

  Future<void> _fetchLaporanData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final rawData = await _summaryService.getLaporanRingkasan();

      if (mounted) {
        setState(() {
          _data = model.SummaryData.fromJson(rawData);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceAll('Exception: ', '');
          _isLoading = false;
        });
      }
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
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_errorMessage!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _fetchLaporanData,
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFAF510C)),
                          child: const Text("Coba Lagi", style: TextStyle(color: Colors.white)),
                        )
                      ],
                    ),
                  ),
                )
              : _data == null
                  ? const Center(child: Text("Data tidak tersedia"))
                  : RefreshIndicator(
                      onRefresh: _fetchLaporanData,
                      color: const Color(0xFFAF510C),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
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
                            if (_data!.produkTerlaris.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Center(child: Text("Belum ada data produk terjual", style: TextStyle(color: Colors.grey))),
                              )
                            else
                              ..._data!.produkTerlaris.map((p) => _buildProductItem(p)),
                          ],
                        ),
                      ),
                    ),
    );
  }

  Widget _buildPendapatanCard() {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final isPositive = _data!.persentasePendapatan >= 0;
    final badgeText = "${isPositive ? '+' : ''}${_data!.persentasePendapatan.toStringAsFixed(1)}%";
    final badgeBg = isPositive ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2);
    final badgeColor = isPositive ? const Color(0xFF15803D) : const Color(0xFFB91C1C);
    final badgeIcon = isPositive ? Icons.trending_up : Icons.trending_down;

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
              _buildBadge(badgeText, badgeBg, badgeColor, icon: badgeIcon),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 90,
            child: _data!.chartData.isEmpty 
                ? const Center(child: Text("Data grafik kosong", style: TextStyle(fontSize: 12, color: Colors.grey)))
                : _buildBarChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    final chartData = _data!.chartData;
    final chartLabels = _data!.chartLabels;
    final maxVal = chartData.isNotEmpty ? chartData.reduce((a, b) => a > b ? a : b) : 0.0;
    final highlightIndex = maxVal > 0 ? chartData.indexOf(maxVal) : -1;

    final visibleLabelIndexes = <int>{};
    if (chartLabels.length <= 7) {
      for (int i = 0; i < chartLabels.length; i++) visibleLabelIndexes.add(i);
    } else {
      for (int i = 0; i < chartLabels.length; i += 2) visibleLabelIndexes.add(i);
    }

    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(chartData.length, (i) {
              final isHighlight = i == highlightIndex && maxVal > 0;
              final barHeight = maxVal > 0 ? (chartData[i] / maxVal) : 0.1;
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

  Widget _buildSmallStatRow() {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final isTxPositive = _data!.persentaseTransaksi >= 0;
    final txBadgeText = "${isTxPositive ? '+' : ''}${_data!.persentaseTransaksi}%";
    final txBadgeBg = isTxPositive ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2);
    final txBadgeColor = isTxPositive ? const Color(0xFF15803D) : const Color(0xFFB91C1C);

    Color avgBg = const Color(0xFFF3F4F6);
    Color avgColor = const Color(0xFF374151);
    if (_data!.statusRataRata == 'naik') {
      avgBg = const Color(0xFFDCFCE7);
      avgColor = const Color(0xFF15803D);
    } else if (_data!.statusRataRata == 'turun') {
      avgBg = const Color(0xFFFEE2E2);
      avgColor = const Color(0xFFB91C1C);
    }

    return Row(
      children: [
        Expanded(
          child: _buildSmallStat(
            icon: Icons.receipt_long_outlined,
            badge: txBadgeText,
            badgeBg: txBadgeBg,
            badgeColor: txBadgeColor,
            label: "Total Transaksi",
            value: "${_data!.totalTransaksi}",
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _buildSmallStat(
            icon: Icons.analytics_outlined,
            badge: _data!.statusRataRata.toUpperCase(),
            badgeBg: avgBg,
            badgeColor: avgColor,
            label: "Rata-rata Pesanan",
            value: currencyFormat.format(_data!.rataRataPesanan),
            valueSize: 12,
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

  Widget _buildProductItem(model.ProductModel product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            // Mengirim ID Produk (int) ke halaman detail riwayat transaksi
            builder: (context) => RiwayatTransaksi(productId: product.idProduk),
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
                  Text(product.deskripsi, style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)), maxLines: 1, overflow: TextOverflow.ellipsis),
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