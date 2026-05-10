# MANTRA — Implementasi Keamanan & RBAC
**Version:** 1.0.0
**Last Updated:** 2026-05-08
**Stack:** Golang (Backend) · PostgreSQL · Flutter (Mobile) · React (Web Admin)

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
11. [React Web Security Checklist](#11-react-web-security-checklist)

---

## 1. ARSITEKTUR KEAMANAN OVERVIEW

```
Request masuk
     │
     ▼
┌─────────────────┐
│  Rate Limiter   │ ← Tolak jika terlalu banyak request
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  CORS Check     │ ← Hanya untuk React Web
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Auth Middleware│ ← Verifikasi JWT (Bearer atau Cookie)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Role Middleware│ ← Cek role dari JWT claims
└────────┬────────┘
         │
         ▼
┌─────────────────────┐
│ Ownership Middleware│ ← Cek data milik user yang login (jika perlu)
└────────┬────────────┘
         │
         ▼
┌─────────────────┐
│  Handler/Logic  │ ← Proses request
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

> `store_id` **tidak digunakan** karena MANTRA adalah single-tenant (satu instalasi = satu toko).

| Field     | Tipe      | Keterangan                           |
|-----------|-----------|--------------------------------------|
| `user_id` | integer   | ID dari tabel `user`                 |
| `role`    | string    | `customer` / `kasir` / `admin` / `kurir` |
| `iat`     | timestamp | Waktu token dibuat (Unix timestamp)  |
| `exp`     | timestamp | Waktu token expired (Unix timestamp) |

### 2.2 Token Strategy

| Tipe Token      | Expire     | Disimpan di                       | Cara Kirim             |
|-----------------|------------|-----------------------------------|------------------------|
| Access Token    | 15 menit   | Flutter: `flutter_secure_storage` | Header: `Bearer`       |
| Access Token    | 15 menit   | React: Memory / JS state          | Cookie: `httpOnly`     |
| Refresh Token   | 7 hari     | Flutter: `flutter_secure_storage` | Request body           |
| Refresh Token   | 7 hari     | React: `httpOnly Cookie`          | Cookie: otomatis       |

### 2.3 Refresh Token Flow

```
Flutter:
1. Access token expired → Axios/Dio intercept response 401
2. Kirim POST /api/v1/auth/refresh dengan { refresh_token: "..." } di body
3. Server validasi refresh token di tabel refresh_token
4. Jika valid → return access token baru
5. Jika tidak valid / expired → return 401 → Flutter hapus token → redirect login

React Web:
1. Access token expired → Axios intercept response 401
2. Browser otomatis kirim cookie refresh_token
3. Server validasi dari cookie
4. Jika valid → server set cookie access_token baru
5. Jika tidak valid → return 401 → React redirect ke halaman login
```

### 2.4 Logout Strategy (Token Blacklist)

Saat logout, refresh token direvoke di database:

```sql
UPDATE refresh_token
SET revoked_at = NOW()
WHERE token = $1 AND id_user = $2;
```

Access token yang sudah dikeluarkan tidak bisa di-blacklist (karena stateless), tapi karena expire hanya 15 menit, ini dianggap acceptable. Jika butuh immediate revocation, pertimbangkan Redis untuk blacklist access token di masa depan.

### 2.5 Implementasi Golang

```go
// Struct JWT Claims
type JWTClaims struct {
    UserID int64  `json:"user_id"`
    Role   string `json:"role"`
    jwt.RegisteredClaims
}

// Generate Access Token
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

// Generate Refresh Token
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

---

## 3. AUTENTIKASI PER CLIENT

### 3.1 Flutter (Bearer Token)

```
Header setiap request:
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

Golang middleware membaca token dari header `Authorization`, strip prefix `Bearer `, lalu verifikasi signature.

### 3.2 React Web (httpOnly Cookie)

```
Login response dari server:
Set-Cookie: access_token=<token>; HttpOnly; Secure; SameSite=Strict; Path=/; Max-Age=900
Set-Cookie: refresh_token=<token>; HttpOnly; Secure; SameSite=Strict; Path=/api/v1/auth/refresh; Max-Age=604800
```

Tidak ada token di response body untuk React. Browser menyimpan dan mengirim cookie secara otomatis.

Golang middleware membaca token dari cookie `access_token`.

### 3.3 Deteksi Client di Backend

Backend perlu tahu dari mana request berasal untuk menentukan cara baca token:

```go
func GetTokenFromRequest(c *gin.Context) (string, error) {
    // Coba dari header dulu (Flutter)
    authHeader := c.GetHeader("Authorization")
    if authHeader != "" && strings.HasPrefix(authHeader, "Bearer ") {
        return strings.TrimPrefix(authHeader, "Bearer "), nil
    }

    // Coba dari cookie (React Web)
    cookie, err := c.Cookie("access_token")
    if err == nil && cookie != "" {
        return cookie, nil
    }

    return "", errors.New("token tidak ditemukan")
}
```

---

## 4. ROLE & PERMISSION MATRIX

### 4.1 Tabel Permission

| Endpoint Group          | Customer | Kasir | Admin | Kurir  |
|-------------------------|----------|-------|-------|--------|
| `/api/v1/login`         | ✅       | ✅    | ✅    | ✅     |
| `/api/v1/register`      | ✅       | ❌    | ❌    | ❌     |
| `/api/v1/logout`        | ✅       | ✅    | ✅    | ✅     |
| `/api/v1/change-password`| ✅      | ✅    | ✅    | ✅     |
| `/api/v1/customer/*`    | ✅       | ❌    | ❌    | ❌     |
| `/api/v1/kasir/*`       | ❌       | ✅    | ❌    | ❌     |
| `/api/v1/admin/*`       | ❌       | ❌    | ✅    | ❌     |
| `/api/v1/kurir/*`       | ❌       | ❌    | ❌    | ✅     |
| `/api/v1/scan/*`        | ✅       | ✅    | ❌    | ❌     |

> ✅ = Diizinkan | ❌ = Forbidden (403)

### 4.2 Ownership Rules

Selain role check, beberapa endpoint juga butuh **ownership check** — memastikan user hanya bisa mengakses/mengubah data miliknya sendiri:

| Resource            | Ownership Rule                                                  |
|---------------------|-----------------------------------------------------------------|
| Keranjang           | `keranjang.id_customer` harus sama dengan `customer_id` di JWT  |
| Pesanan Customer    | `pesanan.id_customer` harus sama dengan `customer_id` di JWT    |
| Alamat              | `alamat.id_customer` harus sama dengan `customer_id` di JWT     |
| Profil Customer     | `customer.id_user` harus sama dengan `user_id` di JWT           |

---

## 5. MIDDLEWARE ARCHITECTURE (GOLANG)

### 5.1 Struktur Route Groups

```go
r := gin.Default()
api := r.Group("/api/v1")

// Public routes (no auth)
api.POST("/login", handlers.Login)
api.POST("/register", handlers.Register)
api.POST("/auth/refresh", handlers.RefreshToken)

// Authenticated routes (semua role)
auth := api.Group("/")
auth.Use(middleware.AuthMiddleware())
{
    auth.POST("/logout", handlers.Logout)
    auth.PUT("/change-password", handlers.ChangePassword)
    auth.GET("/scan/:kode_barcode", handlers.ScanBarcode)
}

// Customer routes
customer := api.Group("/customer")
customer.Use(middleware.AuthMiddleware(), middleware.RoleMiddleware("customer"))
{
    customer.GET("/promo", handlers.GetPromo)
    customer.GET("/barang", handlers.GetBarang)
    // ... dst
}

// Kasir routes
kasir := api.Group("/kasir")
kasir.Use(middleware.AuthMiddleware(), middleware.RoleMiddleware("kasir"))
{
    kasir.GET("/dashboard", handlers.KasirDashboard)
    // ... dst
}

// Admin routes
admin := api.Group("/admin")
admin.Use(middleware.AuthMiddleware(), middleware.RoleMiddleware("admin"))
{
    admin.GET("/dashboard", handlers.AdminDashboard)
    // ... dst
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

        // Simpan claims ke context untuk dipakai handler
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

        // Query: cek apakah keranjang ini milik customer yang login
        var idCustomer int64
        err := db.QueryRow(`
            SELECT k.id_customer
            FROM keranjang k
            JOIN customer cu ON cu.id_customer = k.id_customer
            WHERE k.id_keranjang = $1 AND cu.id_user = $2
        `, idKeranjang, userID).Scan(&idCustomer)

        if err != nil {
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

---

## 6. ID OBFUSCATION STRATEGY

### 6.1 Prinsip

Jangan ekspos integer primary key langsung di URL publik. Integer ID memungkinkan **ID enumeration attack** — penyerang bisa menebak data orang lain dengan increment ID (1, 2, 3, dst).

### 6.2 Strategi yang Digunakan

**Internal ID** (integer) tetap digunakan untuk relasi antar tabel di database karena lebih cepat untuk JOIN.

**Public ID** (UUID v4) ditambahkan sebagai kolom terpisah untuk diekspos ke URL.

### 6.3 Tabel yang Perlu Public ID

| Tabel       | Alasan                                                  |
|-------------|--------------------------------------------------------|
| `pesanan`   | Nomor pesanan diekspos ke customer di URL dan invoice  |
| `pembayaran`| ID pembayaran diekspos ke Midtrans                     |
| `pengantaran`| Diekspos ke customer saat lacak                       |

> Tabel seperti `barang`, `kategori`, `kasir` tidak terlalu sensitif — integer ID di URL masih aman karena data tidak bersifat personal.

### 6.4 Implementasi PostgreSQL

```sql
-- Tambah kolom public_id ke tabel pesanan
ALTER TABLE pesanan
ADD COLUMN public_id UUID DEFAULT gen_random_uuid() UNIQUE NOT NULL;

-- Tambah index agar query by public_id tetap cepat
CREATE INDEX idx_pesanan_public_id ON pesanan(public_id);
```

### 6.5 Contoh Perbedaan URL

```
❌ Tidak aman:  GET /api/v1/customer/pesanan/1042
                (mudah ditebak: 1043, 1044, dst)

✅ Aman:        GET /api/v1/customer/pesanan/a1b2c3d4-e5f6-7890-abcd-ef1234567890
                (tidak bisa ditebak)
```

### 6.6 Cara Query di Golang

```go
// Gunakan public_id dari URL, ambil internal ID di backend
func GetDetailPesanan(c *gin.Context) {
    publicID := c.Param("id_pesanan")
    userID := c.GetInt64("user_id")

    var pesanan Pesanan
    err := db.QueryRow(`
        SELECT p.*
        FROM pesanan p
        JOIN customer cu ON cu.id_customer = p.id_customer
        WHERE p.public_id = $1 AND cu.id_user = $2
    `, publicID, userID).Scan(&pesanan)

    // Ownership sudah tercek sekaligus di query
}
```

---

## 7. PASSWORD & SECURITY POLICY

### 7.1 Password Rules

| Aturan                | Nilai       |
|-----------------------|-------------|
| Panjang minimum       | 8 karakter  |
| Harus ada huruf besar | Tidak wajib |
| Harus ada angka       | Tidak wajib |
| Hashing algorithm     | bcrypt      |
| bcrypt cost factor    | 12          |

### 7.2 Implementasi Bcrypt Golang

```go
import "golang.org/x/crypto/bcrypt"

// Hash password saat register / change password
func HashPassword(password string) (string, error) {
    bytes, err := bcrypt.GenerateFromPassword([]byte(password), 12)
    return string(bytes), err
}

// Verifikasi password saat login
func CheckPassword(password, hash string) bool {
    err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
    return err == nil
}
```

### 7.3 Security Headers (Golang)

```go
// Middleware untuk set security headers
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

## 8. CORS POLICY

CORS hanya relevan untuk **React Web**. Flutter tidak butuh CORS.

### 8.1 Konfigurasi CORS di Golang

```go
import "github.com/gin-contrib/cors"

config := cors.Config{
    AllowOrigins:     []string{"https://admin.mantra.com"},
    AllowMethods:     []string{"GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"},
    AllowHeaders:     []string{"Origin", "Content-Type", "Authorization"},
    ExposeHeaders:    []string{"Content-Length"},
    AllowCredentials: true,           // WAJIB true agar cookie dikirim
    MaxAge:           12 * time.Hour,
}

r.Use(cors.New(config))
```

> `AllowCredentials: true` adalah konfigurasi **wajib** agar browser mengirim httpOnly cookie ke backend.
> Jika `AllowCredentials: true`, maka `AllowOrigins` tidak boleh `*` (wildcard) — harus domain spesifik.

### 8.2 Axios Config di React

```javascript
// Wajib withCredentials: true agar browser kirim cookie
const api = axios.create({
  baseURL: 'https://api.mantra.com/api/v1',
  withCredentials: true,
});
```

---

## 9. RATE LIMITING

### 9.1 Strategi Rate Limit per Endpoint

| Endpoint                | Limit          | Alasan                                  |
|-------------------------|----------------|-----------------------------------------|
| `POST /login`           | 5 req / menit  | Mencegah brute force password           |
| `POST /register`        | 3 req / menit  | Mencegah spam registrasi                |
| `POST /auth/refresh`    | 10 req / menit | Mencegah token abuse                    |
| Semua endpoint lainnya  | 60 req / menit | General rate limiting                   |

### 9.2 Response Rate Limit (429)

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

### 9.3 Implementasi Golang (menggunakan golang.org/x/time/rate)

```go
import "golang.org/x/time/rate"

// Rate limiter per IP
var loginLimiter = rate.NewLimiter(rate.Every(time.Minute/5), 5)

func LoginRateLimitMiddleware() gin.HandlerFunc {
    return func(c *gin.Context) {
        if !loginLimiter.Allow() {
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
- [ ] Gunakan `flutter_secure_storage`, **bukan** `SharedPreferences` atau hardcoded
- [ ] Access token dan refresh token disimpan terpisah
- [ ] Hapus semua token saat logout

### API Interceptor (Dio)
```dart
// Contoh interceptor untuk auto-refresh token
dio.interceptors.add(InterceptorsWrapper(
  onError: (error, handler) async {
    if (error.response?.statusCode == 401) {
      // Coba refresh token
      final refreshed = await refreshToken();
      if (refreshed) {
        // Retry request dengan token baru
        return handler.resolve(await dio.fetch(error.requestOptions));
      } else {
        // Refresh gagal → logout
        await logout();
        // Redirect ke halaman login
      }
    }
    return handler.next(error);
  },
));
```

### UI Security
- [ ] Gunakan `kode` (bukan `label`) untuk logika kondisional di UI
- [ ] Jangan tampilkan pesan error teknis (`detail`) ke user — hanya tampilkan `message`
- [ ] Role-based UI: render halaman/tombol berdasarkan role yang disimpan di state

---

## 11. REACT WEB SECURITY CHECKLIST

### Cookie & Auth
- [ ] Semua request menggunakan `withCredentials: true`
- [ ] Tidak ada token yang disimpan di `localStorage` atau `sessionStorage`
- [ ] Token tidak pernah diakses via JavaScript (httpOnly cookie)

### Axios Interceptor
```javascript
// Auto-redirect ke login jika 401 atau 403
api.interceptors.response.use(
  (response) => response,
  async (error) => {
    if (error.response?.status === 401) {
      // Coba refresh token (browser kirim cookie otomatis)
      try {
        await api.post('/auth/refresh');
        return api.request(error.config); // Retry
      } catch {
        // Refresh gagal
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
```

### UI Security
- [ ] Role-based rendering: tampilkan menu/halaman berdasarkan role dari response login
- [ ] Jangan simpan role di `localStorage` — ambil dari response API saat login, simpan di state management (Redux/Zustand)
- [ ] Setiap route yang protected harus cek role sebelum render
- [ ] Jangan tampilkan pesan `error.detail` ke user — hanya tampilkan `error.message`
