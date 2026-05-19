import 'package:flutter/material.dart';

class PilihPembayaranPage extends StatefulWidget {
  final Map<String, dynamic>? pembayaranSekarang;

  const PilihPembayaranPage({super.key, this.pembayaranSekarang});

  @override
  State<PilihPembayaranPage> createState() => _PilihPembayaranPageState();
}

class _PilihPembayaranPageState extends State<PilihPembayaranPage> {
  // Variabel untuk melacak kategori utama mana yang sedang di-expand (membentang)
  String? _kategoriExpanded;
  
  // Variabel penampung sub-pilihan atau pilihan final
  Map<String, dynamic>? _pembayaranTerpilih;

  @override
  void initState() {
    super.initState();
    _pembayaranTerpilih = widget.pembayaranSekarang;
    
    // Jika sebelumnya sudah ada pilihan, sesuaikan status expand kategori utamanya
    if (_pembayaranTerpilih != null) {
      _kategoriExpanded = _pembayaranTerpilih!['kategori'];
    }
  }

  // Fungsi pembantu untuk mendeteksi apakah item ini yang sedang aktif dicentang
  bool _isMetodeChecked(String idMetode) {
    return _pembayaranTerpilih?['id_metode'] == idMetode;
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
          'Metode Pembayaran',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // ================= 1. MANTRA-PAY =================
                  _buildKategoriUtamaCard(
                    idKategori: 'mantrapay',
                    nama: 'Mantra-pay',
                    sub: 'Saldo Rp. 120.000',
                    icon: Icons.wallet_rounded,
                    hasDropdown: false,
                    onTap: () {
                      setState(() {
                        _kategoriExpanded = 'mantrapay';
                        _pembayaranTerpilih = {
                          'kategori': 'mantrapay',
                          'id_metode': 'mantrapay',
                          'nama': 'Mantra-pay',
                          'sub': 'Saldo Rp. 120.000',
                          'icon': Icons.wallet_rounded,
                        };
                      });
                    },
                  ),

                  // ================= 2. VIRTUAL ACCOUNT (TRANSFER BANK) =================
                  _buildKategoriUtamaCard(
                    idKategori: 'va',
                    nama: 'Transfer Bank (VA)',
                    sub: 'Format otomatis & dicek otomatis',
                    icon: Icons.account_balance_rounded,
                    hasDropdown: true,
                    onTap: () {
                      setState(() {
                        // Toggle expand/collapse
                        _kategoriExpanded = _kategoriExpanded == 'va' ? null : 'va';
                      });
                    },
                  ),
                  // Dropdown list bank jika kategori 'va' di-expand
                  if (_kategoriExpanded == 'va')
                    _buildSubDropdownContainer(
                      children: [
                        _buildSubMetodeTile(idKategori: 'va', idMetode: 'va_bni', nama: 'BNI Virtual Account', sub: 'Dicek otomatis'),
                        _buildSubMetodeTile(idKategori: 'va', idMetode: 'va_bri', nama: 'BRI Virtual Account', sub: 'Dicek otomatis'),
                        _buildSubMetodeTile(idKategori: 'va', idMetode: 'va_mandiri', nama: 'Mandiri Virtual Account', sub: 'Dicek otomatis'),
                        _buildSubMetodeTile(idKategori: 'va', idMetode: 'va_bca', nama: 'BCA Virtual Account', sub: 'Dicek otomatis'),
                      ],
                    ),

                  // ================= 3. E-WALLET =================
                  _buildKategoriUtamaCard(
                    idKategori: 'ewallet',
                    nama: 'E-Wallet',
                    sub: 'DANA, ShopeePay, OVO, dll',
                    icon: Icons.phone_android_rounded,
                    hasDropdown: true,
                    onTap: () {
                      setState(() {
                        _kategoriExpanded = _kategoriExpanded == 'ewallet' ? null : 'ewallet';
                      });
                    },
                  ),
                  // Dropdown list e-wallet jika kategori 'ewallet' di-expand
                  if (_kategoriExpanded == 'ewallet')
                    _buildSubDropdownContainer(
                      children: [
                        _buildSubMetodeTile(idKategori: 'ewallet', idMetode: 'ew_dana', nama: 'DANA', sub: 'Hubungkan akun DANA Anda'),
                        _buildSubMetodeTile(idKategori: 'ewallet', idMetode: 'ew_spay', nama: 'ShopeePay', sub: 'Instan menggunakan ShopeePay'),
                        _buildSubMetodeTile(idKategori: 'ewallet', idMetode: 'ew_ovo', nama: 'OVO', sub: 'Dicek instan'),
                      ],
                    ),

                  // ================= 4. QRIS =================
                  _buildKategoriUtamaCard(
                    idKategori: 'qris',
                    nama: 'QRIS',
                    sub: 'Bayar instan pakai aplikasi bank atau e-wallet',
                    icon: Icons.qr_code_scanner_rounded,
                    hasDropdown: false,
                    onTap: () {
                      setState(() {
                        _kategoriExpanded = 'qris';
                        _pembayaranTerpilih = {
                          'kategori': 'qris',
                          'id_metode': 'qris',
                          'nama': 'QRIS',
                          'sub': 'Scan kode QR kode untuk bayar',
                          'icon': Icons.qr_code_scanner_rounded,
                        };
                      });
                    },
                  ),

                  // ================= 5. COD =================
                  _buildKategoriUtamaCard(
                    idKategori: 'cod',
                    nama: 'Cash on Delivery (COD)',
                    sub: 'Bayar tunai langsung ke kurir saat barang sampai',
                    icon: Icons.handshake_rounded,
                    hasDropdown: false,
                    onTap: () {
                      setState(() {
                        _kategoriExpanded = 'cod';
                        _pembayaranTerpilih = {
                          'kategori': 'cod',
                          'id_metode': 'cod',
                          'nama': 'Cash on Delivery (COD)',
                          'sub': 'Bayar tunai di tempat',
                          'icon': Icons.handshake_rounded,
                        };
                      });
                    },
                  ),
                ],
              ),
            ),
            
            // Tombol Konfirmasi Pembayaran di Bagian Bawah
            if (_pembayaranTerpilih != null)
              Container(
                padding: const EdgeInsets.all(20),
                color: Colors.white,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Mengembalikan data pembayaran lengkap ke halaman Checkout
                    Navigator.pop(context, _pembayaranTerpilih);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFAD510D),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Konfirmasi Pembayaran',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Widget Pembuat Box Kategori Utama (Mantra-pay, VA, E-Wallet, QRIS, COD)
  Widget _buildKategoriUtamaCard({
    required String idKategori,
    required String nama,
    required String sub,
    required IconData icon,
    required bool hasDropdown,
    required VoidCallback onTap,
  }) {
    final isCategoryActive = _kategoriExpanded == idKategori;
    // Check apakah ini pembayaran final (untuk yang non-dropdown seperti Mantra-pay, QRIS, COD)
    final isChecked = _pembayaranTerpilih?['kategori'] == idKategori && !hasDropdown;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: (isCategoryActive || isChecked) ? const Color(0xFFAD510D) : Colors.grey.shade200,
            width: (isCategoryActive || isChecked) ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFAD510D),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            // Indikator Kanan: Dropdown Arrow atau Checkbox Bulat
            if (hasDropdown)
              Icon(
                isCategoryActive ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                color: isCategoryActive ? const Color(0xFFAD510D) : Colors.grey,
              )
            else
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isChecked ? const Color(0xFFAD510D) : Colors.white,
                  border: Border.all(
                    color: isChecked ? const Color(0xFFAD510D) : Colors.grey.shade400,
                    width: 1.5,
                  ),
                ),
                child: isChecked ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
              ),
          ],
        ),
      ),
    );
  }

  // Container Pembungkus Dropdown anak-anaknya agar terlihat rapi mengelompok
  Widget _buildSubDropdownContainer({required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(top: 4, left: 10, right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: children),
    );
  }

  // Baris Pilihan Bank atau E-Wallet Spesifik di dalam dropdown
  Widget _buildSubMetodeTile({
    required String idKategori,
    required String idMetode,
    required String nama,
    required String sub,
  }) {
    final isChecked = _isMetodeChecked(idMetode);

    return InkWell(
      onTap: () {
        setState(() {
          _pembayaranTerpilih = {
            'kategori': idKategori,
            'id_metode': idMetode,
            'nama': nama,
            'sub': sub,
            // Tentukan icon kustom saat tampil kembali di halaman Checkout
            'icon': idKategori == 'va' ? Icons.account_balance_rounded : Icons.phone_android_rounded,
          };
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nama, style: TextStyle(fontWeight: isChecked ? FontWeight.bold : FontWeight.normal, fontSize: 14)),
                  Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
            ),
            // Lingkaran Radio Button kecil penanda aktif
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isChecked ? const Color(0xFFAD510D) : Colors.white,
                border: Border.all(
                  color: isChecked ? const Color(0xFFAD510D) : Colors.grey.shade400,
                  width: 1.5,
                ),
              ),
              child: isChecked ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
            ),
          ],
        ),
      ),
    );
  }
}