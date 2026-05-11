# 🛒 Mantra (Management and Transaction)

Selamat datang di repositori **Mantra App**!
Mantra adalah aplikasi sistem manajemen toko dan transaksi _Online-to-Offline_ (O2O) yang dilengkapi dengan fitur _Barcode Scanner_ untuk mempermudah operasional toko.

Proyek ini menggunakan arsitektur _Monorepo_ yang memisahkan antara sistem _Mobile Client_ dan _API Server_.

## 🛠️ Tech Stack

- **Frontend:** Flutter (Dart)
- **Backend:** Golang (Gin Framework)
- **Database:** PostgreSQL

---

## 📁 Struktur Direktori

Berikut adalah susunan ruang kerja kita. Pastikan kalian bekerja di dalam direktori yang tepat!

```text
MANTRA-APP/
├── backend/               # ⚙️ Semua kode API Server (Golang) ada di sini
│   ├── config/            # Konfigurasi database & environment
│   ├── controllers/       # Logika bisnis dan pemrosesan request
│   ├── docs/              # 📄 Dokumentasi API dan ERD Database (.dbml)
│   ├── models/            # Struktur tabel database (Struct)
│   ├── routes/            # Daftar endpoint API
│   └── main.go            # Titik masuk utama server Go
│
├── frontend/              # 📱 Semua kode UI/UX Mobile (Flutter) ada di sini
│   ├── lib/               # Kodingan utama aplikasi Flutter
|   |   ├── core/
|   |       ├── widgets/   # Tempat widget umum (yang dipake semua fitur, misal bottom navbar)
|   |   ├── features/      # Halaman-halaman fitur (misal home, order)
│   ├── pubspec.yaml       # Daftar package/library Flutter
│   └── main.dart          # App Flow starting point
│
└── .gitignore             # 🛡️ Penjaga file rahasia agar tidak ter-push ke GitHub
```

---

## 📊 Dokumentasi Database (ERD)

Desain relasi tabel (ERD) untuk project ini disimpan dalam format **DBML** di dalam folder `backend/docs/mantra.dbml`.
Agar seluruh anggota tim dapat melihat visualisasi grafik relasinya dengan mudah secara langsung dari _editor_, **WAJIB** mengikuti panduan berikut:

### Cara Melihat Visualisasi Database (Untuk Tim)

1. Buka menu **Extensions** di VS Code Anda (atau tekan `Ctrl+Shift+X`).
2. Cari ekstensi bernama **"DBML"** atau **"vscode-dbml"** (biasanya logo berwarna biru/ungu).
3. Klik **Install**.
4. Setelah ter-install, buka file `backend/docs/mantra.dbml`.
5. Akan muncul tombol **Preview** atau ikon kaca pembesar/diagram di pojok kanan atas editor Anda. Klik tombol tersebut untuk melihat diagram tabel yang terhubung (_live-preview_).

