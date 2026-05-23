import 'package:flutter/material.dart';
// IMPORT SERVICE DARI FOLDER PROFILE
import '../../core/services/profile_service.dart';
// IMPORT HALAMAN TAMBAH ALAMAT (Pastikan path folder profile sesuai dengan struktur proyekmu)
import '../profile/tambah_alamat.dart';

class PilihAlamatPage extends StatefulWidget {
  final Map<String, dynamic>? alamatSekarang;

  const PilihAlamatPage({super.key, this.alamatSekarang});

  @override
  State<PilihAlamatPage> createState() => _PilihAlamatPageState();
}

class _PilihAlamatPageState extends State<PilihAlamatPage> {
  final ProfileService _profileService = ProfileService();
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _daftarAlamat = [];
  Map<String, dynamic>? _alamatTerpilih;

  @override
  void initState() {
    super.initState();
    _alamatTerpilih = widget.alamatSekarang;
    _ambilDaftarAlamat();
  }

  // Fungsi untuk mengambil list alamat dari backend
  Future<void> _ambilDaftarAlamat() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final alamatData = await _profileService.getAlamat();
      setState(() {
        _daftarAlamat = alamatData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFAD510D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pilih Alamat',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // List Alamat Utama
            Expanded(
              child: _buildKontenAlamat(),
            ),
            
            // Tombol Pilih Alamat di bagian paling bawah
            if (_alamatTerpilih != null)
              Container(
                padding: const EdgeInsets.all(20),
                color: Colors.white,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, _alamatTerpilih);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFAD510D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Pilih Alamat',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildKontenAlamat() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFFAD510D)));
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text("Gagal memuat alamat: $_errorMessage", style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (_daftarAlamat.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: Text("Belum ada alamat tersimpan di akun Anda.")),
          ),

        ..._daftarAlamat.map((alamat) {
          final isSelected = _alamatTerpilih?['id_alamat'] == alamat['id_alamat'];
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _alamatTerpilih = alamat;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? const Color(0xFFAD510D) : Colors.grey.shade200,
                  width: isSelected ? 1.5 : 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Checkbox Custom
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFAD510D) : Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isSelected ? const Color(0xFFAD510D) : Colors.grey.shade400,
                        width: 1.5,
                      ),
                    ),
                    child: isSelected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alamat['nama_penerima'] ?? '-',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          alamat['alamat_lengkap'] ?? '-',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
        
        const SizedBox(height: 10),

        // TOMBOL + TAMBAH ALAMAT BARU (SUDAH TERHUBUNG KE HALAMAN TAMBAH_ALAMAT)
        OutlinedButton(
          onPressed: () async {
            // Berpindah ke halaman AlamatBaru dan menunggu proses selesai
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AlamatBaru(),
              ),
            );
            
            // Setelah kembali dari halaman tambah alamat, re-fetch list alamat agar alamat baru langsung muncul
            _ambilDaftarAlamat();
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFFAD510D)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: const Text(
            '+ Tambah Alamat Baru',
            style: TextStyle(color: Color(0xFFAD510D), fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}