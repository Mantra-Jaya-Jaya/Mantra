import 'package:flutter/material.dart';
import '../../core/widgets/base_header_widget.dart'; // Sesuaikan path ini dengan folder project-mu
import 'order_model.dart';
import 'detailpesanan_kasir.dart'; 

// ==================== KASIR PAGE ====================
class OrderKasir extends StatefulWidget {
  const OrderKasir({super.key});

  @override
  OrderKasirState createState() => OrderKasirState();
}

class OrderKasirState extends State<OrderKasir> {
  bool isOnlineTab = true; 
  List<OrderModel> ordersList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => isLoading = true);

    try {
      // Simulasi penarikan data dari backend
      await Future.delayed(const Duration(milliseconds: 500));

      final List<Map<String, dynamic>> mockJsonResponse = [
        {
          "id": 1045,
          "total_pembayaran": 126500,
          "tanggal_pesanan": "24 Oct 2023, 14:30 WIB",
          "tipe_pesanan": "Online",
          "status_pesanan": "Diproses",
          "items_detail": "2x Americano Iced, 1x Caffe Latte, 2x Choco Glaze Donut"
        },
      ];

      final parsedData = mockJsonResponse.map((json) => OrderModel.fromJson(json)).toList();

      if (mounted) {
        setState(() {
          ordersList = parsedData;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
      print("❌ Eror memuat data: $e");
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'diproses': return const Color(0xFFFFEDD5);
      case 'selesai': return const Color(0xFFDCFCE7);
      default: return const Color(0xFFE5E7EB);
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'diproses': return const Color(0xFFAF510C);
      case 'selesai': return const Color(0xFF15803D);
      default: return const Color(0xFF374151);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredOrders = ordersList.where((order) => order.isOnline == isOnlineTab).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: BaseHeaderWidget(
        title: "Daftar Pesanan",
        hasRadius: false,
        actions: const [],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // Tab Toggle
          Container(
            height: 48,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: const Color(0xFFAF510C)),
            child: Row(
              children: [
                _buildTabButton("Online", true),
                _buildTabButton("Offline", false),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFFAF510C)))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) => _buildOrderItem(filteredOrders[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, bool isOnline) {
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => isOnlineTab = isOnline),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isOnlineTab == isOnline ? const Color(0xFFEAEFEF) : Colors.transparent,
          ),
          child: Text(label, style: TextStyle(color: isOnlineTab == isOnline ? const Color(0xFFAF510C) : Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildOrderItem(OrderModel order) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPesanan(pesanan: order),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(order.imgUrl, width: 52, height: 52, fit: BoxFit.cover)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(order.orderId, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: _getStatusColor(order.statusText), borderRadius: BorderRadius.circular(6)),
                        child: Text(order.statusText, style: TextStyle(color: _getStatusTextColor(order.statusText), fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(order.itemsDetail, style: const TextStyle(color: Color(0xFF566067), fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(order.timeInfo, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      Text(order.price, style: const TextStyle(color: Color(0xFFAF510C), fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}