# MANTRA — API Contract
**Version:** 1.0.0
**Last Updated:** 2026-05-09
**Base URL:** `https://api.mantra.com/api/v1`

---

## DAFTAR ISI

1. [Konvensi Global](#1-konvensi-global)
2. [Template & Cara Pakai](#2-template--cara-pakai)
   - [Template A: Tambah Endpoint Baru](#template-a--tambah-endpoint-baru)
   - [Template B: Tambah Fitur Baru](#template-b--tambah-fitur-baru)
   - [Template C: Error Code Registry](#template-c--error-code-registry)
   - [Template D: Deprecation & Perubahan Endpoint](#template-d--deprecation--perubahan-endpoint)
   - [Template E: Update Dokumentasi yang Sudah Ada](#template-e--update-dokumentasi-yang-sudah-ada)
3. [Authentication](#3-authentication)
4. [Customer Endpoints — Flutter](#4-customer-endpoints--flutter)
5. [Kasir Endpoints — Flutter](#5-kasir-endpoints--flutter)
6. [Admin Endpoints — Next.js](#6-admin-endpoints--nextjs)
7. [Kurir Endpoints](#7-kurir-endpoints--placeholder)
8. [Global Error Reference](#8-global-error-reference)
9. [Catatan Teknis](#9-catatan-teknis)

---

## 1. KONVENSI GLOBAL

### Base URL & Versioning
```
https://api.mantra.com/api/v1
```
Semua endpoint wajib menggunakan prefix `/api/v1/`. Jika ada breaking change di masa depan, versi baru menggunakan `/api/v2/` tanpa menghapus v1 langsung.

### Format Timestamp
Semua field waktu menggunakan **ISO 8601**:
```
"2026-05-09T10:00:00Z"
```
Bukan `"2026-05-09 10:00:00"`. Flutter dan Golang keduanya support format ini secara native.

### Format Currency
Semua nilai uang disimpan dan dikirim sebagai **integer (Rupiah penuh)**. Formatting tampilan dilakukan di sisi Flutter/Next.js, bukan di backend.
```json
"harga_barang": 85000      ✅ benar
"harga_barang": 85000.00   ❌ salah
"harga_barang": "85.000"   ❌ salah
```

### Field Naming Convention
Semua field menggunakan `snake_case`. Tidak ada camelCase, tidak ada PascalCase.

### Query Parameter Standard
| Parameter     | Fungsi                        | Contoh                       |
|---------------|-------------------------------|------------------------------|
| `page`        | Halaman pagination            | `?page=1`                    |
| `limit`       | Jumlah data per halaman       | `?limit=10`                  |
| `search`      | Pencarian teks                | `?search=laptop`             |
| `sort`        | Field yang di-sort            | `?sort=created_at`           |
| `order`       | Arah sort                     | `?order=asc` / `?order=desc` |
| `status`      | Filter by status              | `?status=diproses`           |
| `kategori_id` | Filter by kategori            | `?kategori_id=3`             |
| `filter`      | Filter periode laporan        | `?filter=harian`             |
| `type`        | Filter tipe pesanan/transaksi | `?type=online`               |

### Pagination Response
Endpoint yang return list besar wajib menyertakan `meta`:
```json
{
  "status": "success",
  "message": "...",
  "data": [...],
  "meta": {
    "page": 1,
    "limit": 10,
    "total": 100,
    "total_pages": 10
  }
}
```

### Autentikasi per Client
| Client        | Mekanisme Auth                         |
|---------------|----------------------------------------|
| Flutter       | `Authorization: Bearer <access_token>` |
| Next.js Web   | `httpOnly Cookie` (otomatis oleh browser) |

---

## 2. TEMPLATE & CARA PAKAI

> Bagian ini adalah **panduan wajib** bagi semua developer yang ingin menambah atau mengubah dokumentasi API. Ikuti template yang sesuai agar dokumentasi tetap konsisten.

---

### TEMPLATE A — Tambah Endpoint Baru

Gunakan template ini setiap kali membuat endpoint baru. Copy bagian di bawah, isi semua field, lalu letakkan di section role yang sesuai.

```markdown
#### [Nomor]. [Nama Endpoint]

| Field         | Detail                                      |
|---------------|---------------------------------------------|
| **Endpoint**  | `/api/v1/[path]`                            |
| **Method**    | `GET` / `POST` / `PUT` / `PATCH` / `DELETE` |
| **Auth**      | Bearer Token / Cookie / Public (no auth)    |
| **Client**    | Flutter / Next.js / Both                    |
| **Deskripsi** | [Penjelasan singkat fungsi endpoint]        |

**Request Headers:**
```
Authorization: Bearer <token>    ← untuk Flutter
Cookie: session=<token>          ← untuk Next.js, otomatis dari browser
```

**Query Parameters:** *(jika ada)*
| Parameter | Tipe    | Wajib | Deskripsi        |
|-----------|---------|-------|------------------|
| `search`  | string  | Tidak | Kata kunci cari  |

**Request Body:** *(jika ada, untuk POST/PUT/PATCH)*
```json
{
  "field_name": "tipe_data"
}
```

**Response Success:**
```json
{
  "status": "success",
  "message": "Pesan sukses yang human-readable",
  "data": { }
}
```

**Response Error:**
```json
{
  "status": "error",
  "message": "Pesan error untuk ditampilkan di UI",
  "error": {
    "code": "KODE_ERROR",
    "detail": "Detail teknis untuk debugging"
  }
}
```

**HTTP Status yang Mungkin:** `200` `201` `400` `401` `403` `404` `422` `500`
```

---

### TEMPLATE B — Tambah Fitur Baru

Gunakan template ini sebelum mulai mengerjakan fitur baru. Isi dulu, diskusikan dengan tim, baru eksekusi.

```markdown
## FITUR: [Nama Fitur]

**Tanggal Dibuat:** YYYY-MM-DD
**Dibuat oleh:** [Nama]
**Status:** Draft / Review / Approved / Done

### Deskripsi Singkat
[Apa yang dilakukan fitur ini? Maksimal 3 kalimat.]

### Role yang Terlibat
- [ ] Customer (Flutter)
- [ ] Kasir (Flutter)
- [ ] Admin (Next.js)
- [ ] Kurir (roadmap)

### Tabel Database yang Terpengaruh
| Tabel        | Perubahan                                         |
|--------------|---------------------------------------------------|
| `nama_tabel` | Tambah kolom / Buat tabel baru / Tidak ada        |

### Daftar Endpoint yang Perlu Dibuat
| Method | Path           | Deskripsi |
|--------|----------------|-----------|
| GET    | `/api/v1/...`  | ...       |

### Checklist Keamanan
- [ ] Endpoint sudah dilindungi middleware auth
- [ ] Role yang boleh akses sudah didefinisikan
- [ ] Input sudah divalidasi (tidak bisa inject SQL/XSS)
- [ ] ID yang diekspos ke URL sudah menggunakan public_id / UUID (jika sensitif)
- [ ] Ownership check sudah diterapkan (user hanya bisa akses datanya sendiri)

### Catatan Tambahan
[Hal-hal khusus yang perlu diperhatikan developer]
```

---

### TEMPLATE C — Error Code Registry

Daftar semua error code yang terdaftar. Setiap kali menambah error code baru, **wajib daftarkan di sini** untuk menghindari duplikasi.

| Kode         | HTTP Status | Pesan (untuk UI)                               | Kapan Dipakai                                |
|--------------|-------------|------------------------------------------------|----------------------------------------------|
| `AUTH_001`   | 401         | Token tidak valid atau sudah expired           | JWT invalid / expired                        |
| `AUTH_002`   | 403         | Anda tidak memiliki akses ke resource ini      | Role tidak sesuai                            |
| `AUTH_003`   | 401         | Sesi Anda telah berakhir, silakan login kembali| Refresh token expired atau tidak valid       |
| `REQ_001`    | 400         | Parameter tidak valid                          | Query param salah format                     |
| `REQ_002`    | 400         | Parameter type tidak valid                     | Nilai enum tidak sesuai                      |
| `REQ_003`    | 400         | Request tidak valid                            | Body request tidak sesuai                    |
| `VAL_001`    | 422         | Validasi gagal                                 | Input form tidak valid (multiple errors)     |
| `VAL_002`    | 422         | Konfirmasi password tidak cocok                | password != konfirmasi_password              |
| `VAL_003`    | 422         | Format email tidak valid                       | Email tidak sesuai format                    |
| `DATA_001`   | 404         | Data tidak ditemukan                           | ID tidak ada di database                     |
| `DATA_002`   | 404         | Pesanan tidak ditemukan                        | ID pesanan tidak valid                       |
| `DATA_003`   | 404         | Produk tidak ditemukan                         | ID / barcode barang tidak ada                |
| `DATA_004`   | 404         | Pengguna tidak ditemukan                       | ID user tidak ada                            |
| `CONF_001`   | 409         | Username sudah terdaftar                       | Duplicate username                           |
| `CONF_002`   | 409         | Email sudah terdaftar                          | Duplicate email                              |
| `STOCK_001`  | 400         | Stok tidak mencukupi                           | Jumlah request melebihi stok                 |
| `PAY_001`    | 400         | Uang diterima kurang dari total pembayaran     | Pembayaran tunai kurang                      |
| `PAY_002`    | 502         | Gagal terhubung ke payment gateway             | Midtrans tidak merespon                      |
| `ORDER_001`  | 403         | Pesanan tidak dapat dibatalkan                 | Status sudah dikirim / selesai               |
| `GPS_001`    | 503         | Gagal terhubung dengan GPS kurir               | Lokasi kurir tidak tersedia                  |
| `SERVER_001` | 500         | Terjadi kesalahan pada server                  | Generic server error                         |
| `SERVER_002` | 500         | Gagal mengambil data laporan                   | DB error saat ambil laporan                  |
| `SERVER_003` | 500         | Gagal mengambil daftar pesanan                 | DB error saat ambil pesanan                  |
| `SERVER_004` | 500         | Gagal mengambil notifikasi                     | DB error saat ambil notifikasi               |
| `RATE_001`   | 429         | Terlalu banyak permintaan, coba lagi nanti     | Rate limit tercapai                          |

> **Cara tambah error code baru:**
> 1. Tentukan prefix yang sesuai (AUTH / REQ / VAL / DATA / CONF / STOCK / PAY / ORDER / GPS / SERVER / RATE)
> 2. Ambil nomor urut berikutnya dalam prefix tersebut
> 3. Tambahkan ke tabel di atas
> 4. Gunakan kode tersebut secara konsisten di kode Golang dan dokumentasi ini

---

### TEMPLATE D — Deprecation & Perubahan Endpoint

Gunakan setiap kali mengubah atau menghapus endpoint. Penting agar Flutter/Next.js dev tidak kaget ada breaking change.

```markdown
## PERUBAHAN: [Nama Perubahan]

**Tanggal:** YYYY-MM-DD
**Tipe:** Breaking Change / Non-Breaking / Deprecation
**Diubah oleh:** [Nama]

### Endpoint Lama
`[METHOD] [path lama]`

### Endpoint Baru *(jika ada)*
`[METHOD] [path baru]`

### Apa yang Berubah
[Jelaskan perubahan: field ditambah/dihapus/ganti nama, HTTP method berubah, dll]

### Migration Guide untuk Flutter / Next.js
[Langkah-langkah yang harus dilakukan developer client]

### Deadline Deprecated
[Tanggal endpoint lama akan dihapus, atau "Tidak ada" jika non-breaking]
```

---

### TEMPLATE E — Update Dokumentasi yang Sudah Ada

Gunakan setiap kali mengubah dokumentasi endpoint yang sudah ada.

```markdown
## UPDATE DOC: [Nama Endpoint]

**Tanggal:** YYYY-MM-DD
**Diubah oleh:** [Nama]
**Alasan:** [Kenapa dokumentasi diubah]

### Sebelum
[Tempel bagian dokumentasi lama]

### Sesudah
[Tempel bagian dokumentasi baru]

### Apakah ada perubahan kode?
- [ ] Ya — backend sudah diupdate
- [ ] Tidak — hanya perbaikan typo / klarifikasi
```

---

## 3. AUTHENTICATION

> Semua endpoint auth dapat diakses tanpa token kecuali `/logout` dan `/change-password`.
> **Client:** Flutter & Next.js (semua role)

---

#### 3.1 Login

| Field        | Detail               |
|--------------|----------------------|
| **Endpoint** | `POST /api/v1/login` |
| **Auth**     | Public (no auth)     |
| **Client**   | Flutter & Next.js    |

**Request Body:**
```json
{
  "username": "string",
  "password": "string"
}
```

**Response Success Flutter — 200 OK:**
```json
{
  "status": "success",
  "message": "Login berhasil",
  "data": {
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "token_type": "Bearer",
    "expires_in": 900,
    "user": {
      "id_user": 1,
      "username": "john_doe",
      "email": "john@email.com",
      "nama_lengkap": "John Doe",
      "role": "customer",
      "profile_id": 10
    }
  }
}
```

**Response Success Next.js — 200 OK:**
```json
{
  "status": "success",
  "message": "Login berhasil",
  "data": {
    "user": {
      "id_user": 1,
      "username": "admin_mantra",
      "nama_lengkap": "Admin Mantra",
      "role": "admin"
    }
  }
}
```
> Token untuk Next.js di-set otomatis via response header:
> `Set-Cookie: access_token=...; HttpOnly; Secure; SameSite=Strict`
> Tidak ada token di response body.

**Response Error — 401:**
```json
{
  "status": "error",
  "message": "Username atau password salah",
  "error": {
    "code": "AUTH_001",
    "detail": "Credential tidak valid"
  }
}
```

---

#### 3.2 Refresh Token

| Field        | Detail                              |
|--------------|-------------------------------------|
| **Endpoint** | `POST /api/v1/auth/refresh`         |
| **Auth**     | Refresh Token                       |
| **Client**   | Flutter (body) & Next.js (cookie)   |

**Request — Flutter:**
```json
{
  "refresh_token": "string"
}
```

**Request — Next.js:** Otomatis dari cookie, tidak perlu body.

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Token berhasil diperbarui",
  "data": {
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expires_in": 900
  }
}
```

**Response Error — 401:**
```json
{
  "status": "error",
  "message": "Sesi Anda telah berakhir, silakan login kembali",
  "error": {
    "code": "AUTH_003",
    "detail": "Refresh token expired atau tidak valid"
  }
}
```

---

#### 3.3 Logout

| Field        | Detail                        |
|--------------|-------------------------------|
| **Endpoint** | `POST /api/v1/logout`         |
| **Auth**     | Bearer Token / Cookie         |
| **Client**   | Flutter & Next.js             |

**Request — Flutter:**
```
Header: Authorization: Bearer <access_token>
Body:   { "refresh_token": "string" }
```

**Request — Next.js:** Otomatis dari cookie, tidak perlu body atau header manual.

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Logout berhasil"
}
```

**Response Error — 401:**
```json
{
  "status": "error",
  "message": "Token tidak valid atau sudah expired",
  "error": {
    "code": "AUTH_001",
    "detail": "Token tidak ditemukan atau sudah direvoke"
  }
}
```

---

#### 3.4 Register Customer

| Field        | Detail                    |
|--------------|---------------------------|
| **Endpoint** | `POST /api/v1/register`   |
| **Auth**     | Public (no auth)          |
| **Client**   | Flutter (Customer)        |

**Request Body:**
```json
{
  "username": "string",
  "email": "string",
  "password": "string",
  "konfirmasi_password": "string",
  "nama_lengkap": "string",
  "no_telp": "string"
}
```

**Response Success — 201 Created:**
```json
{
  "status": "success",
  "message": "Registrasi berhasil",
  "data": {
    "id_user": 1,
    "username": "john_doe",
    "email": "john@email.com",
    "nama_lengkap": "John Doe",
    "no_telp": "081234567890",
    "role": "customer"
  }
}
```

**Response Error — 409 Conflict:**
```json
{
  "status": "error",
  "message": "Username sudah terdaftar",
  "error": {
    "code": "CONF_001",
    "detail": "Duplicate entry pada kolom username"
  }
}
```

**Response Error — 422 Unprocessable Entity:**
```json
{
  "status": "error",
  "message": "Validasi gagal",
  "error": {
    "code": "VAL_001",
    "detail": "Input tidak memenuhi aturan validasi"
  },
  "errors": {
    "username": "Username wajib diisi",
    "email": "Format email tidak valid",
    "password": "Password minimal 8 karakter",
    "konfirmasi_password": "Konfirmasi password tidak cocok",
    "no_telp": "Nomor telepon wajib diisi"
  }
}
```

---

#### 3.5 Change Password

| Field        | Detail                         |
|--------------|--------------------------------|
| **Endpoint** | `PUT /api/v1/change-password`  |
| **Auth**     | Bearer Token / Cookie          |
| **Client**   | Flutter & Next.js              |

**Request Body:**
```json
{
  "password_lama": "string",
  "password_baru": "string",
  "konfirmasi_password": "string"
}
```

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Password berhasil diubah"
}
```

**Response Error — 400:**
```json
{
  "status": "error",
  "message": "Password lama tidak sesuai",
  "error": {
    "code": "REQ_003",
    "detail": "Password lama yang dimasukkan salah"
  }
}
```

**Response Error — 422:**
```json
{
  "status": "error",
  "message": "Konfirmasi password tidak cocok",
  "error": {
    "code": "VAL_002",
    "detail": "password_baru dan konfirmasi_password tidak sama"
  }
}
```

---

## 4. CUSTOMER ENDPOINTS — Flutter

> Semua endpoint Customer memerlukan `Authorization: Bearer <token>`.
> Role yang diizinkan: `customer`

---

### 4.1 Home

#### 4.1.1 Promo

| Field        | Detail                       |
|--------------|------------------------------|
| **Endpoint** | `GET /api/v1/customer/promo` |
| **Auth**     | Bearer Token                 |
| **Client**   | Flutter (Customer)           |

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Berhasil mengambil data promo",
  "data": [
    {
      "id_diskon": 1,
      "nama_diskon": "Promo Awal Tahun",
      "banner_url": "https://api.mantra.com/storage/banner/promo-1.jpg",
      "tgl_selesai": "2026-12-31T23:59:59Z"
    }
  ]
}
```

**Response — Data Kosong (200 OK):**
```json
{
  "status": "success",
  "message": "Saat ini tidak ada promo yang tersedia",
  "data": []
}
```
> Data kosong tetap `200 OK` dengan `data: []`. Bukan 404.

**Response Error — 500:**
```json
{
  "status": "error",
  "message": "Terjadi kesalahan pada server",
  "error": {
    "code": "SERVER_001",
    "detail": "Gagal mengambil data promo"
  }
}
```

---

#### 4.1.2 Kategori

| Field        | Detail                          |
|--------------|---------------------------------|
| **Endpoint** | `GET /api/v1/customer/kategori` |
| **Auth**     | Bearer Token                    |
| **Client**   | Flutter (Customer)              |

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Berhasil mengambil daftar kategori",
  "data": [
    {
      "id_kategori": 1,
      "nama_kategori": "Gadget",
      "icon_kategori": "https://api.mantra.com/storage/icons/gadget.png"
    }
  ]
}
```

**Response — Data Kosong (200 OK):**
```json
{
  "status": "success",
  "message": "Belum ada kategori yang tersedia",
  "data": []
}
```

---

#### 4.1.3 Katalog Barang

| Field        | Detail                        |
|--------------|-------------------------------|
| **Endpoint** | `GET /api/v1/customer/barang` |
| **Auth**     | Bearer Token                  |
| **Client**   | Flutter (Customer)            |

**Query Parameters:**
| Parameter     | Tipe    | Wajib | Deskripsi                                   |
|---------------|---------|-------|---------------------------------------------|
| `search`      | string  | Tidak | Cari berdasarkan nama barang                |
| `kategori_id` | integer | Tidak | Filter berdasarkan kategori                 |
| `limit`       | integer | Tidak | Batasi jumlah hasil (contoh: 4 untuk home)  |
| `page`        | integer | Tidak | Halaman, default 1                          |

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Berhasil mengambil daftar barang",
  "data": [
    {
      "id_barang": 1,
      "nama_barang": "Laptop Gaming X",
      "harga_terendah": 13500000,
      "harga_tertinggi": 15000000,
      "harga_diskon": 12150000,
      "punya_diskon": true,
      "gambar_barang": "https://api.mantra.com/storage/barang/laptop-x.jpg"
    }
  ],
  "meta": {
    "page": 1,
    "limit": 10,
    "total": 50,
    "total_pages": 5
  }
}
```

---

### 4.2 Scan Barcode

| Field        | Detail                                |
|--------------|---------------------------------------|
| **Endpoint** | `GET /api/v1/scan/{kode_barcode}`     |
| **Auth**     | Bearer Token                          |
| **Client**   | Flutter (Customer & Kasir)            |

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Data barang ditemukan",
  "data": {
    "id_barang": 10,
    "nama_barang": "Laptop Gaming X",
    "kode_barcode": "89912345678",
    "gambar_barang": "https://api.mantra.com/storage/barang/laptop-x.jpg",
    "kategori": "Elektronik",
    "satuan": "Unit",
    "diskon": {
      "nama_diskon": "Promo Awal Tahun",
      "besar_diskon": 10,
      "tgl_selesai": "2026-12-31T23:59:59Z"
    },
    "varian": [
      {
        "id_spesifikasi_barang": 5,
        "nama_spesifikasi": "RAM",
        "nama_detail": "16GB",
        "harga_barang": 15000000,
        "harga_diskon": 13500000,
        "stok": 5
      }
    ]
  }
}
```

**Response Error — 404:**
```json
{
  "status": "error",
  "message": "Barang tidak ditemukan",
  "error": {
    "code": "DATA_003",
    "detail": "Kode barcode tidak terdaftar"
  }
}
```

---

### 4.3 Keranjang

#### 4.3.1 Tambah ke Keranjang

| Field        | Detail                             |
|--------------|------------------------------------|
| **Endpoint** | `POST /api/v1/customer/keranjang`  |
| **Auth**     | Bearer Token                       |
| **Client**   | Flutter (Customer)                 |

**Request Body:**
```json
{
  "id_spesifikasi_barang": 5,
  "quantity": 2
}
```

**Response Success — 201 Created:**
```json
{
  "status": "success",
  "message": "Barang berhasil ditambahkan ke keranjang"
}
```

**Response Error — 400 (Stok tidak cukup):**
```json
{
  "status": "error",
  "message": "Stok tidak mencukupi",
  "error": {
    "code": "STOCK_001",
    "detail": "Jumlah yang diminta melebihi stok yang tersedia"
  }
}
```

**Response Error — 404:**
```json
{
  "status": "error",
  "message": "Produk tidak ditemukan",
  "error": {
    "code": "DATA_003",
    "detail": "id_spesifikasi_barang tidak ditemukan"
  }
}
```

---

#### 4.3.2 Update Item Keranjang

| Field        | Detail                                             |
|--------------|----------------------------------------------------|
| **Endpoint** | `PATCH /api/v1/customer/keranjang/{id_keranjang}`  |
| **Auth**     | Bearer Token                                       |
| **Client**   | Flutter (Customer)                                 |

**Request Body:**
```json
{
  "quantity": 3
}
```

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Keranjang berhasil diperbarui"
}
```

**Response Error — 404:**
```json
{
  "status": "error",
  "message": "Item keranjang tidak ditemukan",
  "error": {
    "code": "DATA_001",
    "detail": "id_keranjang tidak ditemukan"
  }
}
```

**Response Error — 400:**
```json
{
  "status": "error",
  "message": "Stok tidak mencukupi",
  "error": {
    "code": "STOCK_001",
    "detail": "Jumlah yang diminta melebihi stok yang tersedia"
  }
}
```

---

#### 4.3.3 Hapus Item Keranjang

| Field        | Detail                                              |
|--------------|-----------------------------------------------------|
| **Endpoint** | `DELETE /api/v1/customer/keranjang/{id_keranjang}`  |
| **Auth**     | Bearer Token                                        |
| **Client**   | Flutter (Customer)                                  |

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Item keranjang berhasil dihapus"
}
```

**Response Error — 403 (Bukan miliknya):**
```json
{
  "status": "error",
  "message": "Anda tidak memiliki akses untuk menghapus item ini",
  "error": {
    "code": "AUTH_002",
    "detail": "id_keranjang bukan milik user yang sedang login"
  }
}
```

---

### 4.4 Notifikasi

| Field        | Detail                              |
|--------------|-------------------------------------|
| **Endpoint** | `GET /api/v1/customer/notifikasi`   |
| **Auth**     | Bearer Token                        |
| **Client**   | Flutter (Customer)                  |

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Notifikasi berhasil diambil",
  "data": [
    {
      "id_notifikasi": 1,
      "judul": "Diskon Menanti!",
      "pesan": "Ada diskon 10% untuk barang favoritmu hari ini.",
      "status": "unread",
      "created_at": "2026-05-05T10:00:00Z"
    }
  ]
}
```

---

### 4.5 Pesanan

#### 4.5.1 Daftar Pesanan

| Field        | Detail                          |
|--------------|---------------------------------|
| **Endpoint** | `GET /api/v1/customer/pesanan`  |
| **Auth**     | Bearer Token                    |
| **Client**   | Flutter (Customer)              |

**Query Parameters:**
| Parameter | Tipe   | Wajib | Deskripsi                                                        |
|-----------|--------|-------|------------------------------------------------------------------|
| `status`  | string | Tidak | diproses \| dikemas \| dikirim \| selesai \| dibatalkan          |

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Daftar pesanan berhasil diambil",
  "data": [
    {
      "id_pesanan": "12345678",
      "status": "diproses",
      "tanggal_pesan": "2026-04-10T22:39:00Z",
      "total_bayar": 50000,
      "items": [
        {
          "id_barang": 101,
          "nama_barang": "Novel Ancika 1995",
          "jumlah": 1,
          "harga_saat_beli": 50000,
          "gambar": "https://api.mantra.com/storage/barang/ancika.jpg"
        }
      ]
    }
  ],
  "meta": {
    "page": 1,
    "limit": 10,
    "total": 5,
    "total_pages": 1
  }
}
```

**Response — Belum ada pesanan (200 OK):**
```json
{
  "status": "success",
  "message": "Kamu belum memiliki riwayat pesanan",
  "data": []
}
```

---

#### 4.5.2 Checkout / Buat Pesanan

| Field        | Detail                                   |
|--------------|------------------------------------------|
| **Endpoint** | `POST /api/v1/customer/pesanan/checkout` |
| **Auth**     | Bearer Token                             |
| **Client**   | Flutter (Customer)                       |

> `id_customer` tidak perlu dikirim — diambil dari JWT claims di backend.

**Request Body:**
```json
{
  "id_alamat": 3,
  "metode_pembayaran": "qris",
  "items": [
    {
      "id_spesifikasi_barang": 5,
      "jumlah": 1
    }
  ]
}
```

**Response Success — 201 Created:**
```json
{
  "status": "success",
  "message": "Pesanan berhasil dibuat",
  "data": {
    "id_pesanan": "12345678",
    "midtrans_token": "token-untuk-sdk-flutter",
    "redirect_url": "https://app.sandbox.midtrans.com/snap/v2/vtweb/..."
  }
}
```

**Response Error — 400 (Stok habis):**
```json
{
  "status": "error",
  "message": "Stok tidak mencukupi",
  "error": {
    "code": "STOCK_001",
    "detail": "Stok untuk varian yang dipilih tidak mencukupi"
  }
}
```

---

#### 4.5.3 Batalkan Pesanan

| Field        | Detail                                               |
|--------------|------------------------------------------------------|
| **Endpoint** | `PATCH /api/v1/customer/pesanan/{id_pesanan}/batal`  |
| **Auth**     | Bearer Token                                         |
| **Client**   | Flutter (Customer)                                   |

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Pesanan berhasil dibatalkan"
}
```

**Response Error — 403:**
```json
{
  "status": "error",
  "message": "Pesanan tidak dapat dibatalkan karena barang sudah dikirim",
  "error": {
    "code": "ORDER_001",
    "detail": "Status pesanan sudah dikirim atau selesai"
  }
}
```

---

#### 4.5.4 Detail Pesanan

| Field        | Detail                                      |
|--------------|---------------------------------------------|
| **Endpoint** | `GET /api/v1/customer/pesanan/{id_pesanan}` |
| **Auth**     | Bearer Token                                |
| **Client**   | Flutter (Customer)                          |

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Detail pesanan berhasil diambil",
  "data": {
    "no_pesanan": "12345678",
    "status": "diproses",
    "tanggal_pesan": "2026-05-05T22:39:00Z",
    "items": [
      {
        "id_barang": 101,
        "nama_barang": "Kipas Angin Portable",
        "varian": "Putih",
        "jumlah": 1,
        "harga_satuan": 50000,
        "gambar": "https://api.mantra.com/storage/barang/kipas.jpg"
      }
    ],
    "tujuan_pengantaran": {
      "nama_penerima": "Ibu Yunani",
      "alamat_lengkap": "Jl. Melati Merah No. 35, Surakarta 50341"
    },
    "kurir": {
      "nama_kurir": "Ricardo Holahilo",
      "plat_nomor": "H 6582 TH",
      "ekspedisi": "SPEX Express",
      "foto_kurir": "https://api.mantra.com/storage/kurir/ricardo.jpg"
    },
    "rincian_pembayaran": {
      "subtotal_items": 150000,
      "ongkir": 20000,
      "biaya_proteksi": 2000,
      "total": 172000
    }
  }
}
```

---

#### 4.5.5 Lacak Pesanan

| Field        | Detail                                              |
|--------------|-----------------------------------------------------|
| **Endpoint** | `GET /api/v1/customer/pesanan/{id_pesanan}/lacak`   |
| **Auth**     | Bearer Token                                        |
| **Client**   | Flutter (Customer)                                  |

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Data lacak pesanan berhasil diambil",
  "data": {
    "id_pesanan": "12345678",
    "kurir": {
      "nama": "Ricardo Holahilo",
      "plat_nomor": "H 6582 TH",
      "foto": "https://api.mantra.com/storage/kurir/ricardo.jpg"
    },
    "lokasi_kurir": {
      "latitude": -7.052,
      "longitude": 110.439
    },
    "estimasi_tiba": "8 mins",
    "jarak_meter": 1500
  }
}
```

**Response Error — 403:**
```json
{
  "status": "error",
  "message": "Pesanan belum dalam perjalanan atau sudah selesai",
  "error": {
    "code": "ORDER_001",
    "detail": "Status pesanan tidak memenuhi syarat untuk dilacak"
  }
}
```

**Response Error — 503:**
```json
{
  "status": "error",
  "message": "Gagal terhubung dengan GPS kurir",
  "error": {
    "code": "GPS_001",
    "detail": "Koordinat kurir tidak tersedia saat ini"
  }
}
```

---

### 4.6 Profil Customer

#### 4.6.1 Tampil Profil

| Field        | Detail                         |
|--------------|--------------------------------|
| **Endpoint** | `GET /api/v1/customer/profil`  |
| **Auth**     | Bearer Token                   |
| **Client**   | Flutter (Customer)             |

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Data profil berhasil diambil",
  "data": {
    "user": {
      "nama_lengkap": "Aarav Lysander",
      "no_telp": "+62 81222222222",
      "email": "lysander@gmail.com",
      "username": "aarav_"
    },
    "daftar_alamat": [
      {
        "id_alamat": 1,
        "label_alamat": "Rumah",
        "nama_penerima": "Aarav",
        "no_telp_penerima": "0812...",
        "alamat_lengkap": "Jl. Cempaka Putih No. 12...",
        "is_utama": true
      }
    ]
  }
}
```

---

#### 4.6.2 Edit Informasi Akun

| Field        | Detail                      |
|--------------|-----------------------------|
| **Endpoint** | `PUT /api/v1/customer/akun` |
| **Auth**     | Bearer Token                |
| **Client**   | Flutter (Customer)          |

**Request Body:**
```json
{
  "nama_lengkap": "Aarav Lysander",
  "no_telp": "+62 81222222222",
  "email": "lysander@gmail.com",
  "username": "aarav_new"
}
```

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Informasi akun berhasil diperbarui",
  "data": {
    "nama_lengkap": "Aarav Lysander",
    "no_telp": "+62 81222222222",
    "email": "lysander@gmail.com",
    "username": "aarav_new"
  }
}
```

**Response Error — 409:**
```json
{
  "status": "error",
  "message": "Username atau email sudah digunakan",
  "error": {
    "code": "CONF_001",
    "detail": "Duplicate entry username atau email"
  }
}
```

---

#### 4.6.3 Tambah Alamat

| Field        | Detail                         |
|--------------|--------------------------------|
| **Endpoint** | `POST /api/v1/customer/alamat` |
| **Auth**     | Bearer Token                   |
| **Client**   | Flutter (Customer)             |

**Request Body:**
```json
{
  "nama_penerima": "Aarav Lysander",
  "label_alamat": "Rumah",
  "no_telp_penerima": "081234567890",
  "alamat_lengkap": "Jl. Gajahmada No. 100, Semarang Tengah",
  "latitude": -6.982,
  "longitude": 110.422,
  "catatan_lokasi": "Pagar warna hitam",
  "is_utama": false
}
```

> `label_alamat` enum values: `Rumah` | `Kantor` | `Kos` | `Lainnya`

**Response Success — 201 Created:**
```json
{
  "status": "success",
  "message": "Alamat baru berhasil ditambahkan",
  "data": {
    "id_alamat": 15,
    "label_alamat": "Rumah",
    "is_utama": false
  }
}
```

---

#### 4.6.4 Edit Alamat

| Field        | Detail                                    |
|--------------|-------------------------------------------|
| **Endpoint** | `PUT /api/v1/customer/alamat/{id_alamat}` |
| **Auth**     | Bearer Token                              |
| **Client**   | Flutter (Customer)                        |

**Request Body:** *(sama seperti Tambah Alamat)*

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Alamat berhasil diperbarui",
  "data": {
    "id_alamat": 1,
    "label_alamat": "Kos",
    "is_utama": true
  }
}
```

---

#### 4.6.5 Hapus Alamat

| Field        | Detail                                       |
|--------------|----------------------------------------------|
| **Endpoint** | `DELETE /api/v1/customer/alamat/{id_alamat}` |
| **Auth**     | Bearer Token                                 |
| **Client**   | Flutter (Customer)                           |

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Alamat berhasil dihapus"
}
```

---

## 5. KASIR ENDPOINTS — Flutter

> Semua endpoint Kasir memerlukan `Authorization: Bearer <token>`.
> Role yang diizinkan: `kasir`

---

### 5.1 Dashboard

| Field        | Detail                         |
|--------------|--------------------------------|
| **Endpoint** | `GET /api/v1/kasir/dashboard`  |
| **Auth**     | Bearer Token                   |
| **Client**   | Flutter (Kasir)                |

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Data dashboard berhasil diambil",
  "data": {
    "user": {
      "nama_kasir": "Budi Santoso",
      "status_notifikasi": true
    },
    "statistik_hari_ini": {
      "total_pendapatan": 1500000,
      "jumlah_transaksi": 12,
      "total_item_terjual": 35
    },
    "aktivitas_terkini": [
      {
        "id_transaksi": 101,
        "nomor_invoice": "INV-20260509-001",
        "metode_pembayaran": "cash",
        "waktu": "09:30",
        "total_bayar": 125000
      }
    ]
  }
}
```

---

### 5.2 Laporan Penjualan

#### 5.2.1 Ringkasan Laporan

| Field        | Detail                       |
|--------------|------------------------------|
| **Endpoint** | `GET /api/v1/kasir/laporan`  |
| **Auth**     | Bearer Token                 |
| **Client**   | Flutter (Kasir)              |

**Query Parameters:**
| Parameter | Tipe   | Wajib | Nilai                              |
|-----------|--------|-------|------------------------------------|
| `filter`  | string | Tidak | harian \| mingguan \| bulanan      |
| `search`  | string | Tidak | Cari produk terlaris               |

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Data laporan berhasil diambil",
  "data": {
    "header_statistik": {
      "total_pendapatan": 5000000,
      "persentase_kenaikan_pendapatan": 12.5,
      "total_transaksi": 40,
      "persentase_kenaikan_transaksi": 5.0,
      "rata_rata_pesanan": 125000,
      "status_rata_rata": "naik"
    },
    "grafik_pendapatan": [
      {
        "label": "08:00",
        "nilai": 250000,
        "is_highlight": false
      }
    ],
    "produk_terlaris": [
      {
        "id_produk": 1,
        "nama_produk": "Laptop Gaming X",
        "deskripsi": "16GB RAM, 1TB SSD",
        "jumlah_terjual": 15,
        "gambar": "https://api.mantra.com/storage/barang/laptop-x.jpg"
      }
    ]
  }
}
```

---

#### 5.2.2 Detail Transaksi per Produk

| Field        | Detail                                          |
|--------------|-------------------------------------------------|
| **Endpoint** | `GET /api/v1/kasir/laporan/produk/{id_produk}`  |
| **Auth**     | Bearer Token                                    |
| **Client**   | Flutter (Kasir)                                 |

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Detail produk berhasil diambil",
  "data": {
    "produk": {
      "id_produk": 1,
      "nama_produk": "Laptop Gaming X",
      "kategori": "Elektronik",
      "gambar": "https://api.mantra.com/storage/barang/laptop-x.jpg"
    },
    "statistik_produk": {
      "total_terjual": 50,
      "terjual_periode_ini": 15,
      "label_periode": "mingguan"
    },
    "riwayat_transaksi": [
      {
        "id_transaksi": 101,
        "nomor_invoice": "INV-20260509-001",
        "tanggal_waktu": "2026-05-09T09:30:00Z",
        "subtotal": 13500000,
        "quantity": 1
      }
    ]
  }
}
```

---

#### 5.2.3 Detail Pesanan dari Laporan

| Field        | Detail                                                            |
|--------------|-------------------------------------------------------------------|
| **Endpoint** | `GET /api/v1/kasir/laporan/produk/{id_produk}/{id_pesanan}`       |
| **Auth**     | Bearer Token                                                      |
| **Client**   | Flutter (Kasir)                                                   |

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Detail pesanan berhasil diambil",
  "data": {
    "order_info": {
      "nomor_order": "ORD-20260509-001",
      "tanggal_waktu": "2026-05-09T09:30:00Z",
      "status_order": {
        "kode": "selesai",
        "label": "Selesai"
      }
    },
    "pelanggan": {
      "nama": "Aarav Lysander",
      "alamat": "Jl. Cempaka Putih No. 12"
    },
    "daftar_item": [
      {
        "id_produk": 1,
        "nama_produk": "Laptop Gaming X",
        "qty": 1,
        "total_harga_item": 13500000
      }
    ],
    "rincian_pembayaran": {
      "metode": "qris",
      "subtotal": 13500000,
      "pajak_nominal": 1485000,
      "total_akhir": 14985000
    }
  }
}
```

---

### 5.3 Pesanan Kasir

#### 5.3.1 Daftar Pesanan

| Field        | Detail                       |
|--------------|------------------------------|
| **Endpoint** | `GET /api/v1/kasir/pesanan`  |
| **Auth**     | Bearer Token                 |
| **Client**   | Flutter (Kasir)              |

**Query Parameters:**
| Parameter | Tipe   | Wajib | Nilai               |
|-----------|--------|-------|---------------------|
| `type`    | string | Tidak | online \| offline   |
| `search`  | string | Tidak | Nomor order / item  |

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Daftar pesanan berhasil diambil",
  "data": {
    "daftar_pesanan": [
      {
        "id_order": 101,
        "nomor_order": "ORD-20260509-001",
        "sumber_pesanan": {
          "kode": "online",
          "icon_type": "globe"
        },
        "status": {
          "kode": "diproses",
          "label": "Diproses"
        },
        "ringkasan_item": "2x Kopi, 1x Roti",
        "waktu_relatif": "5 menit lalu",
        "total_harga": 45000
      }
    ]
  },
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 45,
    "total_pages": 3
  }
}
```

---

#### 5.3.2 Detail Pesanan

| Field        | Detail                                 |
|--------------|----------------------------------------|
| **Endpoint** | `GET /api/v1/kasir/pesanan/{id_order}` |
| **Auth**     | Bearer Token                           |
| **Client**   | Flutter (Kasir)                        |

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Detail pesanan berhasil diambil",
  "data": {
    "order_header": {
      "id_order": 101,
      "nomor_order": "ORD-20260509-001",
      "tanggal_waktu": "2026-05-09T09:30:00Z",
      "status": {
        "kode": "selesai",
        "label": "Selesai",
        "warna_hex": "#22C55E"
      }
    },
    "informasi_pelanggan": {
      "nama": "Aarav Lysander",
      "alamat_pengiriman": "Jl. Cempaka Putih No. 12",
      "map_url": null
    },
    "item_pesanan": [
      {
        "id_produk": 1,
        "nama_produk": "Laptop Gaming X",
        "varian": "16GB RAM",
        "gambar": "https://api.mantra.com/storage/barang/laptop-x.jpg",
        "qty": 1,
        "harga_satuan": 13500000,
        "total_harga_item": 13500000
      }
    ],
    "data_kasir": {
      "nama_kasir": "Budi Santoso",
      "shift_info": "Shift Pagi"
    },
    "informasi_pembayaran": {
      "metode_pembayaran": "cash",
      "status_pembayaran": "lunas",
      "rincian_kalkulasi": {
        "subtotal": 13500000,
        "pajak_persen": 11,
        "pajak_nominal": 1485000,
        "total_akhir": 14985000
      }
    }
  }
}
```

---

### 5.4 Transaksi & Pembayaran

#### 5.4.1 Tambah Produk (Scan / Ketik)

| Field        | Detail                               |
|--------------|--------------------------------------|
| **Endpoint** | `POST /api/v1/kasir/transaksi/produk`|
| **Auth**     | Bearer Token                         |
| **Client**   | Flutter (Kasir)                      |

**Request Body:**
```json
{
  "query": "89912345678"
}
```

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Produk berhasil ditemukan",
  "data": {
    "id_produk": 1,
    "nama_produk": "Laptop Gaming X",
    "harga_satuan": 13500000,
    "gambar": "https://api.mantra.com/storage/barang/laptop-x.jpg",
    "varian": [
      {
        "id_spesifikasi_barang": 5,
        "label": "16GB RAM",
        "stok": 5
      }
    ]
  }
}
```

---

#### 5.4.2 Update Quantity Item

| Field        | Detail                                      |
|--------------|---------------------------------------------|
| **Endpoint** | `PATCH /api/v1/kasir/transaksi/item/update` |
| **Auth**     | Bearer Token                                |
| **Client**   | Flutter (Kasir)                             |

**Request Body:**
```json
{
  "id_spesifikasi_barang": 5,
  "aksi": "tambah",
  "quantity_baru": 2
}
```

> `aksi` values: `tambah` | `kurang` | `set`

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Quantity berhasil diperbarui",
  "data": null
}
```

