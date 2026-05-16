import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server'; 


export function proxy(request: NextRequest) {
  // Cek token di cookie
  const token = request.cookies.get('access_token')?.value || request.cookies.get('token')?.value;
  
  // Cek user lagi mau buka halaman apa
  const path = request.nextUrl.pathname;
  const isLoginPage = path.startsWith('/login');

  // ATURAN 1: Kalau belum login dan mau buka halaman selain login
  if (!token && !isLoginPage) {
    return NextResponse.redirect(new URL('/login', request.url));
  }

  // ATURAN 2: Kalau UDAH login, tapi iseng buka halaman login lagi
  if (token && isLoginPage) {
    return NextResponse.redirect(new URL('/', request.url));
  }

  // Kalau aman
  return NextResponse.next();
}

// Konfigurasi area mana aja yang dipatroli sama Middleware
export const config = {
  matcher: [
    '/((?!api|_next/static|_next/image|favicon.ico|logo.png|.*\\.png$).*)',
  ],
};