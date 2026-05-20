import type { NextConfig } from "next";

// Ambil IP dari environment variable (jika ada), kalau tidak ada gunakan default localhost
const devOrigins = process.env.ALLOWED_DEV_ORIGINS 
  ? process.env.ALLOWED_DEV_ORIGINS.split(',') 
  : ['localhost', '127.0.0.1'];

const nextConfig: NextConfig = {
  /* config options here */
  allowedDevOrigins: devOrigins,
  
  // 🔥 TAMBAHAN BARU: Izin untuk me-render gambar dari MinIO
  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: 'storage.mantra.web.id', // Domain MinIO lu
        pathname: '/**', // Izinkan semua folder di dalamnya
      },
    ],
  },

  // 🔥 REWRITES LAMA LU: Tetap utuh, Auth dan API ke Golang dijamin aman!
  async rewrites() {
    return [
      {
        source: '/api/:path*',
        destination: 'http://localhost:8080/api/:path*', // Proxy to Golang Backend
      },
    ];
  },
};

export default nextConfig;