---

#### 5.4.3 Ringkasan Checkout

| Field        | Detail                                 |
|--------------|----------------------------------------|
| **Endpoint** | `GET /api/v1/kasir/transaksi/checkout` |
| **Auth**     | Bearer Token                           |
| **Client**   | Flutter (Kasir)                        |

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Data checkout berhasil diambil",
  "data": {
    "order_info": {
      "id_order": 101,
      "nomor_order": "ORD-20260509-001"
    },
    "item_checkout": [
      {
        "nama_produk": "Laptop Gaming X",
        "varian": "16GB RAM",
        "qty": 1,
        "total_per_item": 13500000
      }
    ],
    "ringkasan_biaya": {
      "subtotal": 13500000,
      "pajak_nominal": 1485000,
      "total_akhir": 14985000
    },
    "pilihan_pembayaran": [
      {
        "id_metode": 1,
        "label": "Cash",
        "tipe": "cash"
      },
      {
        "id_metode": 2,
        "label": "QRIS",
        "tipe": "non-cash"
      }
    ]
  }
}
```

---

#### 5.4.4 Bayar Tunai

| Field        | Detail                                     |
|--------------|--------------------------------------------|
| **Endpoint** | `POST /api/v1/kasir/transaksi/bayar/tunai` |
| **Auth**     | Bearer Token                               |
| **Client**   | Flutter (Kasir)                            |

**Request Body:**
```json
{
  "id_order": 101,
  "uang_diterima": 15000000
}
```

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Pembayaran tunai berhasil",
  "data": {
    "kembalian": 15000,
    "invoice": {
      "nomor_invoice": "INV-20260509-001",
      "url_print_struk": "https://api.mantra.com/struk/INV-20260509-001"
    }
  }
}
```

