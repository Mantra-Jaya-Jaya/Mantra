import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'edit_informasi_akun.dart';
import 'ubah_password.dart';
import 'tambah_alamat.dart';
import 'edit_alamat.dart';
import '../auth/login.dart';
import 'services/profile_service.dart';
import 'package:frontend/core/widgets/base_header_widget.dart';
import 'package:frontend/core/models/alamat_model.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  final ProfileService _profileService = ProfileService();
  bool _isLoading = true;
  bool _hasLoaded = false; // cegah re-fetch saat ganti tab
  String? _errorMessage;
  Map<String, dynamic>? _profil;
  List<AlamatModel> _daftarAlamat = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData({bool forceRefresh = false}) async {
    if (_hasLoaded && !forceRefresh) return;

    if (!_hasLoaded) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }
    try {
      final profilData = await _profileService.getProfil();
      final List<dynamic> alamatRawData = await _profileService.getAlamat();

      // 🌟 3. PARSING data list JSON dari API menjadi List<AlamatModel>
      final List<AlamatModel> alamatData = alamatRawData
          .map((json) => AlamatModel.fromJson(json as Map<String, dynamic>))
          .toList();

      if (mounted) {
        setState(() {
          _profil = profilData;
          _daftarAlamat = alamatData; // Sudah aman bertipe List<AlamatModel>
          _isLoading = false;
          _hasLoaded = true;
          _errorMessage = null;
        });
      }
    } catch (e) {
      print("Error loading profile: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  void _showSuccessDialog({required String title, required String message}) {
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
        );
      },
    );
  }

  void _showDeleteDialog(int index, String idAlamat) {
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: const BoxDecoration(
                    color: Color(0x1FE53935),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 42,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  "Hapus Alamat?",
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Batal",
                          style: TextStyle(color: Color(0xFFAF510C)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          try {
                            // 🌟 Mengirim string UUID ke service backend
                            await _profileService.hapusAlamat(idAlamat);
                            setState(() {
                              _daftarAlamat.removeAt(index);
                            });
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Gagal menghapus alamat'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Hapus",
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

  // Dialog konfirmasi logout
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
                    // Tombol Iya — hapus token lalu ke halaman login
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context); // Tutup dialog dulu
                          // Hapus semua token dari storage
                          await const FlutterSecureStorage().deleteAll();
                          if (!mounted) return;
                          // Arahkan ke login, hapus semua history
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      appBar: BaseHeaderWidget(title: 'Profil Saya'),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: CircularProgressIndicator(color: Color(0xFFAF510C)),
                ),
              )
            else if (_errorMessage != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),

                  child: Text(
                    "Gagal memuat profil:\n$_errorMessage",

                    textAlign: TextAlign.center,

                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              )
            else ...[
              CircleAvatar(
                radius: 55,

                backgroundImage:
                    _profil?['foto_profil'] != null &&
                        _profil!['foto_profil'].isNotEmpty
                    ? NetworkImage(_profil!['foto_profil']) as ImageProvider
                    : const AssetImage("assets/images/profile.jpg"),
              ),

              const SizedBox(height: 12),

              Text(
                _profil?['nama_lengkap'] ?? "-",

                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                _profil?['email'] ?? "-",

                style: const TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFFEAEFEF,
                    ), // Warna latar belakang abu-abu muda
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // --- HEADER: JUDUL DAN TOMBOL EDIT ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Informasi Akun",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(
                                0xFFB45F06,
                              ), // Warna cokelat/orange tua sesuai gambar
                            ),
                          ),
                          // Tombol Edit berbentuk Pill/Kapsul
                          ElevatedButton.icon(
                            onPressed: () async {
                              // 1. Tambahkan async di sini
                              // Berpindah ke halaman EditInformasiAkun sambil menunggu hasilnya
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditInformasiAkun(
                                    namaAwal: _profil?['nama_lengkap'] ?? "",
                                    teleponAwal: _profil?['no_telp'] ?? "",
                                    emailAwal: _profil?['email'] ?? "",
                                    usernameAwal: _profil?['username'] ?? "",
                                  ),
                                ),
                              );

                              // 2. Jika kembali membawa string 'success', refresh data profil dari API
                              if (result == 'success') {
                                _loadData(forceRefresh: true);

                                // Opsional: Tampilkan dialog sukses seperti pada edit alamat
                                _showSuccessDialog(
                                  title: "Profil Berhasil\nDiperbarui!",
                                  message:
                                      "Perubahan informasi akun Anda telah berhasil disimpan.",
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.edit,
                              size: 16,
                              color: Color(0xFFAF510C),
                            ),
                            label: const Text(
                              "Edit",
                              style: TextStyle(color: Color(0xFFAF510C)),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFAF510C)),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ), // Jarak antara header dan list informasi
                      // --- DAFTAR INFORMASI ---
                      buildInfoTile(
                        Icons.person,
                        "Nama Lengkap",
                        _profil?['nama_lengkap'] ?? "-",
                      ),
                      buildInfoTile(
                        Icons.phone,
                        "Nomor Telepon",
                        _profil?['no_telp'] ?? "-",
                      ),
                      buildInfoTile(
                        Icons.email,
                        "Email",
                        _profil?['email'] ?? "-",
                      ),
                      buildInfoTile(
                        Icons.badge,
                        "Username",
                        _profil?['username'] ?? "-",
                      ),
                      Row(
                        children: [
                          // 1. Kolom Informasi Password (dibuat Expanded agar mengambil sisa ruang kiri)
                          Expanded(
                            child: buildInfoTile(
                              Icons.key,
                              "Password",
                              // Opsional: Mengubah tampilan password jadi bintang-bintang agar lebih aman
                              _profil?['password'] != null
                                  ? "•" *
                                        (_profil?['password']
                                                .toString()
                                                .length ??
                                            6)
                                  : "-",
                            ),
                          ),

                          // 2. Tombol Edit Khusus di Sisi Kanan Kolom Password
                          TextButton.icon(
                            onPressed: () async {
                              // Berpindah ke halaman UbahPassword yang sudah Anda import
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UbahPassword(), // Sesuaikan dengan nama class di ubah_password.dart
                                ),
                              );

                              // Jika setelah ubah password butuh refresh data, panggil di sini
                              if (result == true) {
                                _loadData(forceRefresh: true);
                              }
                            },
                            label: const Text(
                              "Edit",
                              style: TextStyle(
                                color: Color(0xFFAF510C),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: Color(
                                0xFFAF510C,
                              ), // Warna cokelat/orange sesuai tema Anda
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),

            _buildDaftarAlamat(),

            const SizedBox(height: 20),

            _buildLogoutButton(),

            const SizedBox(height: 20),
          ],
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
            style: TextStyle(
              color: Color(0xFFAF510C),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ...List.generate(_daftarAlamat.length, (index) {
            // 🌟 5. Sekarang 'item' sudah berupa cetakan AlamatModel, bukan Map lagi.
            final AlamatModel item = _daftarAlamat[index];
            return Column(
              children: [
                buildAddressCard(
                  index: index,
                  idAlamat: item.idAlamat,
                  label: item.labelAlamat,
                  nama: item.namaPenerima,
                  telepon: item.noTelpPenerima,
                  alamat: item.alamatLengkap,
                  isPrimary: item.isUtama,
                ),
                if (index < _daftarAlamat.length - 1)
                  const SizedBox(height: 14),
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
              if (result == true) {
                _loadData(forceRefresh: true);
                _showSuccessDialog(
                  title: "Alamat berhasil\ndisimpan!",
                  message: "Alamat baru Anda telah\nberhasil ditambahkan.",
                );
              }
            },
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
    );
  }

  // 🌟 6. UBAH parameter idAlamat dari int menjadi String
  Widget buildAddressCard({
    required int index,
    required String idAlamat,
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
          const SizedBox(height: 6),
          Text(alamat, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 12),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditAlamat(
                        idAlamat:
                            idAlamat, // 🌟 Mengirim data bertipe String UUID ke halaman Edit
                        labelAwal: label,
                        namaAwal: nama,
                        teleponAwal: telepon,
                        alamatAwal: alamat,
                      ),
                    ),
                  );
                  if (result == true) {
                    _loadData(forceRefresh: true);
                    _showSuccessDialog(
                      title: "Alamat berhasil\ndiubah!",
                      message:
                          "Perubahan alamat Anda telah\nberhasil disimpan.",
                    );
                  }
                },
                icon: const Icon(
                  Icons.edit,
                  size: 16,
                  color: Color(0xFFAF510C),
                ),
                label: const Text(
                  "Edit",
                  style: TextStyle(color: Color(0xFFAF510C)),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFAF510C)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: () => _showDeleteDialog(
                  index,
                  idAlamat,
                ), // 🌟 idAlamat di sini otomatis mengirim String
                icon: const Icon(
                  Icons.delete_outline,
                  size: 16,
                  color: Color(0xFFAF510C),
                ),
                label: const Text(
                  "Hapus",
                  style: TextStyle(color: Color(0xFFAF510C)),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFAF510C)),
                  backgroundColor: const Color(0x22AF510C),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
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
        label: const Text(
          "Keluar dari Akun",
          style: TextStyle(color: Color(0xFFAF510C)),
        ),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          side: const BorderSide(color: Color(0xFFAF510C)),
        ),
      ),
    );
  }
}
