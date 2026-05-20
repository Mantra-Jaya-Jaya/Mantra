// frontend/features/orders/order_model.dart

class OrderItemModel {
  final String namaBarang;
  final int qty;
  final int hargaSatuan;

  OrderItemModel({
    required this.namaBarang,
    required this.qty,
    required this.hargaSatuan,
  });
}

class OrderModel {
  final String orderId;
  final String statusText;
  final String itemsDetail; 
  final String timeInfo;
  final String price;
  final int rawPrice;
  final String imgUrl;
  final bool isOnline;
  final List<OrderItemModel> detailItems; 

  OrderModel({
    required this.orderId,
    required this.statusText,
    required this.itemsDetail,
    required this.timeInfo,
    required this.price,
    required this.rawPrice,
    required this.imgUrl,
    required this.isOnline,
    required this.detailItems,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final int totalBayar = (json['total_pembayaran'] ?? json['TotalPembayaran'] ?? 0).toInt();
    final String tipe = (json['tipe_pesanan'] ?? json['TipePesanan'] ?? 'Offline').toString();
    final String idDatabase = (json['id_pesanan'] ?? json['public_id'] ?? '').toString();

    List<OrderItemModel> items = [];
    if (json['items_list'] != null) {
      items = (json['items_list'] as List).map((i) => OrderItemModel(
        namaBarang: i['nama_barang'] ?? '',
        qty: i['qty'] ?? 0,
        hargaSatuan: i['harga_satuan'] ?? 0,
      )).toList();
    } else {
      items = [
        OrderItemModel(namaBarang: "Kopi Susu Aren", qty: 2, hargaSatuan: 40000),
        OrderItemModel(namaBarang: "Croissant Almond", qty: 1, hargaSatuan: 45000),
      ];
    }

    return OrderModel(
      orderId: idDatabase.isNotEmpty ? "#ORD-$idDatabase" : "#ORD-1000",
      statusText: (json['status_pesanan'] ?? json['StatusPesanan'] ?? 'BARU').toString(),
      itemsDetail: (json['items_detail'] ?? "2x Kopi Susu Aren, 1x Croissant").toString(),
      timeInfo: (json['tanggal_pesanan'] ?? json['TanggalPesanan'] ?? 'Baru saja').toString(),
      price: "Rp ${totalBayar.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
      rawPrice: totalBayar,
      imgUrl: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/I5ymBTe5W6/53kzg4cp_expires_30_days.png",
      isOnline: tipe.toUpperCase() == "ONLINE",
      detailItems: items,
    );
  }
}