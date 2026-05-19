import 'package:flutter/material.dart';
import '../../core/widgets/base_header_widget.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: BaseHeaderWidget(title: "Pesanan Saya"),

      body: Column(
        children: [
          // TAB SECTION
          Container(
            width: double.infinity,

            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),

            child: Row(
              children: [
                Expanded(child: _buildTabItem("Dikemas")),
                const SizedBox(width: 8),

                Expanded(child: _buildTabItem("Dikirim")),
                const SizedBox(width: 8),

                Expanded(child: _buildTabItem("Selesai")),
                const SizedBox(width: 8),

                Expanded(child: _buildTabItem("Batal")),
              ],
            ),
          ),

          // ORDER LIST
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),

              children: [_getFilteredOrders(), const SizedBox(height: 80)],
            ),
          ),
        ],
      ),
    );
  }

  // Widget Tab dengan fungsi Klik (GestureDetector)
  Widget _buildTabItem(String title) {
    bool isSelected = selectedStatus == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedStatus = title;
        });
      },

      child: Container(
        alignment: Alignment.center,

        padding: const EdgeInsets.symmetric(vertical: 10),

        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFAD510D) : Colors.white,

          borderRadius: BorderRadius.circular(20),
        ),

        child: Text(
          title,

          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.visible,

          textAlign: TextAlign.center,

          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFFAD510D),

            fontWeight: FontWeight.w700,
            fontSize: 11,
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
