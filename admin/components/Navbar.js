"use client";
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { Bell } from 'lucide-react';

export default function Navbar() {
  const pathname = usePathname(); // Ngambil info URL saat ini (misal: '/' atau '/barang')

  return (
    <nav className="flex items-center justify-between px-8 py-4 bg-white border-b">
      <div className="flex items-center gap-2">
        <div className="w-8 h-8 bg-[#AF520C] rounded-lg flex items-center justify-center">
          <span className="text-white font-bold text-xl italic">M</span>
        </div>
        <span className="text-xl font-bold text-zinc-800">Mantra</span>
      </div>
      
      <div className="flex items-center gap-8">
        <div className="flex gap-6 text-zinc-500 font-medium text-sm">
          {/* Ini logic dinamisnya, kalau URL-nya cocok, dia jadi orange dan digarisbawahi */}
          <Link href="/" className={`pb-1 transition ${pathname === '/' ? 'text-[#AF520C] border-b-2 border-[#AF520C]' : 'hover:text-zinc-800'}`}>
            Home
          </Link>
          <Link href="/barang" className={`pb-1 transition ${pathname === '/barang' ? 'text-[#AF520C] border-b-2 border-[#AF520C]' : 'hover:text-zinc-800'}`}>
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
          <div className="w-9 h-9 bg-zinc-200 rounded-full overflow-hidden border border-zinc-200">
            <img src="https://ui-avatars.com/api/?name=Hamim+Rajaba&background=171717&color=fff" alt="Admin" />
          </div>
        </div>
      </div>
    </nav>
  );
}