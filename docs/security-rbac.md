# MANTRA — Implementasi Keamanan & RBAC
**Version:** 1.0.0
**Last Updated:** 2026-05-09
**Stack:** Golang (Backend) · PostgreSQL · Flutter (Mobile) · Next.js (Web Admin)

---

## DAFTAR ISI

1. [Arsitektur Keamanan Overview](#1-arsitektur-keamanan-overview)
2. [JWT Structure & Token Lifecycle](#2-jwt-structure--token-lifecycle)
3. [Autentikasi per Client](#3-autentikasi-per-client)
4. [Role & Permission Matrix](#4-role--permission-matrix)
5. [Middleware Architecture (Golang)](#5-middleware-architecture-golang)
6. [ID Obfuscation Strategy](#6-id-obfuscation-strategy)
7. [Password & Security Policy](#7-password--security-policy)
8. [CORS Policy](#8-cors-policy)
9. [Rate Limiting](#9-rate-limiting)
10. [Flutter Security Checklist](#10-flutter-security-checklist)
11. [Next.js Security Checklist](#11-nextjs-security-checklist)

---

## 1. ARSITEKTUR KEAMANAN OVERVIEW

```
Request masuk
     │
     ▼
┌─────────────────┐
│  Rate Limiter   │ ← Tolak jika terlalu banyak request (per IP)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  CORS Check     │ ← Hanya relevan untuk Next.js Web, Flutter tidak butuh ini
└────────┬────────┘
         │
         ▼
┌──────────────────┐
│  Auth Middleware │ ← Verifikasi JWT dari Bearer header (Flutter)
│                  │   atau httpOnly Cookie (Next.js)
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│  Role Middleware │ ← Cek role dari JWT claims, tolak jika tidak sesuai
└────────┬─────────┘
         │
         ▼
┌─────────────────────┐
│ Ownership Middleware│ ← Cek kepemilikan data (hanya untuk resource personal)
└────────┬────────────┘
         │
         ▼
┌─────────────────┐
│  Handler/Logic  │ ← Proses request, query DB, return response
└─────────────────┘
```

---

## 2. JWT STRUCTURE & TOKEN LIFECYCLE

### 2.1 JWT Claims Payload

```json
{
  "user_id": 123,
  "role": "kasir",
  "iat": 1746691200,
  "exp": 1746692100
}
```

> `store_id` **tidak digunakan** karena MANTRA adalah single-tenant.
> Satu instalasi = satu toko. Tidak ada multi-tenant.

| Field     | Tipe      | Keterangan                                    |
|-----------|-----------|-----------------------------------------------|
| `user_id` | integer   | ID dari tabel `user`                          |
| `role`    | string    | `customer` / `kasir` / `admin` / `kurir`      |
| `iat`     | timestamp | Waktu token dibuat (Unix timestamp)           |
| `exp`     | timestamp | Waktu token expired (Unix timestamp)          |

### 2.2 Token Strategy

| Tipe Token    | Expire   | Disimpan di (Flutter)         | Disimpan di (Next.js)    | Cara Kirim             |
|---------------|----------|-------------------------------|--------------------------|------------------------|
| Access Token  | 15 menit | `flutter_secure_storage`      | httpOnly Cookie          | Bearer header / Cookie |
| Refresh Token | 7 hari   | `flutter_secure_storage`      | httpOnly Cookie          | Body / Cookie otomatis |

### 2.3 Token Lifecycle Flow

```
LOGIN:
Flutter  → POST /login → response body berisi access_token + refresh_token
Next.js  → POST /login → server set Set-Cookie header, body hanya berisi data user

PENGGUNAAN:
Flutter  → setiap request: Authorization: Bearer <access_token>
Next.js  → setiap request: browser kirim cookie otomatis

ACCESS TOKEN EXPIRED (401):
Flutter  → Dio interceptor tangkap 401
         → POST /auth/refresh dengan { refresh_token } di body
         → dapat access_token baru → retry request
         → jika refresh juga 401 → hapus token → redirect login

Next.js  → Axios interceptor tangkap 401
         → POST /auth/refresh (browser kirim cookie refresh otomatis)
         → server set cookie access_token baru → retry request
         → jika refresh juga 401 → clear state → redirect login

LOGOUT:
Flutter  → POST /logout dengan refresh_token di body
         → server revoke refresh_token di DB (set revoked_at)
         → Flutter hapus semua token dari secure storage

Next.js  → POST /logout (browser kirim cookie otomatis)
         → server revoke refresh_token di DB + clear cookie
         → Next.js clear user state → redirect login
```

### 2.4 Token Blacklist (Revocation)

Access token yang sudah dikeluarkan tidak bisa di-blacklist karena stateless. Expire 15 menit dianggap acceptable. Yang di-revoke adalah **refresh token**:

```sql
-- Saat logout: revoke refresh token
UPDATE refresh_token
SET revoked_at = NOW()
WHERE token = $1 AND id_user = $2;

-- Saat validasi refresh: cek apakah masih valid
SELECT * FROM refresh_token
WHERE token = $1
  AND expires_at > NOW()
  AND revoked_at IS NULL;
```

### 2.5 Implementasi Golang

```go
// Struct JWT Claims
type JWTClaims struct {
    UserID int64  `json:"user_id"`
    Role   string `json:"role"`
    jwt.RegisteredClaims
}

// Generate Access Token (15 menit)
func GenerateAccessToken(userID int64, role string) (string, error) {
    claims := JWTClaims{
        UserID: userID,
        Role:   role,
        RegisteredClaims: jwt.RegisteredClaims{
            ExpiresAt: jwt.NewNumericDate(time.Now().Add(15 * time.Minute)),
            IssuedAt:  jwt.NewNumericDate(time.Now()),
        },
    }
    token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
    return token.SignedString([]byte(os.Getenv("JWT_SECRET")))
}

// Generate Refresh Token (7 hari)
func GenerateRefreshToken(userID int64, role string) (string, error) {
    claims := JWTClaims{
        UserID: userID,
        Role:   role,
        RegisteredClaims: jwt.RegisteredClaims{
            ExpiresAt: jwt.NewNumericDate(time.Now().Add(7 * 24 * time.Hour)),
            IssuedAt:  jwt.NewNumericDate(time.Now()),
        },
    }
    token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
    return token.SignedString([]byte(os.Getenv("JWT_REFRESH_SECRET")))
}
```

> **Penting:** Gunakan secret key yang berbeda untuk access token (`JWT_SECRET`) dan refresh token (`JWT_REFRESH_SECRET`). Simpan keduanya di environment variable, tidak pernah di-hardcode.

---

## 3. AUTENTIKASI PER CLIENT

### 3.1 Flutter — Bearer Token

Setiap request Flutter menyertakan token di header:
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

Golang middleware membaca header `Authorization`, strip prefix `Bearer `, lalu verifikasi signature.

### 3.2 Next.js — httpOnly Cookie

Server set cookie saat login:
```
Set-Cookie: access_token=<token>; HttpOnly; Secure; SameSite=Strict; Path=/; Max-Age=900
Set-Cookie: refresh_token=<token>; HttpOnly; Secure; SameSite=Strict; Path=/api/v1/auth/refresh; Max-Age=604800
```

**Kenapa `Path=/api/v1/auth/refresh` untuk refresh token?**
Agar refresh token hanya dikirim browser ke endpoint refresh saja, tidak ke semua endpoint. Ini membatasi exposure refresh token.

Golang middleware membaca token dari cookie `access_token`. Tidak ada token di response body.

### 3.3 Deteksi Sumber Token di Golang

```go
// Middleware baca token dari header (Flutter) atau cookie (Next.js)
func GetTokenFromRequest(c *gin.Context) (string, error) {
    // Coba dari Authorization header dulu (Flutter)
    authHeader := c.GetHeader("Authorization")
    if authHeader != "" && strings.HasPrefix(authHeader, "Bearer ") {
        return strings.TrimPrefix(authHeader, "Bearer "), nil
    }

    // Fallback ke cookie (Next.js)
    cookie, err := c.Cookie("access_token")
    if err == nil && cookie != "" {
        return cookie, nil
    }

    return "", errors.New("token tidak ditemukan di header maupun cookie")
}
```

---

## 4. ROLE & PERMISSION MATRIX

### 4.1 Tabel Akses Endpoint per Role

| Endpoint Group             | Customer | Kasir | Admin | Kurir        |
|----------------------------|----------|-------|-------|--------------|
| `POST /login`              | ✅       | ✅    | ✅    | ✅           |
| `POST /register`           | ✅       | ❌    | ❌    | ❌           |
| `POST /logout`             | ✅       | ✅    | ✅    | ✅           |
| `POST /auth/refresh`       | ✅       | ✅    | ✅    | ✅           |
| `PUT /change-password`     | ✅       | ✅    | ✅    | ✅           |
| `GET /scan/{kode}`         | ✅       | ✅    | ❌    | ❌           |
| `/api/v1/customer/*`       | ✅       | ❌    | ❌    | ❌           |
| `/api/v1/kasir/*`          | ❌       | ✅    | ❌    | ❌           |
| `/api/v1/admin/*`          | ❌       | ❌    | ✅    | ❌           |
| `/api/v1/kurir/*`          | ❌       | ❌    | ❌    | ✅ (roadmap) |

> ✅ = Diizinkan | ❌ = Forbidden (403 + kode `AUTH_002`)

### 4.2 Ownership Rules

Selain role check, resource personal wajib dicek kepemilikannya:

| Resource          | Aturan Kepemilikan                                               |
|-------------------|------------------------------------------------------------------|
| Keranjang         | `keranjang.id_customer` harus milik `user_id` di JWT            |
| Pesanan Customer  | `pesanan.id_customer` harus milik `user_id` di JWT              |
| Alamat            | `alamat.id_customer` harus milik `user_id` di JWT               |
| Profil Customer   | `customer.id_user` harus sama dengan `user_id` di JWT           |

**Pola query ownership di Golang:**
```go
// Contoh: cek pesanan milik customer yang login
var count int
err := db.QueryRow(`
    SELECT COUNT(*)
    FROM pesanan p
    JOIN customer c ON c.id_customer = p.id_customer
    WHERE p.id_pesanan = $1 AND c.id_user = $2
`, idPesanan, userID).Scan(&count)

if count == 0 {
    // Return 403, bukan 404 — agar tidak bocorkan bahwa ID ada
    c.JSON(403, errorResponse("AUTH_002", "..."))
    return
}
```

> **Kenapa 403 bukan 404?** Mengembalikan 404 saat resource ada tapi bukan miliknya bisa bocorkan informasi bahwa ID tersebut valid. Selalu return 403 untuk ownership violation.

---

## 5. MIDDLEWARE ARCHITECTURE (GOLANG)

### 5.1 Struktur Route Groups

```go
r := gin.Default()
r.Use(SecurityHeadersMiddleware())

api := r.Group("/api/v1")
api.Use(RateLimitMiddleware())

// ── Public routes (no auth) ──────────────────────────────────────
api.POST("/login", handlers.Login)
api.POST("/register", handlers.Register)
api.POST("/auth/refresh", handlers.RefreshToken)

// ── Authenticated routes (semua role) ────────────────────────────
auth := api.Group("/")
auth.Use(AuthMiddleware())
{
    auth.POST("/logout", handlers.Logout)
    auth.PUT("/change-password", handlers.ChangePassword)
    auth.GET("/scan/:kode_barcode", handlers.ScanBarcode)
}

// ── Customer routes ───────────────────────────────────────────────
customer := api.Group("/customer")
customer.Use(AuthMiddleware(), RoleMiddleware("customer"))
{
    customer.GET("/promo", handlers.GetPromo)
    customer.GET("/kategori", handlers.GetKategori)
    customer.GET("/barang", handlers.GetBarang)
    customer.GET("/notifikasi", handlers.GetNotifikasiCustomer)
    customer.GET("/profil", handlers.GetProfilCustomer)
    customer.PUT("/akun", handlers.EditAkunCustomer)

    // Keranjang — tambah ownership check
    customer.POST("/keranjang", handlers.TambahKeranjang)
    customer.PATCH("/keranjang/:id_keranjang",
        KeranjangOwnershipMiddleware(),
        handlers.UpdateKeranjang,
    )
    customer.DELETE("/keranjang/:id_keranjang",
        KeranjangOwnershipMiddleware(),
        handlers.HapusKeranjang,
    )

    // Pesanan
    customer.GET("/pesanan", handlers.GetPesananCustomer)
    customer.POST("/pesanan/checkout", handlers.Checkout)
    customer.PATCH("/pesanan/:id_pesanan/batal",
        PesananOwnershipMiddleware(),
        handlers.BatalPesanan,
    )
    customer.GET("/pesanan/:id_pesanan",
        PesananOwnershipMiddleware(),
        handlers.DetailPesanan,
    )
    customer.GET("/pesanan/:id_pesanan/lacak",
        PesananOwnershipMiddleware(),
        handlers.LacakPesanan,
    )

    // Alamat
    customer.GET("/alamat", handlers.GetAlamat)
    customer.POST("/alamat", handlers.TambahAlamat)
    customer.PUT("/alamat/:id_alamat",
        AlamatOwnershipMiddleware(),
        handlers.EditAlamat,
    )
    customer.DELETE("/alamat/:id_alamat",
        AlamatOwnershipMiddleware(),
        handlers.HapusAlamat,
    )
}

// ── Kasir routes ──────────────────────────────────────────────────
kasir := api.Group("/kasir")
kasir.Use(AuthMiddleware(), RoleMiddleware("kasir"))
{
    kasir.GET("/dashboard", handlers.KasirDashboard)
    kasir.GET("/laporan", handlers.GetLaporan)
    kasir.GET("/laporan/produk/:id_produk", handlers.DetailProdukLaporan)
    kasir.GET("/laporan/produk/:id_produk/:id_pesanan", handlers.DetailPesananLaporan)
    kasir.GET("/pesanan", handlers.GetPesananKasir)
    kasir.GET("/pesanan/:id_order", handlers.DetailPesananKasir)
    kasir.POST("/transaksi/produk", handlers.TambahProdukTransaksi)
    kasir.PATCH("/transaksi/item/update", handlers.UpdateQuantityItem)
    kasir.GET("/transaksi/checkout", handlers.RingkasanCheckout)
    kasir.POST("/transaksi/bayar/tunai", handlers.BayarTunai)
    kasir.POST("/transaksi/bayar/non-tunai", handlers.BayarNonTunai)
    kasir.GET("/profil", handlers.GetProfilKasir)
    kasir.GET("/notifikasi", handlers.GetNotifikasiKasir)
}

// ── Admin routes ──────────────────────────────────────────────────
admin := api.Group("/admin")
admin.Use(AuthMiddleware(), RoleMiddleware("admin"))
{
    admin.GET("/dashboard", handlers.AdminDashboard)
    admin.GET("/barang", handlers.GetBarangAdmin)
    admin.POST("/barang", handlers.TambahBarang)
    admin.GET("/barang/:id_barang", handlers.DetailBarang)
    admin.PUT("/barang/:id_barang", handlers.EditBarang)
    admin.DELETE("/barang/:id_barang", handlers.HapusBarang)
    admin.POST("/barang/:id_barang/diskon", handlers.TambahDiskon)
    admin.GET("/karyawan", handlers.GetSemuaKaryawan)
    admin.GET("/karyawan/kasir", handlers.GetSemuaKasir)
    admin.POST("/karyawan/kasir", handlers.TambahKasir)
    admin.GET("/karyawan/kasir/:id_kasir", handlers.DetailKasir)
    admin.PUT("/karyawan/kasir/:id_kasir", handlers.EditKasir)
    admin.DELETE("/karyawan/kasir/:id_kasir", handlers.HapusKasir)
    admin.GET("/karyawan/kurir", handlers.GetSemuaKurir)
    admin.POST("/karyawan/kurir", handlers.TambahKurir)
    admin.GET("/karyawan/kurir/:id_kurir", handlers.DetailKurir)
    admin.PUT("/karyawan/kurir/:id_kurir", handlers.EditKurir)
    admin.DELETE("/karyawan/kurir/:id_kurir", handlers.HapusKurir)
    admin.GET("/notifikasi", handlers.GetNotifikasiAdmin)
    admin.GET("/profil", handlers.GetProfilAdmin)
    admin.PUT("/profil", handlers.EditProfilAdmin)
}
```

### 5.2 AuthMiddleware

```go
func AuthMiddleware() gin.HandlerFunc {
    return func(c *gin.Context) {
        tokenString, err := GetTokenFromRequest(c)
        if err != nil {
            c.JSON(401, gin.H{
                "status":  "error",
                "message": "Token tidak valid atau sudah expired",
                "error": gin.H{
                    "code":   "AUTH_001",
                    "detail": err.Error(),
                },
            })
            c.Abort()
            return
        }

        claims, err := ValidateToken(tokenString)
        if err != nil {
            c.JSON(401, gin.H{
                "status":  "error",
                "message": "Token tidak valid atau sudah expired",
                "error": gin.H{
                    "code":   "AUTH_001",
                    "detail": err.Error(),
                },
            })
            c.Abort()
            return
        }

        // Simpan ke context untuk dipakai handler & middleware berikutnya
        c.Set("user_id", claims.UserID)
        c.Set("role", claims.Role)
        c.Next()
    }
}
```

### 5.3 RoleMiddleware

```go
func RoleMiddleware(allowedRoles ...string) gin.HandlerFunc {
    return func(c *gin.Context) {
        role, exists := c.Get("role")
        if !exists {
            c.JSON(403, gin.H{
                "status":  "error",
                "message": "Anda tidak memiliki akses ke resource ini",
                "error": gin.H{
                    "code":   "AUTH_002",
                    "detail": "Role tidak ditemukan dalam token",
                },
            })
            c.Abort()
            return
        }

        roleStr := role.(string)
        for _, allowed := range allowedRoles {
            if roleStr == allowed {
                c.Next()
                return
            }
        }

        c.JSON(403, gin.H{
            "status":  "error",
            "message": "Anda tidak memiliki akses ke resource ini",
            "error": gin.H{
                "code":   "AUTH_002",
                "detail": fmt.Sprintf("Role '%s' tidak diizinkan mengakses endpoint ini", roleStr),
            },
        })
        c.Abort()
    }
}
```

### 5.4 OwnershipMiddleware (Contoh: Keranjang)

```go
func KeranjangOwnershipMiddleware() gin.HandlerFunc {
    return func(c *gin.Context) {
        userID := c.GetInt64("user_id")
        idKeranjang := c.Param("id_keranjang")

        var count int
        err := db.QueryRow(`
            SELECT COUNT(*)
            FROM keranjang k
            JOIN customer cu ON cu.id_customer = k.id_customer
            WHERE k.id_keranjang = $1 AND cu.id_user = $2
        `, idKeranjang, userID).Scan(&count)

        if err != nil || count == 0 {
            // Return 403, bukan 404, agar tidak bocorkan keberadaan ID
            c.JSON(403, gin.H{
                "status":  "error",
                "message": "Anda tidak memiliki akses untuk mengubah item ini",
                "error": gin.H{
                    "code":   "AUTH_002",
                    "detail": "Keranjang bukan milik user yang sedang login",
                },
            })
            c.Abort()
            return
        }

        c.Next()
    }
}
```

### 5.5 Security Headers Middleware

```go
func SecurityHeadersMiddleware() gin.HandlerFunc {
    return func(c *gin.Context) {
        c.Header("X-Content-Type-Options", "nosniff")
        c.Header("X-Frame-Options", "DENY")
        c.Header("X-XSS-Protection", "1; mode=block")
        c.Header("Referrer-Policy", "strict-origin-when-cross-origin")
        c.Next()
    }
}
```

---

## 6. ID OBFUSCATION STRATEGY

### 6.1 Masalah

Integer ID yang diekspos ke URL memungkinkan **ID enumeration attack**:
```
GET /api/v1/customer/pesanan/1042  →  tebak 1043, 1044, dst
```

Penyerang bisa mengintip data orang lain jika ownership check lemah, atau sekadar menghitung jumlah transaksi toko.

### 6.2 Strategi

Gunakan dua kolom ID di tabel sensitif:
- **Internal ID** (`int`) → tetap digunakan untuk JOIN antar tabel, index, performa
- **Public ID** (`UUID`) → diekspos ke URL dan response JSON

### 6.3 Tabel yang Perlu Public ID

| Tabel        | Alasan                                                        |
|--------------|---------------------------------------------------------------|
| `pesanan`    | Nomor pesanan diekspos ke customer di URL dan invoice         |
| `pembayaran` | ID pembayaran dikirim ke Midtrans dan diterima via webhook    |
| `pengantaran`| Diekspos ke customer saat fitur lacak                         |

> Tabel seperti `barang`, `kategori`, `kasir` tidak terlalu sensitif karena tidak menyimpan data personal.

### 6.4 Implementasi PostgreSQL

```sql
-- Aktifkan ekstensi UUID (sekali saja per database)
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Tambah public_id ke tabel pesanan
ALTER TABLE pesanan
ADD COLUMN public_id UUID DEFAULT gen_random_uuid() UNIQUE NOT NULL;

-- Index agar query by public_id tetap cepat
CREATE INDEX idx_pesanan_public_id ON pesanan(public_id);

-- Lakukan hal yang sama untuk tabel pembayaran dan pengantaran
```

### 6.5 Contoh Perbedaan URL

```
❌ Tidak aman:
GET /api/v1/customer/pesanan/1042
→ mudah ditebak: coba 1041, 1043, 1044...

✅ Aman:
GET /api/v1/customer/pesanan/a1b2c3d4-e5f6-7890-abcd-ef1234567890
→ tidak bisa ditebak, aman
```

### 6.6 Query di Golang

```go
func GetDetailPesanan(c *gin.Context) {
    publicID := c.Param("id_pesanan") // UUID dari URL
    userID := c.GetInt64("user_id")   // Dari JWT claims

    var pesanan Pesanan
    // Gunakan public_id + ownership check dalam satu query
    err := db.QueryRow(`
        SELECT p.*
        FROM pesanan p
        JOIN customer cu ON cu.id_customer = p.id_customer
        WHERE p.public_id = $1 AND cu.id_user = $2
    `, publicID, userID).Scan(&pesanan)

    if err != nil {
        c.JSON(403, errorResponse("AUTH_002", "Pesanan tidak ditemukan atau bukan milik Anda"))
        return
    }
    // lanjut proses...
}
```

---

## 7. PASSWORD & SECURITY POLICY

### 7.1 Password Rules

| Aturan                | Nilai                    |
|-----------------------|--------------------------|
| Panjang minimum       | 8 karakter               |
| Hashing algorithm     | bcrypt                   |
| bcrypt cost factor    | 12                       |
| Password lama         | Wajib diverifikasi saat change password |

### 7.2 Implementasi Bcrypt di Golang

```go
import "golang.org/x/crypto/bcrypt"

// Hash password saat register / change password
func HashPassword(password string) (string, error) {
    bytes, err := bcrypt.GenerateFromPassword([]byte(password), 12)
    return string(bytes), err
}

// Verifikasi password saat login / change password
func CheckPassword(password, hash string) bool {
    err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
    return err == nil
}
```

### 7.3 Environment Variables yang Wajib Ada

```env
JWT_SECRET=<random-string-minimal-32-karakter>
JWT_REFRESH_SECRET=<random-string-berbeda-minimal-32-karakter>
DB_URL=<connection-string-postgresql>
```

> Jangan pernah commit file `.env` ke repository. Gunakan `.env.example` untuk template.

---

## 8. CORS POLICY

CORS hanya relevan untuk **Next.js Web**. Flutter tidak terpengaruh CORS karena bukan browser.

### 8.1 Konfigurasi di Golang

```go
import "github.com/gin-contrib/cors"

corsConfig := cors.Config{
    // Ganti dengan domain Next.js yang sebenarnya
    AllowOrigins:     []string{"https://admin.mantra.com"},
    AllowMethods:     []string{"GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"},
    AllowHeaders:     []string{"Origin", "Content-Type", "Authorization"},
    ExposeHeaders:    []string{"Content-Length"},
    AllowCredentials: true,      // WAJIB true agar cookie dikirim bersama request
    MaxAge:           12 * time.Hour,
}

r.Use(cors.New(corsConfig))
```

> **Penting:** Jika `AllowCredentials: true`, maka `AllowOrigins` **tidak boleh** `["*"]` (wildcard). Harus domain spesifik. Browser akan menolak request jika aturan ini dilanggar.

### 8.2 Next.js — Konfigurasi Fetch / Axios

```javascript
// Menggunakan fetch native
const response = await fetch('https://api.mantra.com/api/v1/admin/dashboard', {
    credentials: 'include', // WAJIB agar browser kirim cookie
});

// Menggunakan axios — buat instance sekali, pakai di seluruh app
import axios from 'axios';

const api = axios.create({
    baseURL: 'https://api.mantra.com/api/v1',
    withCredentials: true, // WAJIB
});

export default api;
```

### 8.3 Next.js Server Actions

Jika menggunakan Next.js Server Actions atau Route Handlers (App Router), cookie diteruskan otomatis dari browser ke server Next.js. Untuk kemudian diteruskan ke Golang backend:

```javascript
// app/actions/dashboard.js
import { cookies } from 'next/headers';

export async function getDashboardData() {
    const cookieStore = cookies();
    const token = cookieStore.get('access_token');

    const res = await fetch('https://api.mantra.com/api/v1/admin/dashboard', {
        headers: {
            // Teruskan cookie ke Golang backend dari server Next.js
            Cookie: `access_token=${token?.value}`,
        },
    });

    return res.json();
}
```

---

## 9. RATE LIMITING

### 9.1 Limit per Endpoint

| Endpoint                  | Limit          | Alasan                                  |
|---------------------------|----------------|-----------------------------------------|
| `POST /login`             | 5 req / menit  | Mencegah brute force password           |
| `POST /register`          | 3 req / menit  | Mencegah spam registrasi                |
| `POST /auth/refresh`      | 10 req / menit | Mencegah token abuse                    |
| Semua endpoint lainnya    | 60 req / menit | General rate limiting                   |

### 9.2 Response Rate Limit — 429

```json
{
  "status": "error",
  "message": "Terlalu banyak permintaan, coba lagi nanti",
  "error": {
    "code": "RATE_001",
    "detail": "Rate limit exceeded. Retry after 60 seconds"
  }
}
```

### 9.3 Implementasi di Golang

```go
import (
    "sync"
    "golang.org/x/time/rate"
)

// Rate limiter per IP address
var (
    mu       sync.Mutex
    limiters = make(map[string]*rate.Limiter)
)

func getLimiter(ip string, r rate.Limit, b int) *rate.Limiter {
    mu.Lock()
    defer mu.Unlock()

    if lim, exists := limiters[ip]; exists {
        return lim
    }

    lim := rate.NewLimiter(r, b)
    limiters[ip] = lim
    return lim
}

// Middleware untuk endpoint login (5 req/menit)
func LoginRateLimitMiddleware() gin.HandlerFunc {
    return func(c *gin.Context) {
        ip := c.ClientIP()
        lim := getLimiter(ip, rate.Every(time.Minute/5), 5)

        if !lim.Allow() {
            c.JSON(429, gin.H{
                "status":  "error",
                "message": "Terlalu banyak permintaan, coba lagi nanti",
                "error": gin.H{
                    "code":   "RATE_001",
                    "detail": "Rate limit exceeded",
                },
            })
            c.Abort()
            return
        }
        c.Next()
    }
}
```

---

## 10. FLUTTER SECURITY CHECKLIST

### Token Storage
- [ ] Gunakan `flutter_secure_storage` untuk simpan `access_token` dan `refresh_token`
- [ ] **Jangan** gunakan `SharedPreferences` — tidak terenkripsi
- [ ] Hapus semua token saat logout: `await storage.deleteAll()`

### Dio Interceptor (Auto Refresh)

```dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final FlutterSecureStorage storage;

  AuthInterceptor(this.dio, this.storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await storage.read(key: 'access_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Coba refresh token
      try {
        final refreshToken = await storage.read(key: 'refresh_token');
        final response = await dio.post('/auth/refresh', data: {
          'refresh_token': refreshToken,
        });

        // Simpan access token baru
        final newToken = response.data['data']['access_token'];
        await storage.write(key: 'access_token', value: newToken);

        // Retry request asal dengan token baru
        err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
        final retryResponse = await dio.fetch(err.requestOptions);
        return handler.resolve(retryResponse);

      } catch (_) {
        // Refresh gagal → logout paksa
        await storage.deleteAll();
        // Redirect ke halaman login via navigasi global
        navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (_) => false);
      }
    }
    handler.next(err);
  }
}
```

### UI Security
- [ ] Gunakan field `kode` (bukan `label`) untuk logika kondisional di UI
- [ ] Jangan tampilkan field `error.detail` ke user — hanya tampilkan `message`
- [ ] Role-based UI: render widget/halaman berdasarkan role di state management
- [ ] Jangan simpan data sensitif di state yang bisa diinspeksi (gunakan secure storage)

---

## 11. NEXT.JS SECURITY CHECKLIST

### Cookie & Token
- [ ] Semua request menggunakan `credentials: 'include'` (fetch) atau `withCredentials: true` (axios)
- [ ] Token **tidak pernah** disimpan di `localStorage` atau `sessionStorage`
- [ ] Token tidak bisa diakses JavaScript karena `httpOnly` — ini by design, bukan bug

### Axios Interceptor (Auto Refresh & Redirect)

```javascript
// lib/api.js
import axios from 'axios';

const api = axios.create({
    baseURL: process.env.NEXT_PUBLIC_API_URL,
    withCredentials: true,
});

api.interceptors.response.use(
    (response) => response,
    async (error) => {
        const originalRequest = error.config;

        if (error.response?.status === 401 && !originalRequest._retry) {
            originalRequest._retry = true;

            try {
                // Refresh token — browser kirim cookie refresh otomatis
                await api.post('/auth/refresh');
                // Retry request asal
                return api(originalRequest);
            } catch {
                // Refresh gagal → clear state → redirect login
                clearUserState();
                window.location.href = '/login';
            }
        }

        if (error.response?.status === 403) {
            window.location.href = '/unauthorized';
        }

        return Promise.reject(error);
    }
);

export default api;
```

### Route Protection di Next.js (Middleware)

```javascript
// middleware.js (root project)
import { NextResponse } from 'next/server';

export function middleware(request) {
    const token = request.cookies.get('access_token');

    // Proteksi semua route /admin/*
    if (request.nextUrl.pathname.startsWith('/admin')) {
        if (!token) {
            return NextResponse.redirect(new URL('/login', request.url));
        }
    }

    return NextResponse.next();
}

export const config = {
    matcher: ['/admin/:path*'],
};
```

### UI & State Security
- [ ] Role-based rendering: tampilkan menu/halaman berdasarkan role dari response login
- [ ] Simpan role di state management (Zustand/Redux), **bukan** localStorage
- [ ] Jangan tampilkan field `error.detail` ke user — hanya tampilkan `message`
- [ ] Gunakan field `kode` (bukan `label`) untuk logika kondisional
- [ ] Form upload barang: gunakan `FormData`, set header `multipart/form-data`
