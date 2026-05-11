import 'package:flutter/material.dart';
import 'features/cart/cart_customer.dart';
import 'features/orders/order_customer.dart';
import 'features/notifications/notification_customer.dart';
import 'features/profile/profile_customer.dart'; // 1. Import file temanmu
import 'features/scan/scan_customer.dart';
import 'core/widgets/bottom_navbar.dart';

// ✅ Deklarasi RouteObserver global untuk mendeteksi navigasi halaman
final RouteObserver<Route> routeObserver = RouteObserver<Route>();

void main() {
  runApp(const MantraApp());
}

class MantraApp extends StatelessWidget {
  const MantraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        // Tetap gunakan skema warna cokelatmu agar konsisten
        primaryColor: const Color(0xFFAD510D),
      ),
      // ✅ Tambahkan RouteObserver untuk mendeteksi navigasi
      navigatorObservers: [routeObserver],
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // 2. Masukkan widget Profil milik temanmu ke index 3
  final List<Widget> _pages = [
    const HomeContent(),
    const ScanPage(),
    const MyOrderPage(),
    const Profil(), // <--- Widget dari file temanmu
  ];

  final List<NavMenuModel> customerMenus = [
    NavMenuModel(label: 'Home', icon: Icons.home_outlined, index: 0),
    NavMenuModel(label: 'Scan', icon: Icons.qr_code_scanner, index: 1),
    NavMenuModel(label: 'Orders', icon: Icons.assignment_outlined, index: 2),
    NavMenuModel(label: 'Profile', icon: Icons.person_outline, index: 3),
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double navPadding = 20.0;
    double rowWidth = screenWidth - (navPadding * 2);
    double itemWidth = rowWidth / customerMenus.length;
    double fabX =
        (itemWidth * _currentIndex) + (itemWidth / 2) - 28 + navPadding;

    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(index: _currentIndex, children: _pages),
      floatingActionButtonLocation: DynamicFabLocation(fabX),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Logika FAB: Jika sedang di profile, mungkin mau balik ke home
          setState(() => _currentIndex = 0);
        },
        backgroundColor: const Color(0xFFAD510D),
        shape: const CircleBorder(),
        child: Icon(
          customerMenus[_currentIndex].icon,
          color: Colors.white,
          size: 30,
        ),
      ),
      bottomNavigationBar: CustomDynamicNavbar(
        currentIndex: _currentIndex,
        menus: customerMenus,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}

// Widget khusus untuk konten utama Home (Header, Kategori, Rekomendasi)
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
            decoration: const BoxDecoration(
              color: Color(0xFFAD510D),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Cari Barang',
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CartCustomerPage(),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const NotificationCustomerPage(),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.notifications_none_outlined,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/promo.png',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Kategori Section
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Text(
              'Kategori',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            children: [
              _catItem('Tas', Icons.shopping_bag_outlined),
              _catItem('Gadget', Icons.smartphone),
              _catItem('Alat Tulis', Icons.edit_outlined),
              _catItem('Pakaian', Icons.checkroom),
              _catItem('Alat Dapur', Icons.flatware),
              _catItem('Elektronik', Icons.kitchen_outlined),
              _catItem('Buku', Icons.book_outlined),
              _catItem('Sepatu', Icons.ice_skating_outlined),
            ],
          ),

          // Rekomendasi Section
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Text(
              'Rekomendasi Untuk Anda',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                return _prodCard('Produk ${index + 1}', 'Rp. 5.000.000');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _catItem(String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFAD510D).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFFAD510D), size: 30),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _prodCard(String name, String price) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.asset(
                'assets/images/produk.png',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name),
                Text(
                  price,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
