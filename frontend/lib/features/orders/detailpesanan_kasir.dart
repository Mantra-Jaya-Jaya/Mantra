import 'package:flutter/material.dart';
import 'order_model.dart';

class DetailPesanan extends StatefulWidget {
  final OrderModel pesanan;

  const DetailPesanan({super.key, required this.pesanan});

  @override
  DetailPesananState createState() => DetailPesananState();
}

class DetailPesananState extends State<DetailPesanan> {
  // Helper fungsi format mata uang Rupiah
  String _formatRupiah(int angka) {
    return "Rp ${angka.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.pesanan;
    final String metodePembayaran = order.isOnline ? "Online App (QRIS)" : "Tunai (Kasir)";

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        title: const Text(
          "Detail Pesanan",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: const Color(0xFFAF510C),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. CARD NOTA INVOICE & STATUS PESANAN
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1)),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          order.orderId,
                          style: const TextStyle(
                            color: Color(0xFF25343F),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: order.statusText.toLowerCase() == 'selesai' 
                                ? const Color(0xFFDCFCE7) 
                                : const Color(0xFFFFEDD5),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                          child: Text(
                            order.statusText.toUpperCase(),
                            style: TextStyle(
                              color: order.statusText.toLowerCase() == 'selesai' 
                                  ? const Color(0xFF15803D) 
                                  : const Color(0xFFAF510C),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 14, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(
                          order.timeInfo,
                          style: const TextStyle(color: Color(0xFF566067), fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 2. SEKSI INFORMASI PELANGGAN
              _buildSectionTitle("INFORMASI PELANGGAN"),
              _buildCardContainer([
                _buildRowDetail("Nama Pelanggan", "Budi Santoso", isValueBold: true),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Lokasi Pengiriman",
                      style: TextStyle(color: Color(0xFF566067), fontSize: 14),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        order.isOnline ? "Jl. Merdeka No. 123, Semarang" : "Makan di Tempat (Meja 04)",
                        style: const TextStyle(
                          color: Color(0xFF25343F),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ]),

              // 3. SEKSI ITEM YANG DIBELI (SINKRON DENGAN DATA SEEDER DETAIL PESANAN)
              _buildSectionTitle("ITEM YANG DIBELI"),
              _buildCardContainer([
                Column(
                  children: order.detailItems.map((item) {
                    // Menghitung subtotal per item belanjaan secara otomatis (Jumlah * HargaSatuan)
                    final int subtotalItem = item.qty * item.hargaSatuan;
                    
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.namaBarang,
                                  style: const TextStyle(
                                    color: Color(0xFF25343F),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${item.qty} x ${_formatRupiah(item.hargaSatuan)}",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            _formatRupiah(subtotalItem),
                            style: const TextStyle(
                              color: Color(0xFF25343F),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ]),

              // 4. SEKSI DATA KASIR
              _buildSectionTitle("DATA KASIR"),
              _buildCardContainer([
                _buildRowDetail("Nama Kasir", "Siti Aminah", isValueBold: true),
                const SizedBox(height: 12),
                _buildRowDetail("Shift", "Shift Pagi (07:00 - 15:00)", isValueBold: true),
              ]),

              // 5. SEKSI INFORMASI PEMBAYARAN
              _buildSectionTitle("INFORMASI PEMBAYARAN"),
              _buildCardContainer([
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Metode Pembayaran",
                      style: TextStyle(color: Color(0xFF566067), fontSize: 14),
                    ),
                    Row(
                      children: [
                        Icon(
                          order.isOnline ? Icons.qr_code : Icons.payments,
                          size: 15,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          metodePembayaran,
                          style: const TextStyle(
                            color: Color(0xFF25343F),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Status Pembayaran",
                      style: TextStyle(color: Color(0xFF566067), fontSize: 14),
                    ),
                    Text(
                      order.statusText.toLowerCase() == "selesai" ? "LUNAS" : "BELUM BAYAR",
                      style: TextStyle(
                        color: order.statusText.toLowerCase() == "selesai" ? Colors.green : Colors.orange,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ]),

              // 6. RINGKASAN TOTAL AKHIR
              _buildSectionTitle("RINGKASAN TOTAL"),
              _buildCardContainer([
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Akhir",
                      style: TextStyle(
                        color: Color(0xFF25343F),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      order.price,
                      style: const TextStyle(
                        color: Color(0xFFAF510C),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  // WIDGET HELPER REUSABLE
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 18, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF566067),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCardContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildRowDetail(String label, String value, {bool isValueBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF566067), fontSize: 14)),
        Text(
          value,
          style: TextStyle(
            color: const Color(0xFF25343F),
            fontSize: 14,
            fontWeight: isValueBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}