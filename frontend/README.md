# Mantra Mobile Client

Aplikasi mobile untuk **Mantra (Management and Transaction)**, dibangun menggunakan **Flutter (Dart)**.
Repositori ini melayani dua role utama: **Customer** (untuk berbelanja online) dan **Kasir** (untuk Point of Sales / POS di toko fisik).

---

## Daftar Isi
- [1. Overview](#1-overview)
- [2. Arsitektur Kode (Folder lib/)](#2-arsitektur-kode-folder-lib)
  - [2.1 Core (lib/core/)](#21-core-libcore)
  - [2.2 Features (lib/features/)](#22-features-libfeatures)
- [3. Panduan Setup Lokal](#3-panduan-setup-lokal)
  - [3.1 Instalasi Package](#31-instalasi-package)
  - [3.2 Konfigurasi Server / API](#32-konfigurasi-server--api)
  - [3.3 Build & Run](#33-build--run)
- [4. Panduan Security & Standar Koding](#4-panduan-security--standar-koding)

---

## 1. Overview

Sistem Mobile Client ini terhubung ke backend Golang via REST API. 
Karena melayani beberapa role, UI dan logika akan merender tampilan yang berbeda berdasarkan `role` yang didapat dari Token JWT saat proses Login.

- **Role Customer:** Katalog barang, keranjang belanja, checkout, lacak pesanan, notifikasi promo.
- **Role Kasir:** Scan barcode, manajemen transaksi kasir (POS), laporan shift, pembayaran QRIS/Tunai.

---

## 2. Arsitektur Kode (Folder lib/)

Kodingan utama berada di dalam folder `lib/`. Struktur kita dirancang untuk memisahkan antara hal-hal yang bersifat inti (Core) dengan hal-hal yang spesifik pada suatu halaman/fitur (Features).

### 2.1 Core (`lib/core/`)
Berisi utilitas global dan _tools_ dasar yang dipakai di berbagai tempat.
- **`widgets/`**: Komponen UI yang sering dipakai ulang (seperti Custom Button, Custom TextField, Bottom Navbar, dll).
- **`api/`** atau **`network/`**: Konfigurasi Dio/HTTP client dan interceptor token.
- **`theme/`**: Warna aplikasi, tipografi (font), dan styling global.
- **`utils/`**: Helper function (format mata uang Rupiah, format tanggal, dll).

### 2.2 Features (`lib/features/`)
Berisi kode logika dan tampilan (UI) yang dibagi berdasarkan modul/fitur.
- **`auth/`**: Halaman Login, Register, dll.
- **`home/`**: Halaman dashboard utama.
- **`cart/`**: Halaman keranjang belanja.
- **`order/`**: Detail transaksi dan lacak pesanan.
*(Isi folder features bisa bertambah seiring berkembangnya aplikasi).*

---

## 3. Panduan Setup Lokal

### 3.1 Instalasi Package
Pastikan Anda sudah menginstall Flutter SDK.
Buka terminal di dalam folder `frontend/` dan jalankan:
```bash
flutter pub get
```

### 3.2 Konfigurasi Server / API
Secara default, aplikasi akan menembak ke URL API lokal.
Pastikan:
1. Backend Golang sudah dalam keadaan berjalan (Running).
2. Jika Anda mencoba menggunakan Emulator Android, localhost backend biasanya diakses lewat `10.0.2.2`.
3. Jika menggunakan HP fisik asli, pastikan HP dan Laptop terhubung di WiFi yang sama, lalu ganti URL Base API di kodingan Flutter menjadi IP Address laptop Anda (contoh: `192.168.1.15:8080`).

### 3.3 Build & Run

Aplikasi memiliki dua mode utama saat dijalankan atau di-build:

**Mode Offline Lokal (Backend di Laptop):**
Gunakan mode ini saat backend berjalan secara lokal di laptop Anda.
```bash
flutter run
```

**Mode Online Production (Konek ke mantra.web.id):**
Gunakan mode ini untuk terhubung langsung ke server production. Sangat cocok untuk menguji fitur dengan data nyata.
```bash
flutter run --dart-define=BASE_URL=https://mantra.web.id/api/v1
```

**Build APK Production:**
Untuk mem-build APK final yang akan di-install di HP untuk testing (terhubung ke server production):
```bash
flutter build apk --release --dart-define=BASE_URL=https://mantra.web.id/api/v1
```
*(APK hasil build akan berada di `build/app/outputs/flutter-apk/app-release.apk`)*

### 3.4 Catatan Konfigurasi Tambahan (Android)
- **Keystore & Signing:** APK Production membutuhkan Keystore (`.jks`) resmi yang disimpan secara rahasia dan tidak di-commit ke Git. Buat file `android/key.properties` yang berisi konfigurasi Keystore (`storePassword`, `keyPassword`, `keyAlias`, `storeFile`), lalu rujuk di `android/app/build.gradle.kts`. Pastikan `.jks` dan `key.properties` masuk ke `.gitignore`.
- **Icon Aplikasi:** Gunakan package `flutter_launcher_icons` di `pubspec.yaml` untuk mengenerate icon aplikasi secara otomatis dari file gambar minimal 1024x1024 px.

---

## 4. Panduan Security & Standar Koding
- **Penyimpanan Token:** JWT Token (`access_token` dan `refresh_token`) HANYA boleh disimpan di dalam **`flutter_secure_storage`**. Dilarang keras menyimpannya di SharedPreferences biasa karena tidak terenkripsi.
- **Error Handling:** Jika menangkap pesan error dari API, prioritaskan menampilkan field `error.detail` (jika ada implementasinya) atau `message` yang _human-readable_.
- **Format Mata Uang:** Karena Backend mengirimkan nilai uang dalam bentuk integer utuh, gunakan formatting Rupiah di sisi Flutter saat me-render UI.

Untuk detail lengkap spesifikasi respons API, baca `docs/api-contract.md` di root proyek.