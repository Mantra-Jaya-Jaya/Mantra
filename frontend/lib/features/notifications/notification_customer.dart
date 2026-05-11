import 'package:flutter/material.dart';

class NotificationCustomerPage extends StatelessWidget {
  const NotificationCustomerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFAD510D),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 55, 20, 22),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Notifikasi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              children: [
                const Text(
                  'Hari ini',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                _notificationCard(
                  icon: Icons.discount_outlined,
                  title: 'Diskon spesial untukmu!',
                  description:
                      'Dapatkan diskon 30% untuk semua buku pelajaran. Promo berlaku s.d 10 Mei 2026.',
                ),
                _notificationCard(
                  icon: Icons.payment_outlined,
                  title: 'Pembayaran berhasil',
                  description:
                      'Pesanan #123 telah dikonfirmasi. Total pembayaran Rp. 300.000 via Dana.',
                ),
                _notificationCard(
                  icon: Icons.local_shipping_outlined,
                  title: 'Pesanan hampir sampai!',
                  description:
                      'Pesanan #123 sedang dalam perjalanan menuju lokasi anda.',
                ),
                const SizedBox(height: 20),
                const Text(
                  'Kemarin',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                _notificationCard(
                  icon: Icons.location_on_outlined,
                  title: 'Pesanan telah sampai',
                  description:
                      'Pesanan #234 telah diterima. Semoga kamu puas ya!',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _notificationCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1E8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFFAD510D), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
