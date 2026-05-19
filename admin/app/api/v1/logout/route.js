// File: app/api/v1/logout/route.js
import { NextResponse } from 'next/server';

export async function POST(request) {
  try {
    // 1. Agen Rahasia Next.js ngambil Cookie (Ini PASTI tembus walaupun HttpOnly!)
    const accessToken = request.cookies.get('access_token')?.value || request.cookies.get('token')?.value;
    const refreshToken = request.cookies.get('refresh_token')?.value || "";

    // 2. Kita nyamar jadi Bruno dan nembak ke Golang temen lu!
    // Ganti URL ini kalau Golang temen lu jalannya bukan di port 8080
    const golangUrl = process.env.BACKEND_URL || 'http://localhost:8080'; 

    if (accessToken) {
      await fetch(`${golangUrl}/api/v1/logout`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${accessToken}`, // Kirim Header persis kayak Bruno
          'X-Client-Type': 'nextjs' // Beri tahu Golang bahwa ini dari Next.js
        },
        body: JSON.stringify({
          refresh_token: refreshToken // Kirim Body persis kayak Bruno
        })
      });
      console.log("Berhasil nembak Golang untuk logout!");
    }

    // 3. Bikin response sukses untuk dikirim balik ke browser lu
    const response = NextResponse.json({ status: "success", message: "Logout lokal dan server berhasil" });

    // 4. JURUS PAMUNGKAS: HAPUS COOKIE SECARA PAKSA DARI SERVER DENGAN PATH SPESIFIK!
    response.cookies.delete({ name: 'access_token', path: '/' });
    response.cookies.delete({ name: 'refresh_token', path: '/' }); // Path baru
    response.cookies.delete({ name: 'token', path: '/' });

    return response;

  } catch (error) {
    console.error("Error di agen rahasia logout:", error);
    
    // Walaupun Golang temen lu error/down, kita TETEP paksa hapus cookie lokalnya
    const fallbackResponse = NextResponse.json({ status: "error", message: "Terjadi kesalahan, tapi dipaksa logout" });
    fallbackResponse.cookies.delete({ name: 'access_token', path: '/' });
    fallbackResponse.cookies.delete({ name: 'refresh_token', path: '/' }); // Path baru
    fallbackResponse.cookies.delete({ name: 'token', path: '/' });
    
    return fallbackResponse;
  }
}