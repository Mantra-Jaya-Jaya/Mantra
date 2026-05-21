import 'package:flutter/material.dart';
import 'package:frontend/features/cart/cart_customer.dart';
import 'package:frontend/features/orders/order_customer.dart';
import 'package:frontend/features/notifications/notification_customer.dart';
import 'package:frontend/features/profile/profile_customer.dart';
import 'package:frontend/features/scan/scan_customer.dart';
import 'package:frontend/core/widgets/bottom_navbar.dart';
import 'package:frontend/features/home/services/katalog_service.dart';
import 'package:frontend/features/home/kategori_barang_customer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:intl/intl.dart';

// ✅ Deklarasi RouteObserver global untuk mendeteksi navigasi halaman
final RouteObserver<Route> routeObserver = RouteObserver<Route>();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const ScanPage(),
    const MyOrderPage(),
    const Profil(),
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

// Widget konten utama Home — terhubung ke API
class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final KatalogService _katalogService = KatalogService();
  final _currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  List<KategoriModel> _kategoriList = [];
  List<BarangModel> _barangList = [];
  List<PromoModel> _promoList = [];
  bool _isLoadingKategori = true;
  bool _isLoadingBarang = true;
  String? _errorKategori;
  String? _errorBarang;
  int _currentPromoIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _loadPromo();
    _loadKategori();
    _loadBarang();
  }

  Future<void> _loadPromo() async {
    try {
      final data = await _katalogService.getPromoAktif();
      if (mounted) setState(() => _promoList = data);
    } catch (_) {
      // Promo gagal load — tidak perlu error state, cukup tampilkan fallback
    }
  }

  Future<void> _loadKategori() async {
    setState(() {
      _isLoadingKategori = true;
      _errorKategori = null;
    });
    try {
      final data = await _katalogService.getKategori(limit: 8);
      if (mounted) {
        setState(() {
          _kategoriList = data.take(8).toList();
          _isLoadingKategori = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorKategori = 'Gagal memuat kategori';
          _isLoadingKategori = false;
        });
      }
    }
  }

  Future<void> _loadBarang() async {
    setState(() {
      _isLoadingBarang = true;
      _errorBarang = null;
    });
    try {
      final data = await _katalogService.getDaftarBarang(limit: 6);
      if (mounted) {
        setState(() {
          _barangList = data;
          _isLoadingBarang = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorBarang = 'Gagal memuat produk';
          _isLoadingBarang = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: const Color(0xFFAD510D),
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
                  // Banner Promo Dinamis
                  _buildPromoBanner(),
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
            _buildKategoriSection(),

            // Rekomendasi Section
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Text(
                'Rekomendasi Untuk Anda',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            _buildBarangSection(),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoBanner() {
    // Jika tidak ada promo dari API, tampilkan gambar statis
    if (_promoList.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 150,
          width: double.infinity,
          color: Colors.orange.shade100,
          child: Image.asset(
            'assets/images/promo.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Center(
              child: Icon(
                Icons.local_offer_outlined,
                size: 48,
                color: Colors.orange,
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 150,
          child: PageView.builder(
            itemCount: _promoList.length,
            onPageChanged: (index) {
              setState(() => _currentPromoIndex = index);
            },
            itemBuilder: (context, index) {
              final promo = _promoList[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: promo.bannerUrl.isNotEmpty
                      ? Image.network(
                          promo.bannerUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: Colors.orange.shade100,
                                child: Center(
                                  child: Text(
                                    promo.namaDiskon,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFAD510D),
                                    ),
                                  ),
                                ),
                              ),
                        )
                      : Container(
                          color: Colors.orange.shade100,
                          child: Center(
                            child: Text(
                              promo.namaDiskon,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFAD510D),
                              ),
                            ),
                          ),
                        ),
                ),
              );
            },
          ),
        ),
        if (_promoList.length > 1) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_promoList.length, (i) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _currentPromoIndex == i ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPromoIndex == i
                      ? Colors.white
                      : Colors.white54,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }

  Widget _buildKategoriSection() {
    if (_isLoadingKategori) {
      return const SizedBox(
        height: 90,
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFFAD510D)),
        ),
      );
    }

    // 2. Kondisi jika API error atau data di database kosong (Fallback statis dihapus)
    if (_errorKategori != null || _kategoriList.isEmpty) {
      return const SizedBox(
        height: 90,
        child: Center(
          child: Text(
            'Belum ada kategori.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    // 3. Menampilkan Data Dinamis dari API
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        childAspectRatio: 0.85,
      ),
      itemCount: _kategoriList.length,
      itemBuilder: (context, index) {
        final k = _kategoriList[index];

        // BUNGKUS DI SINI
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => KategoriBarangPage(
                  initialCategory: k.namaKategori, // Nama kategori yang diklik
                  apiCategories: _kategoriList, // Kirim seluruh list kategori
                ),
              ),
            );
          },
          // Memanggil k.iconKategori dari service/model kamu dan mem-parsingnya ke package MdiIcons
          child: _catItem(k.namaKategori, getIconFromString(k.iconKategori)),
        );
      },
    );
  }

  Widget _buildBarangSection() {
    if (_isLoadingBarang) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFFAD510D)),
        ),
      );
    }

    if (_errorBarang != null) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
              const SizedBox(height: 8),
              Text(_errorBarang!, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _loadBarang,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFAD510D),
                ),
                child: const Text(
                  'Coba Lagi',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_barangList.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: Text('Belum ada produk tersedia.')),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _barangList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.78,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemBuilder: (context, index) {
          return _prodCard(_barangList[index]);
        },
      ),
    );
  }

  Widget _catItem(String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFAD510D).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFFAD510D), size: 30),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 11),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _prodCard(BarangModel barang) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: barang.gambarBarang.isNotEmpty
                  ? Image.network(
                      barang.gambarBarang,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.shade100,
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.grey.shade100,
                      child: const Center(
                        child: Icon(
                          Icons.inventory_2_outlined,
                          color: Colors.grey,
                          size: 40,
                        ),
                      ),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  barang.namaBarang,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 2),
                if (barang.punyaDiskon) ...[
                  Text(
                    _currencyFormat.format(barang.hargaTerendah),
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  Text(
                    _currencyFormat.format(barang.hargaDiskon),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFAD510D),
                      fontSize: 13,
                    ),
                  ),
                ] else ...[
                  Text(
                    _currencyFormat.format(barang.hargaTerendah),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Helper fungsi untuk mengambil ikon berdasarkan string dari DB
IconData getIconFromString(String? iconName) {
  if (iconName == null) return Icons.category_outlined;

  // Fungsi bawaan package untuk mencari IconData berdasarkan string namanya
  return MdiIcons.fromString(iconName) ?? Icons.category_outlined;
}
