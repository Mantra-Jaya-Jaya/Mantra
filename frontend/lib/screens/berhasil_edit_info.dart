import 'dart:ui';
import 'package:flutter/material.dart';
import 'profile_customer.dart';

class BerhasilEditInfo extends StatelessWidget {
  const BerhasilEditInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: Stack(
        children: [

          // ================= BACKGROUND PROFILE =================
          SingleChildScrollView(
            child: Column(
              children: [

                // HEADER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 70,
                    bottom: 25,
                  ),
                  color: const Color(0xFFE3CDBD),
                  child: const Center(
                    child: Text(
                      "Profil Saya",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // FOTO PROFILE
                CircleAvatar(
                  radius: 55,
                  backgroundImage: AssetImage(
                    "assets/images/profile.jpg",
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  "Aarav Lysander",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  "lysander@gmail.com",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 25),

                // CARD INFORMASI
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAEFEF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [

                      buildInfoTile(
                        Icons.person_outline,
                        "Nama Lengkap",
                        "Aarav Lysander",
                      ),

                      const SizedBox(height: 15),

                      buildInfoTile(
                        Icons.phone,
                        "Nomor Telephone",
                        "+62 89000000000",
                      ),

                      const SizedBox(height: 15),

                      buildInfoTile(
                        Icons.email_outlined,
                        "Email",
                        "lysander@gmail.com",
                      ),

                      const SizedBox(height: 15),

                      buildInfoTile(
                        Icons.key_outlined,
                        "Username",
                        "@aarav_",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),

          // ================= BLUR BACKGROUND =================
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 6,
              sigmaY: 6,
            ),
            child: Container(
              color: Colors.black.withOpacity(0.15),
            ),
          ),

          // ================= POPUP BERHASIL =================
          Center(
            child: Container(
              width: 300,
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 30,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 12,
                    color: Colors.black26,
                    offset: Offset(0, 4),
                  ),
                ],
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // ICON
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0x33AF510C),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Color(0xFFAF510C),
                      size: 42,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // TITLE
                  const Text(
                    "Data berhasil\ndiubah!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFAF510C),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // SUBTITLE
                  const Text(
                    "Perubahan profil Anda telah\nberhasil disimpan.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Profil(),
                          ),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFAF510C),
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "OK",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
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

  // ================= WIDGET TILE =================
  Widget buildInfoTile(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [

          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0x33AF510C),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFAF510C),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}