**Response Error — 400:**
```json
{
  "status": "error",
  "message": "Uang yang diterima kurang dari total pembayaran",
  "error": {
    "code": "PAY_001",
    "detail": "uang_diterima lebih kecil dari total_akhir"
  }
}
```

---

#### 5.4.5 Bayar Non-Tunai (Midtrans)

| Field        | Detail                                         |
|--------------|------------------------------------------------|
| **Endpoint** | `POST /api/v1/kasir/transaksi/bayar/non-tunai` |
| **Auth**     | Bearer Token                                   |
| **Client**   | Flutter (Kasir)                                |

**Request Body:**
```json
{
  "id_order": 101,
  "payment_type": "qris"
}
```

> `payment_type` values: `qris` | `ewallet` | `va` | `kartu`

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Pembayaran non-tunai diproses",
  "data": {
    "midtrans_data": {
      "token": "snap-token-dari-midtrans",
      "redirect_url": "https://app.sandbox.midtrans.com/snap/v2/vtweb/..."
    }
  }
}
```

**Response Error — 502:**
```json
{
  "status": "error",
  "message": "Gagal terhubung ke payment gateway",
  "error": {
    "code": "PAY_002",
    "detail": "Midtrans tidak merespon dalam batas waktu"
  }
}
```

---

### 5.5 Profil & Notifikasi Kasir

#### 5.5.1 Profil Kasir

| Field        | Detail                     |
|--------------|----------------------------|
| **Endpoint** | `GET /api/v1/kasir/profil` |
| **Auth**     | Bearer Token               |
| **Client**   | Flutter (Kasir)            |

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Data profil berhasil diambil",
  "data": {
    "nama_kasir": "Budi Santoso",
    "email": "budi@mantra.com",
    "role": "kasir",
    "shift": "Pagi",
    "status_akun": "aktif"
  }
}
```

