import 'package:flutter/material.dart';
import 'package:frontend/features/auth/login.dart';
import 'package:frontend/features/auth/signup.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 1. Bagian Atas: Background Oranye dengan Gambar & Logo
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFAD510D), // Warna cokelat/oranye MANTRA
                ),
                child: Opacity(
                  opacity: 0.3, // Membuat gambar background agak transparan
                  child: Image.asset(
                    'assets/images/onboard.png', // Gambar motor/kurir di background
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Lengkungan Putih di bagian bawah
              Positioned(
                bottom: -1,
                left: 0,
                right: 0,
                child: ClipPath(
                  clipper: CurveClipper(),
                  child: Container(height: 120, color: Colors.white),
                ),
              ),
              // Logo MANTRA di tengah-tengah
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/logo_putih_notext.png', // Logo icon MANTRA
                    width: 80,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'MANTRA',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Text(
                    'Management & Transaction',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),

          // 2. Bagian Bawah: Teks Selamat Datang & Tombol
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  const Text(
                    'Selamat Datang',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B2E35),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Dapatkan produk favoritmu dengan mudah di mana saja, kapan saja',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),
                  const Spacer(),
                  // Tombol Log In
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFAD510D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Tombol Sign Up
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFFAD510D),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFAD510D),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Clipper (Gunakan yang sama dengan halaman Landing sebelumnya)
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
