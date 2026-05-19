import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  /* config options here */
  
  // 🚀 Proxy otomatis dari Next.js ke Golang Backend lu
  async rewrites() {
    return [
      {
        source: '/api/:path*',
        destination: 'http://localhost:8080/api/:path*', 
      },
    ];
  },
};

export default nextConfig;