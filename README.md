# 🛒 Mantra App (O2O System)

Selamat datang di repositori **Mantra App**!
Mantra adalah aplikasi sistem manajemen toko dan transaksi _Online-to-Offline_ (O2O) yang dilengkapi dengan fitur _Barcode Scanner_ untuk mempermudah operasional toko.

---

## Daftar Isi
- [1. Tentang Proyek](#1-tentang-proyek)
- [2. Struktur Monorepo](#2-struktur-monorepo)
- [3. Quick Start (Mulai Cepat)](#3-quick-start-mulai-cepat)
  - [3.1 Setup Backend (Ringkasan)](#31-setup-backend-ringkasan)
  - [3.2 Setup Frontend (Ringkasan)](#32-setup-frontend-ringkasan)
  - [3.3 Setup Admin Panel (Next.js)](#33-setup-admin-panel-nextjs)
- [4. Dokumentasi Database (ERD)](#4-dokumentasi-database-erd)
- [5. Aturan Main Tim (Wajib Dibaca!)](#5-aturan-main-tim-wajib-dibaca)
  - [5.1 Aturan Commit (Conventional Commits)](#51-aturan-commit-conventional-commits)
  - [5.2 Branching Strategy](#52-branching-strategy)
  - [5.3 Code Review & Pull Request (PR)](#53-code-review--pull-request-pr)

---

## 1. Tentang Proyek

Proyek ini menggunakan arsitektur _Monorepo_ yang memisahkan antara sistem _Mobile Client_, _Web Admin_, dan _API Server_.

**🛠️ Tech Stack:**
- **Frontend (Mobile):** Flutter (Dart)
- **Frontend (Admin Web):** Next.js (React)
- **Backend:** Golang (Gin Framework)
- **Database:** PostgreSQL

---

## 2. Struktur Monorepo

Berikut adalah susunan ruang kerja kita. Pastikan kalian bekerja di dalam direktori yang tepat!

```text
MANTRA/
├── admin/                 # 🖥️ Aplikasi Web Admin (Next.js)
├── backend/               # ⚙️ Semua kode API Server (Golang) ada di sini
│   ├── docs/              # 📄 Dokumentasi API Lokal dan ERD Database (.dbml)
│   └── ... (Lihat backend/README.md untuk detail)
│
├── frontend/              # 📱 Semua kode UI/UX Mobile (Flutter) ada di sini
│   ├── lib/               # Kodingan utama aplikasi Flutter
│   └── ... (Lihat frontend/README.md untuk detail)
│
├── docs/                  # 📚 Dokumentasi Global (API Contract, RBAC, dll)
│   ├── api-contract.md    # Kontrak API
│   ├── security-rbac.md   # Dokumen Keamanan & RBAC
│   └── mantra-dev/        # 📁 Koleksi API Bruno untuk Testing
│
└── .gitignore             # 🛡️ Penjaga file rahasia agar tidak ter-push ke GitHub
```

---

## 3. Quick Start (Mulai Cepat)

Karena ini adalah proyek monorepo, setiap bagian memiliki cara setup masing-masing.

### 3.1 Setup Backend (Ringkasan)
API Server dibangun dengan Golang dan menggunakan PostgreSQL. 
Untuk instruksi instalasi lengkap, penyesuaian password database `.env`, dan setup Atlas (Engine Migrasi Database), **silakan baca [Panduan Setup Backend](backend/README.md)**.

### 3.2 Setup Frontend (Ringkasan)
Mobile Client dibangun dengan Flutter.
Untuk memahami arsitektur folder `lib/` dan cara menjalankan aplikasinya, **silakan baca [Panduan Setup Frontend](frontend/README.md)**.

### 3.3 Setup Admin Panel (Next.js)
Panel Admin adalah aplikasi web berbasis Next.js yang berjalan di port `3000` dan terhubung ke backend Golang via API Proxy internal.

1. Buka terminal, masuk ke folder admin: `cd admin/`
2. Install package: `npm install`
3. Salin env: `cp .env.example .env.local`
4. Jalankan server: `npm run dev`
*(Baca troubleshooting di folder admin jika mengalami kendala IP saat development).*

---

## 4. Dokumentasi Database (ERD)

Desain relasi tabel (ERD) untuk project ini disimpan dalam format **DBML** di dalam folder `backend/docs/mantra.dbml`.
Agar seluruh anggota tim dapat melihat visualisasi grafik relasinya dengan mudah secara langsung dari _editor_, **WAJIB** mengikuti panduan berikut:

1. Buka menu **Extensions** di VS Code Anda.
2. Cari ekstensi bernama **"DBML"** atau **"vscode-dbml"** lalu Install.
3. Buka file `backend/docs/mantra.dbml`.
4. Klik tombol **Preview** atau ikon kaca pembesar di pojok kanan atas editor Anda untuk melihat diagram tabel (_live-preview_).

_(Alternatif: Salin isi teks file `.dbml` ke [dbdiagram.io](https://dbdiagram.io/) untuk melihatnya di browser)._

---

## 5. Aturan Main Tim (Wajib Dibaca!)

Untuk menjaga kerapian _history_ dan mencegah _codebase_ berantakan, tim developer **Mantra** wajib mengikuti standar industri di bawah ini:

### 5.1 Aturan Commit (Conventional Commits)
Dilarang menggunakan pesan commit asal-asalan seperti `git commit -m "update"`. Gunakan format berikut:
`<tipe>(<scope>): <pesan pendek>`

- **`feat`**: Jika menambah fitur baru. *(Contoh: `feat(auth): bikin halaman login flutter`)*
- **`fix`**: Jika memperbaiki _bug_ atau _error_. *(Contoh: `fix(db): benerin query stok postgres`)*
- **`chore`**: Untuk hal teknis non-fitur (update library, rapihin folder, dll). *(Contoh: `chore: update package http flutter`)*
- **`docs`**: Jika hanya mengubah README atau dokumentasi.

### 5.2 Branching Strategy
**DILARANG KERAS** melakukan _push_ kode langsung ke _branch_ `main`.
1. **`main`**: Etalase utama. Khusus kode yang sudah lulus tes 100%.
2. **`dev`**: Dapur utama tempat bertemunya hasil kodingan semua anggota tim.
3. **`feature/*`**: Cabang tempat ngoding fitur masing-masing.

**Skenario Kerja:**
```bash
git checkout dev
git pull origin dev
git checkout -b feature/nama-fitur
# ... ngoding ...
git add .
git commit -m "feat(scope): deskripsi"
git push origin feature/nama-fitur
```

### 5.3 Code Review & Pull Request (PR)
Setelah melakukan _push_ dari _branch_ fitur:
1. Buka GitHub, buat **Pull Request (PR)** dari branch fitur mengarah ke branch `dev`.
2. Minta anggota tim lain untuk **Code Review**.
3. Jika sudah di-_approve_, barulah PR tersebut di-**Merge** ke _branch_ `dev`.

---
_Developed with ☕ by Mantra Team_