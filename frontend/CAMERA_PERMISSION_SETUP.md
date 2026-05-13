# Konfigurasi Permintaan Izin Kamera pada Halaman Scan

## 📝 Perubahan yang Dilakukan

Kode `scan_customer.dart` telah dimodifikasi untuk memastikan permintaan izin kamera hanya muncul ketika pengguna benar-benar masuk ke halaman scan, bukan saat aplikasi dibuka.

### Perubahan Utama:

1. ✅ Menambahkan `RouteAware` mixin untuk mendeteksi navigasi
2. ✅ Menambahkan `didPush()` - camera dimulai saat halaman ditampilkan
3. ✅ Menambahkan `didPopNext()` - camera dimulai saat kembali ke halaman ini
4. ✅ Menambahkan `didPushNext()` - camera berhenti saat halaman disembunyikan
5. ✅ Menambahkan `didPop()` - camera berhenti saat halaman ditutup

---

## ⚙️ Langkah Konfigurasi di main.dart

Untuk membuat `RouteAware` berfungsi, **Anda perlu menambahkan `RouteObserver` di aplikasi utama**:

### 1. Buka file `main.dart`

```bash
cd frontend/lib
```

### 2. Tambahkan perubahan berikut:

```dart
import 'package:flutter/material.dart';

// ✅ TAMBAHKAN RouteObserver
final RouteObserver<Route> routeObserver = RouteObserver<Route>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mantra App',
      home: const HomePage(),
      // ✅ TAMBAHKAN baris ini
      navigatorObservers: [routeObserver],
      // ... konfigurasi lain
    );
  }
}
```

### 3. Update `scan_customer.dart` untuk menggunakan RouteObserver global (opsional)

Jika Anda sudah menambahkan RouteObserver di main.dart, update initState di scan_customer.dart:

```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addObserver(this);

  // Daftarkan ini ke RouteObserver global
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final Route<dynamic>? route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  });
}
```

---

## 🔄 Alur Kerja Setelah Konfigurasi

```
1. User membuka aplikasi
   ↓
2. Halaman lain ditampilkan (belum ada izin kamera)
   ↓
3. User navigasi ke halaman scan_customer
   ↓
4. didPush() dipanggil → scannerController.start()
   ↓
5. 🔐 BARU SAJA - Permintaan izin kamera muncul!
   ↓
6. User memberikan izin atau menolak
   ↓
7. Scanner siap digunakan
```

---

## 📱 Skenario Penggunaan

| Skenario                          | Perilaku                         |
| --------------------------------- | -------------------------------- |
| Buka app (halaman bukan scan)     | ❌ Tidak ada permintaan izin     |
| Navigasi ke halaman scan          | ✅ Permintaan izin kamera muncul |
| Navigasi keluar dari halaman scan | ⏸️ Camera berhenti               |
| Kembali ke halaman scan           | ✅ Camera dimulai kembali        |
| App ke background                 | ⏸️ Camera berhenti               |
| App kembali ke foreground         | ✅ Camera resume                 |

---

## 🔧 Troubleshooting

### Izin kamera masih muncul saat buka app

- **Solusi**: Pastikan `navigatorObservers: [routeObserver]` sudah ditambahkan di MaterialApp

### Camera tidak berfungsi saat kembali ke halaman

- **Solusi**: Periksa bahwa `didPopNext()` terpanggil dengan menambahkan print:

```dart
@override
void didPopNext() {
  print('DEBUG: didPopNext called'); // debug
  if (mounted) {
    scannerController.start();
  }
}
```

### Error "RouteObserver not found"

- **Solusi**: Pastikan `final RouteObserver<Route> routeObserver = RouteObserver<Route>();` sudah ada di main.dart

---

## ✅ Checklist Implementasi

- [ ] Tambahkan `RouteObserver` ke main.dart
- [ ] Tambahkan `navigatorObservers: [routeObserver]` ke MaterialApp
- [ ] Verifikasi kamera hanya muncul saat masuk halaman scan
- [ ] Test navigasi keluar dan kembali
- [ ] Test app backgrounded/resumed