---

#### 5.5.2 Notifikasi Kasir

| Field        | Detail                         |
|--------------|--------------------------------|
| **Endpoint** | `GET /api/v1/kasir/notifikasi` |
| **Auth**     | Bearer Token                   |
| **Client**   | Flutter (Kasir)                |

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Daftar notifikasi berhasil diambil",
  "data": {
    "notifikasi_grup": [
      {
        "label_waktu": "Hari ini",
        "daftar_notifikasi": [
          {
            "id": 1,
            "judul": "Stok Menipis",
            "pesan": "Stok Laptop Gaming X tersisa 3 unit",
            "tipe_icon": "warning",
            "created_at": "2026-05-09T08:00:00Z"
          }
        ]
      }
    ]
  }
}
```

---

## 6. ADMIN ENDPOINTS — Next.js

> Semua endpoint Admin menggunakan autentikasi **httpOnly Cookie**.
> Token tidak dikirim di header — browser mengirim cookie secara otomatis.
> Role yang diizinkan: `admin`
>
> **Perbedaan utama vs Flutter:**
> - Tidak ada `Authorization: Bearer` header
> - Next.js menggunakan `credentials: 'include'` di setiap fetch/axios
> - Token di-set oleh server via `Set-Cookie` header, tidak ada di response body

---

### 6.1 Dashboard Admin

| Field        | Detail                         |
|--------------|--------------------------------|
| **Endpoint** | `GET /api/v1/admin/dashboard`  |
| **Auth**     | Cookie (httpOnly)              |
| **Client**   | Next.js (Admin)                |

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Data dashboard berhasil diambil",
  "data": {
    "penjualan_hari_ini": 5000000,
    "penjualan_mingguan": [
      {
        "tanggal": "2026-05-01T00:00:00Z",
        "jumlah": 3500000
      }
    ],
    "stok_menipis": [
      {
        "id_barang": 1,
        "nama_barang": "Laptop Gaming X",
        "varian": "16GB RAM",
        "stok": 3
      }
    ]
  }
}
```

