import 'package:flutter/material.dart';

class MyOrderPage extends StatefulWidget {
  const MyOrderPage({super.key});

  @override
  State<MyOrderPage> createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {
  // Variabel untuk menyimpan status yang sedang dipilih
  String selectedStatus = "Dikemas";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // HEADER SECTION
        Container(
          padding: const EdgeInsets.only(top: 60, bottom: 20),
          width: double.infinity,
          decoration: const BoxDecoration(color: Color(0xFFAD510D)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Pesanan Saya",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    _buildTabItem("Dikemas"),
                    _buildTabItem("Dikirim"),
                    _buildTabItem("Selesai"),
                    _buildTabItem("Dibatalkan"),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ORDER LIST SECTION
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Di sini kita memanggil fungsi filter untuk menampilkan data yang sesuai
              _getFilteredOrders(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ],
    );
  }

  // Widget Tab dengan fungsi Klik (GestureDetector)
  Widget _buildTabItem(String title) {
    bool isSelected = selectedStatus == title; // Cek apakah tab ini aktif
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedStatus = title; // Ubah status saat di-klik
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFDF2F2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? const Color(0xFFAD510D) : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // 1. Perbaiki Fungsi Filter agar datanya dinamis
  Widget _getFilteredOrders() {
    if (selectedStatus == "Dikemas") {
      return _buildOrderCard("Novel Ancika 1995", "diproses", Colors.orange);
    } else if (selectedStatus == "Dikirim") {
      // Kamu bisa menambahkan data berbeda di sini
      return _buildOrderCard("Sepatu Sneakers", "dikirim", Colors.blue);
    } else if (selectedStatus == "Selesai") {
      return _buildOrderCard("Kemeja Polos", "selesai", Colors.green);
    } else {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 50),
          child: Text("Belum ada pesanan dibatalkan"),
        ),
      );
    }
  }

  // 2. Tambahkan parameter (String nama, String status, Color warna) agar kartu bisa berubah
  Widget _buildOrderCard(
    String namaProduk,
    String statusLabel,
    Color warnaStatus,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15), // Tambahkan margin antar kartu
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blueGrey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "No. Pesanan",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    "12345678",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: warnaStatus.withOpacity(
                    0.1,
                  ), // Warna background transparan
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  statusLabel, // MENGGUNAKAN VARIABEL
                  style: TextStyle(color: warnaStatus, fontSize: 12),
                ),
              ),
            ],
          ),
          const Divider(height: 30),
          Row(
            children: [
              Container(
                width: 60,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.book, color: Colors.grey),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      namaProduk, // MENGGUNAKAN VARIABEL
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Text("1 item", style: TextStyle(color: Colors.grey)),
                    const Text(
                      "Rp. 50.000",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "10 April 2026, 22.39",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE5E7EB),
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text("Batalkan", style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
