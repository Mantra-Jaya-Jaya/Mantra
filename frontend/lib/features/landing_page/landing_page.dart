import 'package:flutter/material.dart';
import 'package:frontend/features/landing_page/onboarding_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  // 1. Controller untuk mengatur slide
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  // 2. Data konten untuk masing-masing halaman
  final List<Map<String, String>> _landingData = [
    {
      'image': 'assets/images/landing1.png',
      'title': 'Solusi Belanja\nModern',
      'desc':
          'Belanja kebutuhan jadi lebih mudah. Pesan produk favoritmu langsung dari aplikasi.',
    },
    {
      'image': 'assets/images/landing2.png',
      'title': 'Kualitas\nTerjamin',
      'desc':
          'Semua produk yang kami sediakan telah melalui proses seleksi kualitas yang ketat.',
    },
    {
      'image': 'assets/images/landing3.png',
      'title': 'Pengiriman\nCepat',
      'desc':
          'Nikmati layanan pengiriman instan yang memastikan pesanan sampai tepat waktu.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // BAGIAN ATAS: PageView untuk Gambar & Lengkungan
          Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.55,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemCount: _landingData.length,
                  itemBuilder: (context, index) {
                    return Image.asset(
                      _landingData[index]['image']!,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              // Lengkungan Putih (Tetap di posisi yang sama)
              Positioned(
                bottom: -1,
                left: 0,
                right: 0,
                child: ClipPath(
                  clipper: CurveClipper(),
                  child: Container(height: 100, color: Colors.white),
                ),
              ),
            ],
          ),

          // BAGIAN BAWAH: Konten Teks yang berubah sesuai Index
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // Indikator Titik (Dots)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _landingData.length,
                      (index) => _buildDot(index == _currentIndex),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Judul
                  Text(
                    _landingData[_currentIndex]['title']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B2E35),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Deskripsi
                  Text(
                    _landingData[_currentIndex]['desc']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),
                  const Spacer(),
                  // TOMBOL NAVIGASI (Sebelumnya & Selanjutnya)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Tombol Sebelumnya (Hanya muncul jika bukan di halaman pertama)
                        _currentIndex > 0
                            ? TextButton(
                                onPressed: () {
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                child: const Text(
                                  'Sebelumnya',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),

                        // Tombol Selanjutnya (Panah)
                        GestureDetector(
                          onTap: () {
                            if (_currentIndex < _landingData.length - 1) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              // Jika sudah di halaman terakhir, arahkan ke login/home
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const WelcomePage(),
                                ),
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: const BoxDecoration(
                              color: Color(0xFFC4CACC),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _currentIndex == _landingData.length - 1
                                  ? Icons
                                        .check // Centang di halaman terakhir
                                  : Icons.arrow_forward_ios,
                              color: const Color(0xFF1B2E35),
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 12 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFAD510D) : Colors.orange.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width / 2, 0, size.width, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