---

### 6.2 Manajemen Barang

#### 6.2.1 Daftar Semua Barang

| Field        | Detail                      |
|--------------|-----------------------------|
| **Endpoint** | `GET /api/v1/admin/barang`  |
| **Auth**     | Cookie (httpOnly)           |
| **Client**   | Next.js (Admin)             |

**Query Parameters:**
| Parameter     | Tipe    | Wajib | Deskripsi          |
|---------------|---------|-------|--------------------|
| `search`      | string  | Tidak | Cari nama barang   |
| `kategori_id` | integer | Tidak | Filter kategori    |
| `page`        | integer | Tidak | Halaman            |
| `limit`       | integer | Tidak | Jumlah per halaman |

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Daftar barang berhasil diambil",
  "data": [
    {
      "id_barang": 1,
      "nama_barang": "Laptop Gaming X",
      "kategori": "Elektronik",
      "satuan": "Unit",
      "total_stok": 35,
      "gambar": "https://api.mantra.com/storage/barang/laptop-x.jpg",
      "punya_diskon": true
    }
  ],
  "meta": {
    "page": 1,
    "limit": 10,
    "total": 50,
    "total_pages": 5
  }
}
```

---

#### 6.2.2 Tambah Barang

| Field        | Detail                      |
|--------------|-----------------------------|
| **Endpoint** | `POST /api/v1/admin/barang` |
| **Auth**     | Cookie (httpOnly)           |
| **Client**   | Next.js (Admin)             |

**Request Body (multipart/form-data):**
```
nama_barang   : string
kategori_id   : integer
satuan_id     : integer
gambar        : file (opsional)
varian[]      : array of { nama_detail_spesifikasi, harga_barang, jumlah }
```

**Response Success — 201 Created:**
```json
{
  "status": "success",
  "message": "Barang berhasil ditambahkan",
  "data": {
    "id_barang": 51,
    "nama_barang": "Laptop Gaming X"
  }
}
```

---

#### 6.2.3 Detail Barang

| Field        | Detail                                |
|--------------|---------------------------------------|
| **Endpoint** | `GET /api/v1/admin/barang/{id_barang}`|
| **Auth**     | Cookie (httpOnly)                     |
| **Client**   | Next.js (Admin)                       |

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Detail barang berhasil diambil",
  "data": {
    "id_barang": 1,
    "nama_barang": "Laptop Gaming X",
    "kategori": "Elektronik",
    "satuan": "Unit",
    "gambar": "https://api.mantra.com/storage/barang/laptop-x.jpg",
    "diskon": {
      "nama_diskon": "Promo Awal Tahun",
      "besar_diskon": 10,
      "tgl_selesai": "2026-12-31T23:59:59Z"
    },
    "varian": [
      {
        "id_spesifikasi_barang": 5,
        "nama_spesifikasi": "RAM",
        "nama_detail": "16GB",
        "harga_barang": 15000000,
        "stok": 5
      }
    ]
  }
}
```

