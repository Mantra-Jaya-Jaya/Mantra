"use client";
import { useState } from 'react';
import Link from 'next/link';
import { usePathname, useRouter } from 'next/navigation';
import { Bell, LogOut } from 'lucide-react'; // Tambah icon LogOut

export default function Navbar() {
  const pathname = usePathname(); 
  const router = useRouter();
  
  // State untuk buka/tutup menu profil
  const [showProfileMenu, setShowProfileMenu] = useState(false);

  // Saklar Otomatis: Kalau lagi di halaman login, Navbar langsung ngilang!
  if (pathname === '/login') return null;

  // Fungsi Logout
  const handleLogout = async () => {
    try {
      // Tinggal ketuk pintu agen rahasia Next.js kita, sisanya dia yang urus!
      await fetch('/api/v1/logout', { method: 'POST' });
    } catch (error) {
      console.error("Gagal manggil API logout lokal:", error);
    } finally {
      // Pake window.location.href biar browser ke-refresh total dan ngebuang state React yang nyangkut
      window.location.href = '/login'; 
    }
  };

  return (
    <nav className="flex items-center justify-between px-8 py-4 bg-white shadow-sm relative z-40">
      {/* Logo Kiri */}
      <div className="flex items-center gap-2">
        <div className="w-8 h-8 bg-[#AF520C] rounded-lg flex items-center justify-center">
          <span className="text-white font-bold text-xl italic">M</span>
        </div>
        <span className="text-xl font-bold text-zinc-800">Mantra</span>
      </div>
      
      {/* Menu Kanan */}
      <div className="flex items-center gap-10">
        <div className="flex gap-10 text-zinc-500 font-medium text-sm">
          <Link href="/" className={`pb-1 transition ${pathname === '/' ? 'text-[#AF520C] border-b-2 border-[#AF520C]' : 'hover:text-zinc-800'}`}>
            Home
          </Link>
          <Link href="/barang" className={`pb-1 transition ${pathname === '/barang' || pathname.startsWith('/barang/') ? 'text-[#AF520C] border-b-2 border-[#AF520C]' : 'hover:text-zinc-800'}`}>
            Barang
          </Link>
          <Link href="/karyawan" className={`pb-1 transition ${pathname === '/karyawan' ? 'text-[#AF520C] border-b-2 border-[#AF520C]' : 'hover:text-zinc-800'}`}>
            Karyawan
          </Link>
        </div>
        
        <div className="flex items-center gap-4 border-l border-zinc-200 pl-6">
          <button className="p-2 bg-zinc-50 rounded-full text-zinc-500 hover:bg-zinc-100 transition">
            <Bell size={18} />
          </button>
          
          {/* PROFILE SECTION DENGAN DROPDOWN */}
          <div className="relative">
            {/* Foto Profil (Bisa di-klik) */}
            <div 
              onClick={() => setShowProfileMenu(!showProfileMenu)}
              className="w-9 h-9 bg-zinc-200 rounded-full overflow-hidden border border-zinc-200 cursor-pointer hover:ring-2 hover:ring-[#AF520C]/50 transition-all"
            >
              <img src="https://ui-avatars.com/api/?name=Admin+Mantra&background=171717&color=fff" alt="Admin" />
            </div>

            {/* Dropdown Menu (Muncul kalau state showProfileMenu === true) */}
            {showProfileMenu && (
              <>
                {/* Overlay transparan buat nutup menu kalau user klik di luar kotak */}
                <div 
                  className="fixed inset-0 z-40"
                  onClick={() => setShowProfileMenu(false)}
                ></div>

                {/* Kotak Menu Dropdown */}
                <div className="absolute right-0 mt-3 w-56 bg-white rounded-xl shadow-lg border border-zinc-200 p-2 z-50 animate-in fade-in slide-in-from-top-2 duration-200">
                  {/* Info User */}
                  <div className="px-3 py-3 border-b border-zinc-100 mb-2">
                    <p className="text-sm font-bold text-zinc-800">Terra Surya</p>
                    <p className="text-xs text-zinc-500 mt-0.5">admin@mantra.com</p>
                  </div>
                  
                  {/* Tombol Logout Coklat */}
                  <button 
                    onClick={handleLogout}
                    className="w-full flex items-center justify-center gap-2 bg-[#AF520C] hover:bg-[#8e4209] text-white px-4 py-2.5 rounded-lg text-sm font-semibold transition-colors"
                  >
                    <LogOut size={16} />
                    Logout
                  </button>
                </div>
              </>
            )}
          </div>

        </div>
      </div>
    </nav>
  );
}