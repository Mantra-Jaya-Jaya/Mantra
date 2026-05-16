import 'package:flutter/material.dart';
import 'edit_informasi_akun.dart';
import 'ubah_password.dart';
import 'tambah_alamat.dart';
import 'edit_alamat.dart';
import '../../main.dart'; // sesuaikan path jika berbeda
import '../landing_page/landing_page.dart'; // sesuaikan path jika berbeda

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  List<Map<String, dynamic>> _daftarAlamat = [
    {
      'label': 'Rumah',
      'nama': 'Aarav Lysander',
      'telepon': '+62 89000000000',
      'alamat': 'Jl. Cempaka Putih No. 12, RT 04/RW 02, Semarang Tengah',
      'isPrimary': true,
    },
    {
      'label': 'Kantor',
      'nama': 'Sujarwo',
      'telepon': '+62 81200000000',
      'alamat': 'Jl. Sumurboto No. 04, Kota Semarang',
      'isPrimary': false,
    },
  ];

  void _showSuccessDialog({required String title, required String message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
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
                    color: const Color(0x33AF510C),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(Icons.check_circle, color: Color(0xFFAF510C), size: 42),
                ),
                const SizedBox(height: 18),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFAF510C),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFAF510C),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      "OK",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
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
                    color: const Color(0x1FE53935),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(Icons.delete_outline, color: Colors.red, size: 42),
                ),
                const SizedBox(height: 18),
                const Text(
                  "Hapus Alamat?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Alamat ini akan dihapus secara permanen.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          side: const BorderSide(color: Color(0xFFAF510C)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Batal", style: TextStyle(color: Color(0xFFAF510C))),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _daftarAlamat.removeAt(index);
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Hapus", style: TextStyle(color: Colors.white)),
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

  // Dialog konfirmasi logout
  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
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
                  child: const Icon(Icons.logout, color: Color(0xFFAF510C), size: 42),
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Tidak", style: TextStyle(color: Color(0xFFAF510C))),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Tombol Iya — arahkan ke LandingPage, hapus semua history
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const LandingPage()),
                            (route) => false, // hapus semua route sebelumnya
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFAF510C),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Iya", style: TextStyle(color: Colors.white)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                color: const Color(0xFFAF510C),
                child: const Text(
                  "Profil Saya",
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 55,
                backgroundImage: AssetImage("assets/images/profile.jpg"),
              ),
              const SizedBox(height: 12),
              const Text("Aarav Lysander", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text("lysander@gmail.com", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 24),

              // Informasi Akun
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAEFEF),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Informasi Akun",
                          style: TextStyle(color: Color(0xFFAF510C), fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        OutlinedButton.icon(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const EditInformasiAkun()),
                            );
                            if (result == 'success') {
                              _showSuccessDialog(
                                title: "Data berhasil\ndiubah!",
                                message: "Perubahan profil Anda telah\nberhasil disimpan.",
                              );
                            }
                          },
                          icon: const Icon(Icons.edit, size: 16, color: Color(0xFFAF510C)),
                          label: const Text("Edit", style: TextStyle(color: Color(0xFFAF510C))),
                          style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFAF510C))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    buildInfoTile(Icons.person_outline, "Nama Lengkap", "Aarav Lysander"),
                    buildInfoTile(Icons.phone, "Nomor Telephone", "+62 89000000000"),
                    buildInfoTile(Icons.email_outlined, "Email", "lysander@gmail.com"),
                    buildInfoTile(Icons.key_outlined, "Username", "@aarav_"),

                    // Baris Password
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
                        const Expanded(child: Text("Password", style: TextStyle(fontWeight: FontWeight.bold))),
                        ElevatedButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const UbahPassword()),
                            );
                            if (result == true) {
                              _showSuccessDialog(
                                title: "Password berhasil\ndiubah!",
                                message: "Perubahan password Anda telah\nberhasil disimpan.",
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFAF510C)),
                          child: const Text("Ubah", style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              _buildDaftarAlamat(),
              const SizedBox(height: 20),
              _buildLogoutButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoTile(IconData icon, String title, String subtitle) {
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
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDaftarAlamat() {
    return Container(
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
            style: TextStyle(color: Color(0xFFAF510C), fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          ...List.generate(_daftarAlamat.length, (index) {
            final item = _daftarAlamat[index];
            return Column(
              children: [
                buildAddressCard(
                  index: index,
                  label: item['label'],
                  nama: item['nama'],
                  telepon: item['telepon'],
                  alamat: item['alamat'],
                  isPrimary: item['isPrimary'],
                ),
                if (index < _daftarAlamat.length - 1) const SizedBox(height: 14),
              ],
            );
          }),

          const SizedBox(height: 16),
          TextButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AlamatBaru()),
              );
              if (result != null && result is Map<String, dynamic>) {
                setState(() {
                  _daftarAlamat.add(result);
                });
                _showSuccessDialog(
                  title: "Alamat berhasil\ndisimpan!",
                  message: "Alamat baru Anda telah\nberhasil ditambahkan.",
                );
              }
            },
            child: const Text(
              "+ Tambah Alamat Baru",
              style: TextStyle(color: Color(0xFFAF510C), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAddressCard({
    required int index,
    required String label,
    required String nama,
    required String telepon,
    required String alamat,
    required bool isPrimary,
  }) {
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
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              if (isPrimary)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0x33AF510C),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Utama",
                    style: TextStyle(color: Color(0xFFAF510C), fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(alamat, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 12),

          // Tombol Edit & Hapus
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditAlamat(
                        labelAwal: label,
                        namaAwal: nama,
                        teleponAwal: telepon,
                        alamatAwal: alamat,
                      ),
                    ),
                  );
                  if (result != null && result is Map) {
                    setState(() {
                      _daftarAlamat[index]['label'] = result['label'];
                      _daftarAlamat[index]['nama'] = result['nama'];
                      _daftarAlamat[index]['telepon'] = result['telepon'];
                      _daftarAlamat[index]['alamat'] = result['alamat'];
                    });
                    _showSuccessDialog(
                      title: "Alamat berhasil\ndiubah!",
                      message: "Perubahan alamat Anda telah\nberhasil disimpan.",
                    );
                  }
                },
                icon: const Icon(Icons.edit, size: 16, color: Color(0xFFAF510C)),
                label: const Text("Edit", style: TextStyle(color: Color(0xFFAF510C))),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFAF510C)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: () => _showDeleteDialog(index),
                icon: const Icon(Icons.delete_outline, size: 16, color: Color(0xFFAF510C)),
                label: const Text("Hapus", style: TextStyle(color: Color(0xFFAF510C))),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFAF510C)),
                  backgroundColor: const Color(0x22AF510C),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: OutlinedButton.icon(
        onPressed: _showLogoutDialog, // panggil dialog konfirmasi
        icon: const Icon(Icons.logout, color: Color(0xFFAF510C)),
        label: const Text("Keluar dari Akun", style: TextStyle(color: Color(0xFFAF510C))),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          side: const BorderSide(color: Color(0xFFAF510C)),
        ),
      ),
    );
  }
}