---

#### 6.2.4 Edit Barang

| Field        | Detail                                  |
|--------------|-----------------------------------------|
| **Endpoint** | `PUT /api/v1/admin/barang/{id_barang}`  |
| **Auth**     | Cookie (httpOnly)                       |
| **Client**   | Next.js (Admin)                         |

**Request Body:** *(sama seperti Tambah Barang)*

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Barang berhasil diperbarui"
}
```

---

#### 6.2.5 Hapus Barang

| Field        | Detail                                     |
|--------------|--------------------------------------------|
| **Endpoint** | `DELETE /api/v1/admin/barang/{id_barang}`  |
| **Auth**     | Cookie (httpOnly)                          |
| **Client**   | Next.js (Admin)                            |

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Barang berhasil dihapus"
}
```

---

#### 6.2.6 Tambah Diskon Barang

| Field        | Detail                                          |
|--------------|-------------------------------------------------|
| **Endpoint** | `POST /api/v1/admin/barang/{id_barang}/diskon`  |
| **Auth**     | Cookie (httpOnly)                               |
| **Client**   | Next.js (Admin)                                 |

**Request Body:**
```json
{
  "nama_diskon": "Promo Lebaran",
  "besar_diskon": 15,
  "tgl_mulai": "2026-03-01",
  "tgl_selesai": "2026-03-31"
}
```

