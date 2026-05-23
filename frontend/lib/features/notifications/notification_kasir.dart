import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data hardcode notifikasi sesuai mockup kamu
    final todayNotifications = [
      {
        "title": "Dapet Pesanan dar xxx",
        "message": "Pesanan berupa xx telah diterima, dan pembayar sudah Rp. 200.000 via seabank sudah di terima",
        "icon": Icons.percent,
      },
      {
        "title": "Pembayaran berhasil",
        "message": "Pesanan #123 telah dikonfirmasi. Total pembayaran Rp. 300.000 via Dana.",
        "icon": Icons.account_balance_wallet_outlined,
      },
      {
        "title": "Pesanan hampir sampai!",
        "message": "Pesanan #123 sedang dalam perjalanan menuju lokasi anda.",
        "icon": Icons.local_shipping_outlined,
      },
    ];

    final yesterdayNotifications = [
      {
        "title": "Pesanan telah sampai",
        "message": "Pesanan #234 telah diterima. Semoga kamu puas ya!",
        "icon": Icons.location_on_outlined,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFAF510C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Notifikasi",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kategori: Hari ini
            if (todayNotifications.isNotEmpty) ...[
              _buildSectionHeader("Hari ini"),
              const SizedBox(height: 10),
              ...todayNotifications.map((noti) => _buildNotificationCard(
                    title: noti["title"] as String,
                    message: noti["message"] as String,
                    icon: noti["icon"] as IconData,
                  )),
              const SizedBox(height: 15),
            ],

            // Kategori: Kemarin
            if (yesterdayNotifications.isNotEmpty) ...[
              _buildSectionHeader("Kemarin"),
              const SizedBox(height: 10),
              ...yesterdayNotifications.map((noti) => _buildNotificationCard(
                    title: noti["title"] as String,
                    message: noti["message"] as String,
                    icon: noti["icon"] as IconData,
                  )),
            ],
          ],
        ),
      ),
    );
  }

  // Widget untuk Judul Kategori (Hari ini, Kemarin)
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  // Widget Card Item Notifikasi
  Widget _buildNotificationCard({
    required String title,
    required String message,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFBFC9D1).withOpacity(0.5), width: 1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Wadah Icon Krem Muda khas mockup
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0x23AF510C), // Cokelat transparan tipis menjadi Krem
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF000000), // Icon berwarna gelap sesuai gambar
              size: 24,
            ),
          ),
          const SizedBox(width: 15),
          
          // Detail Teks (Judul & Isi Pesanan)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    height: 1.3,
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