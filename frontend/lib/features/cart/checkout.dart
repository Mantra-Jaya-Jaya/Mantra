import 'package:flutter/material.dart';
import '../profile/services/profile_service.dart'; 
import 'pilih_alamat.dart'; 
import 'pilih_pembayaran.dart'; 

class Checkout extends StatefulWidget {
  final List<Map<String, dynamic>> selectedProducts;

  const Checkout({super.key, required this.selectedProducts});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final ProfileService _profileService = ProfileService();
  bool _isLoading = true;
  String? _errorMessage;
  
  Map<String, dynamic>? _alamatDipilih;
  Map<String, dynamic>? _pembayaranDipilih;

  @override
  void initState() {
    super.initState();
    // Default awal di-set ke Mantra-pay
    _pembayaranDipilih = {
      'kategori': 'mantrapay',
      'id_metode': 'mantrapay',
      'nama': 'Mantra-pay',
      'sub': 'Saldo Rp. 120.000',
      'icon': Icons.wallet_rounded,
    };
    _ambilAlamatDariBackend();
  }

  Future<void> _ambilAlamatDariBackend() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final daftarAlamatDariBackend = await _profileService.getAlamat();

      if (mounted) {
        setState(() {
          _alamatDipilih = daftarAlamatDariBackend.firstWhere(
            (addr) => addr['is_utama'] == true || addr['is_utama'] == 1,
            orElse: () => daftarAlamatDariBackend.isNotEmpty ? daftarAlamatDariBackend.first : {},
          );
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error ambil alamat checkout: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Gagal mengambil alamat utama dari server.";
        });
      }
    }
  }

  int get subtotalProduk {
    int total = 0;
    for (var item in widget.selectedProducts) {
      total += (item['price'] as int) * (item['quantity'] as int);
    }
    return total;
  }

  int get ongkosKirim => _alamatDipilih != null && _alamatDipilih!.isNotEmpty ? 25000 : 0;
  int get pajak => 5000;
  int get totalPembayaran => subtotalProduk + ongkosKirim + pajak;

  String _formatRupiah(int number) {
    return 'Rp. ${number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  Future<void> _prosesBuatPesanan() async {
    if (_alamatDipilih == null || _alamatDipilih!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan tambahkan alamat pengiriman terlebih dahulu')),
      );
      return;
    }

    Map<String, dynamic> checkoutPayload = {
      'id_alamat': _alamatDipilih!['id_alamat'],
      'metode_pembayaran': _pembayaranDipilih?['id_metode'] ?? 'mantrapay',
      'grand_total': totalPembayaran,
      'items': widget.selectedProducts.map((item) {
        return {
          'id_produk': item['id'],
          'qty': item['quantity'],
          'harga_satuan': item['price']
        };
      }).toList(),
    };

    print("Payload Transaksi Siap: $checkoutPayload");
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pesanan Berhasil Disimpan!'), backgroundColor: Color(0xFFAD510D)),
    );
    Navigator.pop(context);
  }

  Future<void> _pindahKePilihAlamat() async {
    final alamatBaruTerpilih = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PilihAlamatPage(alamatSekarang: _alamatDipilih),
      ),
    );

    if (alamatBaruTerpilih != null && alamatBaruTerpilih is Map<String, dynamic>) {
      setState(() {
        _alamatDipilih = alamatBaruTerpilih; 
      });
    }
  }

  Future<void> _pindahKePilihPembayaran() async {
    final pembayaranBaru = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PilihPembayaranPage(pembayaranSekarang: _pembayaranDipilih),
      ),
    );

    if (pembayaranBaru != null && pembayaranBaru is Map<String, dynamic>) {
      setState(() {
        _pembayaranDipilih = pembayaranBaru; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: _isLoading 
            ? const Center(child: CircularProgressIndicator(color: Color(0xFFAD510D)))
            : Column(
                children: [
                  // AppBar Custom
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFAD510D),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Checkout',
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  // Konten utama list checkout
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        ...widget.selectedProducts.map((item) => _buildCheckoutProductTile(item)),
                        const SizedBox(height: 10),

                        // Header Rincian Pengiriman
                        const Row(
                          children: [
                            Icon(Icons.local_shipping_outlined, color: Color(0xFFAD510D), size: 20),
                            SizedBox(width: 8),
                            Text('Rincian Pengiriman', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 12),

                        _buildAlamatBackendCard(),
                        const SizedBox(height: 16),

                        // Tampilan Metode Pembayaran (Otomatis berubah dinamis mengikuti sub-pilihan)
                        _buildPembayaranCard(),
                        const SizedBox(height: 24),

                        _buildNotaRincianCard(),
                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _prosesBuatPesanan,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFAD510D),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0, // Flat tanpa bayangan berlebih
                            ),
                            child: const Text('Buat Pesanan', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildCheckoutProductTile(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      height: 140,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF3F4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.image, color: Colors.grey),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(item['subtitle'], style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatRupiah(item['price']), style: const TextStyle(color: Color(0xFFAD510D), fontWeight: FontWeight.bold)),
                    Text('Qty: ${item['quantity']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlamatBackendCard() {
    if (_errorMessage != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
        child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
      );
    }

    if (_alamatDipilih == null || _alamatDipilih!.isEmpty) {
      return Container(
        height: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFFEEF3F4), borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Belum ada alamat dipilih.", style: TextStyle(color: Colors.grey)),
            GestureDetector(
              onTap: _pindahKePilihAlamat,
              child: const Text('Pilih', style: TextStyle(color: Color(0xFFAD510D), fontWeight: FontWeight.bold, fontSize: 13)),
            ),
          ],
        ),
      );
    }

    return Container(
      height: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFEEF3F4), borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0x33AD510D), borderRadius: BorderRadius.circular(8)),
                child: Text(
                  _alamatDipilih!['label_alamat'] ?? 'Alamat',
                  style: const TextStyle(color: Color(0xFFAD510D), fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                onTap: _pindahKePilihAlamat,
                child: const Text('Ubah', style: TextStyle(color: Color(0xFFAD510D), fontSize: 13, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(_alamatDipilih!['nama_penerima'] ?? 'Penerima', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 4),
          Text(_alamatDipilih!['alamat_lengkap'] ?? '-', style: TextStyle(color: Colors.grey.shade600, fontSize: 12, height: 1.4),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPembayaranCard() {
    return Container(
      height: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFEEF3F4), borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFFAD510D), borderRadius: BorderRadius.circular(8)),
                child: Icon(_pembayaranDipilih?['icon'] ?? Icons.wallet_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SINKRON: Menampilkan nama sub-bank/sub-wallet terpilih secara spesifik
                  Text(_pembayaranDipilih?['nama'] ?? 'Metode Pembayaran', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(_pembayaranDipilih?['sub'] ?? '', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: _pindahKePilihPembayaran,
            child: const Text('Ubah', style: TextStyle(color: Color(0xFFAD510D), fontSize: 13, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildNotaRincianCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFEEF3F4), borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          _notaRow('Subtotal', _formatRupiah(subtotalProduk)),
          const SizedBox(height: 10),
          _notaRow('Ongkos Kirim', _formatRupiah(ongkosKirim)),
          const SizedBox(height: 10),
          _notaRow('Pajak', _formatRupiah(pajak)),
          const Divider(height: 24, thickness: 0.5, color: Colors.grey),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Pembayaran', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(_formatRupiah(totalPembayaran), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFFAD510D))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _notaRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
      ],
    );
  }
}