**Response Success — 201 Created:**
```json
{
  "status": "success",
  "message": "Diskon berhasil ditambahkan",
  "data": {
    "id_diskon": 3,
    "nama_diskon": "Promo Lebaran",
    "besar_diskon": 15
  }
}
```

---

### 6.3 Manajemen Karyawan

#### 6.3.1 Daftar Semua Karyawan

| Field        | Detail                        |
|--------------|-------------------------------|
| **Endpoint** | `GET /api/v1/admin/karyawan`  |
| **Auth**     | Cookie (httpOnly)             |
| **Client**   | Next.js (Admin)               |

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Daftar karyawan berhasil diambil",
  "data": [
    {
      "id_user": 5,
      "nama_lengkap": "Budi Santoso",
      "email": "budi@mantra.com",
      "role": "kasir"
    }
  ]
}
```

---

#### 6.3.2 Manajemen Kasir

**Daftar Kasir — `GET /api/v1/admin/karyawan/kasir`**

Query Parameters: `?search=string`

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Daftar kasir berhasil diambil",
  "data": [
    {
      "id_kasir": 1,
      "nama_lengkap": "Budi Santoso",
      "foto": "https://api.mantra.com/storage/kasir/budi.jpg"
    }
  ]
}
```

---

**Tambah Kasir — `POST /api/v1/admin/karyawan/kasir`**

**Request Body (multipart/form-data):**
```
username      : string
email         : string
password      : string
nama_lengkap  : string
no_telp       : string
alamat        : string
tanggal_lahir : date (YYYY-MM-DD)
shift         : string (Pagi | Siang | Malam)
foto          : file (opsional)
```

**Response Success — 201 Created:**
```json
{
  "status": "success",
  "message": "Kasir berhasil ditambahkan",
  "data": {
    "id_kasir": 5,
    "nama_lengkap": "Budi Santoso"
  }
}
```

---

**Detail Kasir — `GET /api/v1/admin/karyawan/kasir/{id_kasir}`**

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Detail kasir berhasil diambil",
  "data": {
    "id_kasir": 1,
    "nama_lengkap": "Budi Santoso",
    "email": "budi@mantra.com",
    "no_telp": "081234567890",
    "alamat": "Jl. Mawar No. 5",
    "tanggal_lahir": "1995-03-15",
    "shift": "Pagi",
    "foto": "https://api.mantra.com/storage/kasir/budi.jpg"
  }
}
```

---

**Edit Kasir — `PUT /api/v1/admin/karyawan/kasir/{id_kasir}`**

Request Body: *(sama seperti Tambah Kasir, semua field opsional kecuali yang diubah)*

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Data kasir berhasil diperbarui"
}
```

