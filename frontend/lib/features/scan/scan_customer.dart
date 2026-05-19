import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../main.dart'
    as app; // ✅ Import untuk mengakses RouteObserver global
import 'package:frontend/core/widgets/base_header_widget.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage>
    with WidgetsBindingObserver, RouteAware {
  // Variabel untuk menampung hasil scan
  final MobileScannerController scannerController = MobileScannerController();
  String? barcodeTerdeteksi;
  String namaBarang = "Menunggu Scan...";
  String hargaBarang = "-";
  bool isFound = false;
  bool _isProcessing = false;
  bool _isFlashOn = false;

  // Simulasi Database Lokal
  final Map<String, Map<String, String>> dummyDatabase = {
    "6956953588031": {
      "nama": "CARINEX HI-TECH Pen 0.28mm",
      "harga": "Rp. 2.000",
    },
    "8993988055679": {
      "nama": "JOYKO Correction Tape CT-570",
      "harga": "Rp. 12.000",
    },
  };

  void cekBarcode(String code) async {
    if (_isProcessing) return; // Jika sedang proses, abaikan scan baru
    _isProcessing = true;

    if (dummyDatabase.containsKey(code)) {
      setState(() {
        barcodeTerdeteksi = code;
        namaBarang = dummyDatabase[code]!['nama']!;
        hargaBarang = dummyDatabase[code]!['harga']!;
        isFound = true;
      });

      // Beri jeda 3 detik agar user bisa baca hasil sebelum boleh scan barang lain
      await Future.delayed(const Duration(seconds: 3));
    } else {
      setState(() {
        namaBarang = "Barang Tidak Terdaftar";
        hargaBarang = "-";
        isFound = false;
      });
      // Beri jeda 1 detik saja jika tidak ketemu agar tidak spamming log
      await Future.delayed(const Duration(seconds: 1));
    }
    _isProcessing = false;
  }

  @override
  void initState() {
    super.initState();
    // Daftarkan observer untuk mendeteksi perubahan lifecycle aplikasi
    WidgetsBinding.instance.addObserver(this);

    // Daftarkan ke RouteObserver global dari main.dart
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Route<dynamic>? route = ModalRoute.of(context);
      if (route is PageRoute) {
        app.routeObserver.subscribe(this, route);
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        // Pause camera ketika aplikasi di background
        scannerController.stop();
        break;
      case AppLifecycleState.resumed:
        // Resume camera ketika aplikasi kembali ke foreground
        // Tapi hanya jika halaman ini sedang aktif
        if (mounted) {
          scannerController.start();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        // Handle state lainnya jika diperlukan
        break;
    }
  }

  // RouteAware method - dipanggil ketika route ini di-push ke navigation stack
  @override
  void didPush() {
    // Izin kamera diminta hanya ketika halaman ini benar-benar ditampilkan
    if (mounted) {
      scannerController.start();
    }
  }

  // RouteAware method - dipanggil ketika route lain di-pop, menampilkan route ini kembali
  @override
  void didPopNext() {
    if (mounted) {
      scannerController.start();
    }
  }

  // RouteAware method - dipanggil ketika route lain di-push, menyembunyikan route ini
  @override
  void didPushNext() {
    if (mounted) {
      scannerController.stop();
    }
  }

  // RouteAware method - dipanggil ketika route ini di-pop dari navigation stack
  @override
  void didPop() {
    if (mounted) {
      scannerController.stop();
    }
  }

  @override
  void deactivate() {
    // Hentikan scanner ketika halaman ini tidak lagi aktif
    if (mounted) {
      scannerController.stop();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    // Hapus observer sebelum dispose
    WidgetsBinding.instance.removeObserver(this);
    // Unsubscribe dari RouteObserver global
    app.routeObserver.unsubscribe(this);
    // Matikan kamera sebelum halaman benar-benar hancur
    scannerController.dispose();
    super.dispose();
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(Icons.info_outline, size: 48, color: Color(0xFFAF510C)),
              SizedBox(height: 16),
              Text(
                'Arahkan kamera ke barcode barang untuk melihat informasi barang',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK', textAlign: TextAlign.center),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BaseHeaderWidget(
        title: "Cek Harga",

        actions: [
          IconButton(
            icon: Icon(
              _isFlashOn ? Icons.flash_on : Icons.flash_off,
              color: Colors.white,
            ),
            onPressed: () async {
              await scannerController.toggleTorch();
              setState(() {
                _isFlashOn = !_isFlashOn;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: _showHelpDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // ================= AREA KAMERA =================
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.black,
            ),
            clipBehavior: Clip.antiAlias, // Agar kamera ikut melengkung
            child: MobileScanner(
              controller: scannerController,
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  if (barcode.rawValue != null) {
                    cekBarcode(barcode.rawValue!);
                  }
                }
              },
            ),
          ),

          const SizedBox(height: 30),

          // ================= CARD HASIL SCAN =================
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEAEFEF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                // Placeholder Gambar Barang
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                    image: isFound
                        ? const DecorationImage(
                            image: AssetImage(
                              "assets/images/book_placeholder.jpg",
                            ), // Ganti image-mu
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: !isFound
                      ? const Icon(Icons.image, color: Colors.grey)
                      : null,
                ),
                const SizedBox(width: 16),
                // Info Barang
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        namaBarang,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        hargaBarang,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ],
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
