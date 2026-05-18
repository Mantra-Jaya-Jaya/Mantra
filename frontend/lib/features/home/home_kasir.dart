import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/bottom_navbar.dart';
import 'package:frontend/features/home/services/dashboard_kasir_service.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../auth/login.dart';

class DashboardKasirPage extends StatefulWidget {
  const DashboardKasirPage({super.key});

  @override
  State<DashboardKasirPage> createState() => _DashboardKasirPageState();
}

class _DashboardKasirPageState extends State<DashboardKasirPage> {
  int _currentIndex = 0;

  // Placeholder untuk halaman lain
  final List<Widget> _pages = [
    const DashboardContent(),
    const Center(child: Text('Halaman Orders')),
    const Center(child: Text('Halaman Payments')),
    const Center(child: Text('Halaman Summary')),
    const ProfileKasirPlaceholder(),
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

class ProfileKasirPlaceholder extends StatelessWidget {
  const ProfileKasirPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Halaman Profile Kasir', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () async {
              // Hapus semua token
              await const FlutterSecureStorage().deleteAll();
              if (!context.mounted) return;
              // Arahkan ke halaman Login
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text("Logout", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          )
        ],
      ),
    );
  }
}

class DashboardContent extends StatefulWidget {
  const DashboardContent({super.key});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  final DashboardKasirService _service = DashboardKasirService();
  final _currencyFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  DashboardKasirData? _data;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null).then((_) => _loadDashboard());
  }

  Future<void> _loadDashboard() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final data = await _service.getDashboard();
      if (mounted) {
        setState(() {
          _data = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Gagal memuat data dashboard';
          _isLoading = false;
        });
      }
    }
  }

  String get _hariIniLabel {
    final now = DateTime.now();
    final formatter = DateFormat('EEEE, d MMM y', 'id_ID');
    return formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFAD510D)),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadDashboard,
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFAD510D)),
              child: const Text('Coba Lagi',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    final data = _data!;

    return RefreshIndicator(
      color: const Color(0xFFAD510D),
      onRefresh: _loadDashboard,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
                    children: [
                      Text(
                        _hariIniLabel,
                        style:
                            const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Halo, ${data.namaKasir}',
                        style: const TextStyle(
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
                        color: Colors.black.withValues(alpha: 0.05),
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
                      Text(
                        _currencyFormat.format(data.totalPendapatan),
                        style: const TextStyle(
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
                            '${data.jumlahTransaksi}',
                          ),
                          const SizedBox(width: 15),
                          _smallStatItem(
                            Icons.inventory_2_outlined,
                            'Item Terjual',
                            '${data.totalItemTerjual}',
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
              child: data.aktivitasTerkini.isEmpty
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Center(
                        child: Text(
                          'Belum ada aktivitas hari ini',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: data.aktivitasTerkini.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final item = entry.value;
                          return Column(
                            children: [
                              if (idx > 0) const Divider(height: 1),
                              _transactionItem(
                                item.nomorInvoice,
                                '${_capitalize(item.metodePembayaran)} • ${item.waktu}',
                                _currencyFormat.format(item.totalBayar),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
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
                Flexible(
                  child: Text(
                    label,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
        decoration: const BoxDecoration(
          color: Color(0xFFF0F4F7),
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
