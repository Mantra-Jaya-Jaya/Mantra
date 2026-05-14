import { Bell } from 'lucide-react';

export default function Navbar() {
  return (
    <nav className="flex items-center justify-between px-8 py-4 bg-white border-b">
      <div className="flex items-center gap-2">
        <div className="w-8 h-8 bg-orange-600 rounded-lg flex items-center justify-center">
          <span className="text-white font-bold text-xl italic">M</span>
        </div>
        <span className="text-xl font-bold text-zinc-800">Mantra</span>
      </div>
      
      <div className="flex items-center gap-8">
        <div className="flex gap-6 text-zinc-500 font-medium">
          <a href="#" className="text-orange-600 border-b-2 border-orange-600 pb-1">Home</a>
          <a href="#" className="hover:text-zinc-800 transition">Barang</a>
          <a href="#" className="hover:text-zinc-800 transition">Karyawan</a>
        </div>
        
        <div className="flex items-center gap-4 border-l pl-6">
          <button className="p-2 bg-zinc-100 rounded-full text-zinc-600 hover:bg-zinc-200 transition">
            <Bell size={20} />
          </button>
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-zinc-300 rounded-full overflow-hidden">
              <img src="https://ui-avatars.com/api/?name=Hamim+Rajaba&background=random" alt="User" />
            </div>
          </div>
        </div>
      </div>
    </nav>
  );
}