---

**Hapus Kasir — `DELETE /api/v1/admin/karyawan/kasir/{id_kasir}`**

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Kasir berhasil dihapus"
}
```

---

#### 6.3.3 Manajemen Kurir

Pola endpoint identik dengan Kasir, ganti prefix `kasir` → `kurir`:

| Method   | Endpoint                                    | Deskripsi     |
|----------|---------------------------------------------|---------------|
| `GET`    | `/api/v1/admin/karyawan/kurir`              | Daftar kurir  |
| `POST`   | `/api/v1/admin/karyawan/kurir`              | Tambah kurir  |
| `GET`    | `/api/v1/admin/karyawan/kurir/{id_kurir}`   | Detail kurir  |
| `PUT`    | `/api/v1/admin/karyawan/kurir/{id_kurir}`   | Edit kurir    |
| `DELETE` | `/api/v1/admin/karyawan/kurir/{id_kurir}`   | Hapus kurir   |

---

### 6.4 Notifikasi Admin

| Field        | Detail                         |
|--------------|--------------------------------|
| **Endpoint** | `GET /api/v1/admin/notifikasi` |
| **Auth**     | Cookie (httpOnly)              |
| **Client**   | Next.js (Admin)                |

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Notifikasi admin berhasil diambil",
  "data": [
    {
      "id_notifikasi": 1,
      "id_barang": 1,
      "nama_barang": "Laptop Gaming X",
      "varian": "16GB RAM",
      "stok_saat_ini": 3,
      "batas_minimum": 5,
      "pesan": "Stok Laptop Gaming X (16GB RAM) hampir habis",
      "created_at": "2026-05-09T08:00:00Z"
    }
  ]
}
```

---

### 6.5 Profil Admin

#### 6.5.1 Tampil Profil

| Field        | Detail                     |
|--------------|----------------------------|
| **Endpoint** | `GET /api/v1/admin/profil` |
| **Auth**     | Cookie (httpOnly)          |
| **Client**   | Next.js (Admin)            |

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Data profil berhasil diambil",
  "data": {
    "nama_lengkap": "Admin Mantra",
    "username": "admin_mantra",
    "foto": "https://api.mantra.com/storage/admin/admin.jpg"
  }
}
```

---

#### 6.5.2 Edit Profil Admin

| Field        | Detail                     |
|--------------|----------------------------|
| **Endpoint** | `PUT /api/v1/admin/profil` |
| **Auth**     | Cookie (httpOnly)          |
| **Client**   | Next.js (Admin)            |

**Request Body:**
```json
{
  "nama_lengkap": "Admin Mantra",
  "username": "admin_mantra_baru"
}
```

**Response Success — 200 OK:**
```json
{
  "status": "success",
  "message": "Profil admin berhasil diperbarui",
  "data": {
    "nama_lengkap": "Admin Mantra",
    "username": "admin_mantra_baru"
  }
}
```

---

## 7. KURIR ENDPOINTS — PLACEHOLDER

> 🚧 **Section ini belum final.**
> Menunggu keputusan provider ekspedisi dan alur kurir internal.
> Akan diisi pada iterasi berikutnya menggunakan Template B & Template A.
>
> **Yang sudah diketahui:**
> - Ada 2 jenis kurir: **Internal** (karyawan toko, Flutter) dan **Eksternal** (ekspedisi pihak ketiga)
> - Minimal endpoint yang dibutuhkan nanti: update lokasi GPS, lihat pesanan yang di-assign, konfirmasi selesai kirim
>
> **Cara mengisi section ini saat sudah siap:**
> 1. Isi Template B (Fitur Baru) untuk mendefinisikan scope fitur kurir
> 2. Buat endpoint per endpoint menggunakan Template A
> 3. Hapus placeholder ini

---

## 8. GLOBAL ERROR REFERENCE

Semua response error mengikuti struktur:
```json
{
  "status": "error",
  "message": "Pesan human-readable untuk ditampilkan di UI",
  "error": {
    "code": "KODE_ERROR",
    "detail": "Detail teknis untuk debugging"
  }
}
```

### HTTP Status Code Reference

| Status | Nama                   | Kapan Digunakan                                                  |
|--------|------------------------|------------------------------------------------------------------|
| `200`  | OK                     | Request berhasil (GET, PUT, PATCH, DELETE)                       |
| `201`  | Created                | Data berhasil dibuat (POST yang menghasilkan resource baru)      |
| `400`  | Bad Request            | Logika bisnis gagal: stok tidak cukup, uang kurang, enum salah  |
| `401`  | Unauthorized           | Token tidak ada, invalid, atau expired                          |
| `403`  | Forbidden              | Token valid tapi role tidak punya akses, atau bukan data miliknya|
| `404`  | Not Found              | Resource tidak ditemukan berdasarkan ID                         |
| `409`  | Conflict               | Data duplikat (username/email sudah ada)                        |
| `422`  | Unprocessable Entity   | Validasi input gagal (format salah, field kosong, dll)          |
| `429`  | Too Many Requests      | Rate limit tercapai                                             |
| `500`  | Internal Server Error  | Error tak terduga di server atau database                       |
| `502`  | Bad Gateway            | Upstream service gagal (Midtrans, Maps API)                     |
| `503`  | Service Unavailable    | GPS kurir tidak tersedia / server maintenance                   |

### Kapan 400 vs 422?
- **400** → Format request valid, tapi logika bisnis gagal. Contoh: stok habis, uang kurang, password lama salah
- **422** → Input tidak lolos validasi. Contoh: email tidak valid, field wajib kosong, password terlalu pendek

### Kapan 401 vs 403?
- **401** → Tidak ada token / token expired / token salah format
- **403** → Token valid, tapi user tidak punya hak: role salah, atau bukan data miliknya

---

## 9. CATATAN TEKNIS

### Golang (Backend)
- Semua nilai uang: `int64` di Golang, `BIGINT` di PostgreSQL
- Timestamps: selalu kirim dalam ISO 8601 UTC (`2026-05-09T10:00:00Z`)
- Password: hash dengan `bcrypt`, cost factor 12
- JWT: library `golang-jwt/jwt`, access token expire 15 menit
- Refresh token: simpan di tabel `refresh_token`, expire 7 hari
- ID di URL: pertimbangkan UUID untuk resource sensitif (pesanan, pembayaran)
- File upload: simpan path relatif di DB, kirim URL absolut di response

### Flutter (Mobile — Customer & Kasir)
- Simpan `access_token` dan `refresh_token` di `flutter_secure_storage`
- Gunakan Dio interceptor: jika response `401` → auto-call refresh token → jika gagal → redirect login
- Gunakan kode (`kode`) bukan label string untuk logika kondisi di UI
- Format currency: `NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ')`
- Midtrans: backend kirim `token`, Flutter tampilkan UI via Midtrans Flutter SDK

### Next.js (Admin Web)
- Semua request wajib menggunakan `credentials: 'include'` (fetch) atau `withCredentials: true` (axios)
- Token tersimpan di httpOnly Cookie — tidak bisa diakses JavaScript, tidak perlu diurus manual
- Jika response `401` atau `403`: redirect otomatis ke halaman login, clear user state
- Server Actions di Next.js: cookie otomatis diteruskan, tidak perlu config tambahan
- CORS: Golang backend wajib allow origin domain Next.js dengan `AllowCredentials: true`
- Form upload barang: gunakan `FormData` dengan `multipart/form-data`
- Gunakan kode (`kode`) bukan label untuk logika kondisional di UI

### Midtrans Integration
- Backend Golang buat Snap transaction → dapat `snap_token`
- Kirim `snap_token` ke Flutter / Next.js
- Flutter: tampilkan via `midtrans_snap` package
- Next.js: tampilkan via Midtrans Snap.js embed
- Midtrans webhook → endpoint backend untuk update `status_transaksi` di tabel `pembayaran`
- Selalu verifikasi webhook signature sebelum update status