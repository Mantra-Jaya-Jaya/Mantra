import 'package:flutter/material.dart';
import '../../core/widgets/bottom_navbar.dart';

class DashboardKasirPage extends StatefulWidget {
  const DashboardKasirPage({super.key});

  @override
  State<DashboardKasirPage> createState() => _DashboardKasirPageState();
}

class _DashboardKasirPageState extends State<DashboardKasirPage> {
  int _currentIndex = 0;

  // Placeholder untuk halaman lain
  final List<Widget> _pages = [
    const DashboardContent(), // Konten utama yang kita buat di bawah
    const Center(child: Text('Halaman Orders')),
    const Center(child: Text('Halaman Payments')),
    const Center(child: Text('Halaman Summary')),
    const Center(child: Text('Halaman Profile')),
  ];

  // Menu sesuai gambar yang kamu kirim
  final List<NavMenuModel> kasirMenus = [
    NavMenuModel(label: 'Home', icon: Icons.home_outlined, index: 0),
    NavMenuModel(label: 'Orders', icon: Icons.assignment_outlined, index: 1),
    NavMenuModel(label: 'Payments', icon: Icons.qr_code_scanner, index: 2),
    NavMenuModel(label: 'Summary', icon: Icons.grid_view, index: 3),
    NavMenuModel(label: 'Profile', icon: Icons.person_outline, index: 4),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: CustomDynamicNavbar(
        currentIndex: _currentIndex,
        menus: kasirMenus,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER SECTION
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
            width: double.infinity,
            decoration: const BoxDecoration(color: Color(0xFFAD510D)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Selasa, 24 Okt 2023',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Halo, Kasir 1',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                  size: 30,
                ),
              ],
            ),
          ),

          // SUMMARY CARD (OVERLAP)
          Transform.translate(
            offset: const Offset(0, -20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Pendapatan Hari Ini',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Icon(Icons.trending_up, color: Color(0xFFAD510D)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Rp 4.250.000',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFAD510D),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _smallStatItem(
                          Icons.receipt_long,
                          'Total Transaksi',
                          '42',
                        ),
                        const SizedBox(width: 15),
                        _smallStatItem(
                          Icons.inventory_2_outlined,
                          'Item Terjual',
                          '128',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // AKTIVITAS TERKINI
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Aktivitas Terkini',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Lihat Semua',
                    style: TextStyle(color: Color(0xFFAD510D)),
                  ),
                ),
              ],
            ),
          ),

          // TRANSACTION LIST
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  _transactionItem(
                    'INV-20231024-042',
                    'Tunai • 14:30',
                    'Rp 125.000',
                  ),
                  const Divider(height: 1),
                  _transactionItem(
                    'INV-20231024-041',
                    'QRIS • 14:15',
                    'Rp 85.000',
                  ),
                  const Divider(height: 1),
                  _transactionItem(
                    'INV-20231024-040',
                    'Kartu Debit • 13:50',
                    'Rp 210.000',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 100), // Spasi agar tidak tertutup navbar
        ],
      ),
    );
  }

  Widget _smallStatItem(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: Colors.grey),
                const SizedBox(width: 5),
                Text(
                  label,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _transactionItem(String id, String subtitle, String price) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F4F7),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check_circle_outline, color: Colors.grey),
      ),
      title: Text(
        id,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: Text(
        price,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }
}
