import 'package:flutter/material.dart';
import 'checkout.dart'; // Pastikan import halaman checkout
import 'package:frontend/core/widgets/base_header_widget.dart';

class CartCustomerPage extends StatefulWidget {
  const CartCustomerPage({super.key});

  @override
  State<CartCustomerPage> createState() => _CartCustomerPageState();
}

class _CartCustomerPageState extends State<CartCustomerPage> {
  // Mock data keranjang awal dengan field 'isSelected' untuk melacak centang
  List<Map<String, dynamic>> cartItems = [
    {
      'id': 1,
      'imagePath': 'assets/images/produk.png',
      'title': 'Mug Coffe 510 ml',
      'subtitle': 'Detail Pemesanan',
      'price': 50000,
      'quantity': 1,
      'isSelected': false,
    },
    {
      'id': 2,
      'imagePath': 'assets/images/produk.png',
      'title': 'Totebag',
      'subtitle': 'Detail Pemesanan',
      'price': 50000,
      'quantity': 2,
      'isSelected': false,
    },
    {
      'id': 3,
      'imagePath': 'assets/images/produk.png',
      'title': 'Heels Wanita',
      'subtitle': 'Detail Pemesanan',
      'price': 100000,
      'quantity': 2,
      'isSelected': false,
    },
    {
      'id': 4,
      'imagePath': 'assets/images/produk.png',
      'title': 'Dress Elegan',
      'subtitle': 'Detail Pemesanan',
      'price': 50000,
      'quantity': 1,
      'isSelected': false,
    },
  ];

  // Menghitung total harga dari item yang dicentang saja
  int get totalHargaCentang {
    int total = 0;
    for (var item in cartItems) {
      if (item['isSelected'] == true) {
        total += (item['price'] as int) * (item['quantity'] as int);
      }
    }
    return total;
  }

  String _formatRupiah(int number) {
    return 'Rp. ${number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    bool isAnyItemSelected = cartItems.any(
      (item) => item['isSelected'] == true,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: BaseHeaderWidget(
        title: 'Keranjang Saya',

        leading: IconButton(
          onPressed: () => Navigator.pop(context),

          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),

      body: Column(
        children: [
          // List Item
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                ...List.generate(cartItems.length, (index) {
                  return _buildCartItem(index);
                }),
                const SizedBox(height: 20),

                // Total Pesanan Box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Pesanan',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatRupiah(totalHargaCentang),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isAnyItemSelected
                              ? () {
                                  // Ambil hanya item yang diberi centang
                                  List<Map<String, dynamic>> selectedItems =
                                      cartItems
                                          .where(
                                            (item) =>
                                                item['isSelected'] == true,
                                          )
                                          .toList();

                                  // Pindah ke Checkout dengan membawa data belanjaan
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Checkout(
                                        selectedProducts: selectedItems,
                                      ),
                                    ),
                                  );
                                }
                              : null, // Mati jika tidak ada yang dicentang
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFAD510D),
                            disabledBackgroundColor: Colors.grey.shade300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Lanjut ke Checkout',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(int index) {
    var item = cartItems[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox Custom
              GestureDetector(
                onTap: () {
                  setState(() {
                    item['isSelected'] = !item['isSelected'];
                  });
                },
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: item['isSelected']
                        ? const Color(0xFFAD510D)
                        : Colors.white,
                    border: Border.all(
                      color: item['isSelected']
                          ? const Color(0xFFAD510D)
                          : Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: item['isSelected']
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: AssetImage(item['imagePath']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['subtitle'],
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatRupiah(item['price']),
                      style: const TextStyle(
                        color: Color(0xFFAD510D),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (item['quantity'] > 1) {
                        setState(() => item['quantity']--);
                      }
                    },
                    child: _quantityButton(Icons.remove),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      item['quantity'].toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() => item['quantity']++);
                    },
                    child: _quantityButton(Icons.add),
                  ),
                ],
              ),
              const Icon(Icons.delete_outline, color: Colors.redAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quantityButton(IconData icon) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 18, color: Colors.black54),
    );
  }
}
