import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/models/user_model.dart'; // Sesuaikan dengan path UserModel kamu
import '../../core/services/kasir_profile_service.dart'; // Sesuaikan dengan path KasirProfileService kamu
import '../auth/login.dart'; // Sesuaikan dengan path LoginScreen kamu

class ProfileKasir extends StatefulWidget {
  const ProfileKasir({super.key});

  @override
  ProfileKasirState createState() => ProfileKasirState();
}

class ProfileKasirState extends State<ProfileKasir> {
  final KasirProfileService _kasirService = KasirProfileService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  late Future<UserModel> _profileFuture;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    _profileFuture = _kasirService.getProfil().then((data) => UserModel.fromJson(data));
  }

  // Dialog konfirmasi logout custom anti-stuck
  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Container(
            width: 300,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0x1FAF510C),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.logout,
                    color: Color(0xFFAF510C),
                    size: 42,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  "Keluar dari Akun?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Kamu yakin ingin keluar\ndari akun ini?",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    // Tombol Tidak — kembali ke profil
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          side: const BorderSide(color: Color(0xFFAF510C)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Tidak",
                          style: TextStyle(color: Color(0xFFAF510C)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Tombol Iya — hapus token lokal secara instan & jalankan API di background
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context); // Tutup dialog konfirmasi

                          // Tampilkan loading overlay
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Center(
                              child: CircularProgressIndicator(color: Color(0xFFAF510C)),
                            ),
                          );

                          // 1. UTAMAKAN: Hapus token lokal secara instan agar tidak tersandera error API
                          await _storage.deleteAll();

                          // 2. Jalankan API logout di background tanpa 'await' (fire-and-forget)
                          _kasirService.logout().catchError((error) {
                            debugPrint("API Logout error (ignored): $error");
                          });

                          if (!mounted) return;
                          Navigator.pop(context); // Tutup loading overlay

                          // 3. Langsung tendang ke halaman login dan bersihkan seluruh history navigation
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFAF510C),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Iya",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget tombol logout custom OutlinedButton
  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 38),
      child: OutlinedButton.icon(
        onPressed: _showLogoutDialog, 
        icon: const Icon(Icons.logout, color: Color(0xFFAF510C)),
        label: const Text(
          "Keluar dari Akun",
          style: TextStyle(color: Color(0xFFAF510C), fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          side: const BorderSide(color: Color(0xFFAF510C), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints.expand(),
          color: const Color(0xFFFFFFFF),
          child: FutureBuilder<UserModel>(
            future: _profileFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFAF510C)),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
                      const SizedBox(height: 10),
                      Text("Gagal memuat profil: ${snapshot.error}"),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _loadProfile();
                          });
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFAF510C)),
                        child: const Text("Coba Lagi", style: TextStyle(color: Colors.white)),
                      )
                    ],
                  ),
                );
              }

              final user = snapshot.data!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      color: const Color(0xFFFFFFFF),
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(bottom: 50),
                              width: double.infinity,
                              child: Column(
                                children: [
                                  // Header Orange
                                  IntrinsicHeight(
                                    child: Container(
                                      color: const Color(0xFFAF510C),
                                      padding: const EdgeInsets.only(top: 40, bottom: 20, left: 30),
                                      margin: const EdgeInsets.only(bottom: 24),
                                      width: double.infinity,
                                      child: const Text(
                                        "Profile Kasir",
                                        style: TextStyle(
                                          color: Color(0xFFFFFFFF),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  
                                  // Foto Profil
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 23),
                                    width: 85,
                                    height: 83,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(40),
                                      child: Image.network(
                                        (user.fotoProfil != null && user.fotoProfil!.isNotEmpty)
                                            ? user.fotoProfil!
                                            : "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/I5ymBTe5W6/n8ic1gkq_expires_30_days.png",
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Icon(Icons.account_circle, size: 85, color: Colors.grey);
                                        },
                                      ),
                                    ),
                                  ),
                                  
                                  // Informasi Akun Card
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xFFBFC9D1),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 15),
                                    margin: const EdgeInsets.only(bottom: 31, left: 38, right: 38),
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Center(
                                          child: Text(
                                            "Informasi Akun",
                                            style: TextStyle(
                                              color: Color(0xFF000000),
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        const Divider(color: Color(0xFFBFC9D1), height: 1),
                                        const SizedBox(height: 12),
                                        
                                        const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 22),
                                          child: Text(
                                            "Nama Lengkap",
                                            style: TextStyle(color: Colors.grey, fontSize: 13),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 22),
                                          child: Text(
                                            user.namaLengkap.isNotEmpty ? user.namaLengkap : 'Kasir',
                                            style: const TextStyle(
                                              color: Color(0xFF000000),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 14),
                                        const Divider(color: Color(0xFFBFC9D1), height: 1),
                                        const SizedBox(height: 12),
                                        
                                        const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 22),
                                          child: Text(
                                            "Email",
                                            style: TextStyle(color: Colors.grey, fontSize: 13),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 22),
                                          child: Text(
                                            user.email.isNotEmpty ? user.email : '-',
                                            style: const TextStyle(
                                              color: Color(0xFF000000),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  // Memanggil Tombol Keluar Akun
                                  _buildLogoutButton(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}