import 'package:flutter/material.dart';
import 'edit_informasi_akun.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ================= BODY =================
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              // ================= HEADER =================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                color: const Color(0xFFAF510C),
                child: const Text(
                  "Profil Saya",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ================= FOTO PROFIL =================
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
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              const Text(
                "lysander@gmail.com",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 24),

              // ================= INFORMASI AKUN =================
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAEFEF),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [

                    // HEADER CARD
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        const Text(
                          "Informasi Akun",
                          style: TextStyle(
                            color: Color(0xFFAF510C),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EditInformasiAkun(),
                                ),
                                );
                          },
                          icon: const Icon(
                            Icons.edit,
                            size: 16,
                            color: Color(0xFFAF510C),
                          ),
                          label: const Text(
                            "Edit",
                            style: TextStyle(
                              color: Color(0xFFAF510C),
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFFAF510C),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    buildInfoTile(
                      Icons.person_outline,
                      "Nama Lengkap",
                      "Aarav Lysander",
                    ),

                    buildInfoTile(
                      Icons.phone,
                      "Nomor Telephone",
                      "+62 89000000000",
                    ),

                    buildInfoTile(
                      Icons.email_outlined,
                      "Email",
                      "lysander@gmail.com",
                    ),

                    buildInfoTile(
                      Icons.key_outlined,
                      "Username",
                      "@aarav_",
                    ),

                    Row(
                      children: [

                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD8B08C),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.lock_outline),
                        ),

                        const SizedBox(width: 12),

                        const Expanded(
                          child: Text(
                            "Password",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFAF510C),
                          ),
                          child: const Text(
                            "Ubah",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ================= DAFTAR ALAMAT =================
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAEFEF),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [

                    const Text(
                      "Daftar Alamat",
                      style: TextStyle(
                        color: Color(0xFFAF510C),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    buildAddressCard(
                      "Cozy House",
                      "Jl. Cempaka Putih No. 12, RT 04/RW 02, Semarang Tengah",
                      true,
                    ),

                    const SizedBox(height: 14),

                    buildAddressCard(
                      "Sujarwo Shockbreaker",
                      "Jl. Sumurboto No. 04, Kota Semarang",
                      false,
                    ),

                    const SizedBox(height: 16),

                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "+ Tambah Alamat Baru",
                        style: TextStyle(
                          color: Color(0xFFAF510C),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ================= LOGOUT =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.logout,
                    color: Color(0xFFAF510C),
                  ),
                  label: const Text(
                    "Keluar dari Akun",
                    style: TextStyle(
                      color: Color(0xFFAF510C),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    side: const BorderSide(
                      color: Color(0xFFAF510C),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      // ================= NAVBAR =================
      bottomNavigationBar: Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Color(0xFFAF510C),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [

            NavItem(
              icon: Icons.home_outlined,
              label: "Home",
            ),

            NavItem(
              icon: Icons.qr_code_scanner,
              label: "Scan",
            ),

            NavItem(
              icon: Icons.receipt_long,
              label: "Orders",
            ),

            NavItem(
              icon: Icons.person,
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }

  // ================= TILE INFO =================
  Widget buildInfoTile(
      IconData icon,
      String title,
      String subtitle,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFD8B08C),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon),
          ),

          const SizedBox(width: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= CARD ALAMAT =================
  Widget buildAddressCard(
      String title,
      String address,
      bool isPrimary,
      ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              if (isPrimary)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0x33AF510C),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Utama",
                    style: TextStyle(
                      color: Color(0xFFAF510C),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            address,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [

              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text("Edit"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFAF510C),
                    side: const BorderSide(
                      color: Color(0xFFAF510C),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.delete, size: 18),
                  label: const Text("Hapus"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ================= NAV ITEM =================
class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const NavItem({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Icon(
          icon,
          color: Colors.white,
        ),

        const SizedBox(height: 4),

        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}