_(Alternatif: Anda juga bisa menyalin isi teks file `.dbml` tersebut ke website [dbdiagram.io](https://dbdiagram.io/) untuk melihatnya di browser)._

---

## 🚀 Cara Menjalankan Proyek (Local Setup)

### 1. Setup Backend (Golang & Database)

Karena file konfigurasi dan _password database_ tidak di-_push_ ke GitHub demi keamanan, ikuti langkah ini:

1. Pastikan **PostgreSQL** sudah berjalan di laptop masing-masing.
2. Buat database baru di PostgreSQL bernama `mantra_db`.
3. Buka terminal, masuk ke folder backend: `cd backend`
4. Buat file baru bernama `.env` di dalam folder `backend` dan isi dengan kredensial database kalian (minta formatnya ke Lead Developer).
5. Download semua _library_ Go: `go mod tidy`
6. Jalankan server: `go run main.go`
   _(Server akan berjalan di `http://localhost:8080`)_

### 2. Setup Frontend (Flutter)

1. Buka terminal baru, masuk ke folder frontend: `cd frontend`
2. Download semua _package_ Flutter: `flutter pub get`
3. Jalankan aplikasi di Emulator atau HP fisik: `flutter run`
   _(Pastikan IP API di aplikasi sudah diarahkan ke IP Local PC/Server yang menyala)_

---

## ⚠️ Aturan Main Tim (Wajib Dibaca!)

Untuk menjaga kerapian _history_ dan mencegah _codebase_ berantakan, tim developer **Mantra** wajib mengikuti standar industri di bawah ini:

### A. Aturan Commit (Conventional Commits)

Dilarang menggunakan pesan commit asal-asalan seperti `git commit -m "update"` atau `"benerin bug"`. Gunakan format berikut:
`<tipe>(<scope>): <pesan pendek>`

- **`feat`**: Jika menambah fitur baru.
  _(Contoh: `git commit -m "feat(auth): bikin halaman login flutter"`)_
- **`fix`**: Jika memperbaiki _bug_ atau _error_.
  _(Contoh: `git commit -m "fix(db): benerin query stok postgres"`)_
- **`chore`**: Untuk hal teknis non-fitur (update library, rapihin folder, dll).
  _(Contoh: `git commit -m "chore: update package http flutter"`)_
- **`docs`**: Jika hanya mengubah README atau dokumentasi.

### B. Alur Kerja & Cabang (Branching Strategy)

**DILARANG KERAS** melakukan _push_ kode langsung ke _branch_ `main`.
Kita menggunakan metode Git Flow sederhana:

1. **`main`**: Etalase utama. Khusus kode yang sudah lulus tes 100% dan siap presentasi/deploy.
2. **`dev`**: Dapur utama tempat bertemunya hasil kodingan semua anggota tim.
3. **`feature/*`**: Cabang tempat kalian ngoding fitur masing-masing.

**Skenario Kerja (Contoh mengerjakan fitur Scanner):**

```bash
# 1. Selalu mulai dengan pindah ke branch dev
git checkout dev

# 2. Tarik update terbaru agar tidak bentrok
git pull origin dev

# 3. Buat branch baru khusus untuk fitur yang sedang dikerjakan
git checkout -b feature/scanner-barcode

# ... (Silakan ngoding fitur kalian di sini sampai selesai) ...

# 4. Jika sudah selesai, Commit dan Push branch fitur tersebut ke GitHub
git add .
git commit -m "feat(scanner): integrasi mobile_scanner package"
git push origin feature/scanner-barcode
```

### C. Code Review & Pull Request (PR)

Setelah melakukan _push_ dari _branch_ fitur, **jangan langsung digabung!**

1. Buka GitHub, buat **Pull Request (PR)** dari branch fitur kalian mengarah ke branch `dev`.
2. Minta anggota tim lain untuk melakukan **Code Review**.
3. Rekan setim akan mengecek (misal: mengingatkan penamaan variabel atau penanganan _error_).
4. Jika sudah di-_approve_ (disetujui) oleh rekan setim, barulah PR tersebut di-**Merge** ke _branch_ `dev`.

## 🏃‍♂️ Cara Setup & Menjalankan Project di Laptop Lokal

Ikuti langkah-langkah di bawah ini secara berurutan biar nggak error:

### Langkah 1: Clone Repository

Buka terminal/CMD di folder tempat kalian biasa nyimpen tugas kuliah, lalu jalankan perintah ini:

    git clone https://github.com/Hamim688/Mantra.git
    cd mantra-app/backend

### Langkah 2: Bikin Database Kosong di Lokal

Kita nggak pakai database di VPS buat tahap development, jadi kalian wajib bikin di laptop masing-masing.

1. Buka terminal psql atau DBeaver kalian.
2. Buat database baru bernama `mantra_db` dengan menjalankan query SQL ini:

   CREATE DATABASE mantra_db;

_(Cukup bikin databasenya aja, nggak usah bikin tabel apa-apa. Nanti Golang yang bakal otomatis buatin tabelnya untuk kita)._

### Langkah 3: Install Semua Dependencies (Sihir Golang)

Karena kita pakai GORM, kita harus download library-nya dulu. Pastikan posisi terminal kalian ada di dalam folder backend, lalu jalankan:

    go mod tidy

_Perintah ini akan otomatis membaca file `go.mod` dan mendownload semua package yang dibutuhkan._

### Langkah 4: Sesuaikan Password Database! ⚠️ PENTING ⚠️

Buka file `config/database.go` di text editor (VS Code). Cari baris kode koneksi (DSN) ini:

    dsn := "host=localhost user=postgres password=123456 dbname=mantra_db port=5432 sslmode=disable"

**WAJIB DIGANTI:** Ubah bagian `password=123456` menjadi password akun PostgreSQL di laptop kalian masing-masing.

### Langkah 5: Jalankan Aplikasi (Auto-Migrate)

Setelah password disesuaikan dan di-save, jalankan perintah pamungkas ini di terminal:

    go run main.go

Jika di terminal muncul tulisan: `Database Connected & Migrated Successfully!` berarti aplikasi backend sudah berjalan.

---

## 🤝 Aturan Main Pembagian Tugas

- Buat file struct (tabel) baru hanya di dalam folder `models/`.
- Format nama struct menggunakan awalan huruf Kapital (contoh: `Keranjang`, `Kategori`).
- Format nama field untuk database wajib menggunakan tag column snake_case (contoh: `gorm:"column:id_kategori"`).

---

_Developed with ☕ by Mantra Team_
