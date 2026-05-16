"use client";
import { useState } from "react";
import { Search, Trash2, Edit2, Plus, ChevronDown, BadgePercent} from "lucide-react";
import Link from 'next/link';
import { dataBarang } from "@/lib/dummyData"; 

export default function BarangPage() {
  const [searchTerm, setSearchTerm] = useState("");
  const [kategoriFilter, setKategoriFilter] = useState("Semua Kategori");
  const [stokFilter, setStokFilter] = useState("Status Stok");
  const [currentPage, setCurrentPage] = useState(1);
  const itemsPerPage = 10;

  // 1. LOGIC FILTERING (Search + Kategori + Stok)
  const filteredData = dataBarang.filter((item) => {
    // Filter Search
    const matchesSearch = item.nama.toLowerCase().includes(searchTerm.toLowerCase()) || 
                          item.sku.toLowerCase().includes(searchTerm.toLowerCase());
    
    // Filter Kategori
    const matchesKategori = kategoriFilter === "Semua Kategori" || item.kategori === kategoriFilter;

    // Filter Stok
    let matchesStok = true;
    if (stokFilter === "Kritis") matchesStok = item.stok <= 10;
    if (stokFilter === "Aman") matchesStok = item.stok > 10;

    return matchesSearch && matchesKategori && matchesStok;
  });

  // 2. LOGIC PAGINATION
  const totalPages = Math.ceil(filteredData.length / itemsPerPage);
  const startIndex = (currentPage - 1) * itemsPerPage;
  const currentData = filteredData.slice(startIndex, startIndex + itemsPerPage);

  return (
    <div className="w-full">
      {/* Header Halaman */}
      <div className="flex justify-between items-end mb-8">
        <div>
          <h1 className="text-3xl font-bold text-zinc-900 mb-2">Daftar Barang</h1>
          <p className="text-sm text-zinc-500">Kelola produk, harga, dan stok inventaris Anda.</p>
        </div>
        <div className="flex items-center gap-3">
          <Link href="/barang/kategori" className="flex items-center gap-2 bg-white border border-zinc-200 text-zinc-700 hover:bg-zinc-50 px-4 py-2.5 rounded-lg text-sm font-semibold transition-colors shadow-sm">
            <Plus size={18} />
            Kategori
          </Link>
          <Link href="/barang/tambah" className="flex items-center gap-2 bg-[#AF520C] hover:bg-[#8e4209] text-white px-4 py-2.5 rounded-lg text-sm font-semibold transition-colors shadow-sm">
            <Plus size={18} />
            Tambah Barang
          </Link>
        </div>
      </div>

      {/* Filter Bar (Kotak Putih di atas tabel) */}
      <div className="bg-white p-4 rounded-xl border border-zinc-200 shadow-sm mb-6 flex flex-col sm:flex-row gap-4">
        {/* Search */}
        <div className="relative flex-1 max-w-md">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-zinc-400" size={18} />
          <input
            type="text"
            spellCheck="false"
            placeholder="Cari nama barang atau SKU..."
            className="w-full pl-10 pr-4 py-2 border border-zinc-200 rounded-lg text-sm text-zinc-800 placeholder:text-zinc-400 focus:outline-none focus:border-[#AF520C]"
            value={searchTerm}
            onChange={(e) => {
              setSearchTerm(e.target.value);
              setCurrentPage(1); // Reset halaman ke 1
            }}
          />
        </div>

        {/* Dropdown Kategori */}
        <div className="relative">
          <select 
            className="appearance-none bg-white border border-zinc-200 text-zinc-700 text-sm rounded-lg pl-4 pr-10 py-2 outline-none cursor-pointer hover:bg-zinc-50 focus:border-[#AF520C]"
            value={kategoriFilter}
            onChange={(e) => { setKategoriFilter(e.target.value); setCurrentPage(1); }}
          >
            <option value="Semua Kategori">Semua Kategori</option>
            <option value="Gadget">Gadget</option>
            <option value="Aksesoris">Aksesoris</option>
          </select>
          <ChevronDown className="absolute right-3 top-1/2 -translate-y-1/2 text-zinc-400 pointer-events-none" size={16} />
        </div>

        {/* Dropdown Stok */}
        <div className="relative">
          <select 
            className="appearance-none bg-white border border-zinc-200 text-zinc-700 text-sm rounded-lg pl-4 pr-10 py-2 outline-none cursor-pointer hover:bg-zinc-50 focus:border-[#AF520C]"
            value={stokFilter}
            onChange={(e) => { setStokFilter(e.target.value); setCurrentPage(1); }}
          >
            <option value="Status Stok">Status Stok</option>
            <option value="Aman">Stok Aman</option>
            <option value="Kritis">Stok Kritis</option>
          </select>
          <ChevronDown className="absolute right-3 top-1/2 -translate-y-1/2 text-zinc-400 pointer-events-none" size={16} />
        </div>
      </div>

      {/* Tabel Data */}
      <div className="bg-white rounded-xl border border-zinc-200 shadow-sm overflow-hidden">
        <table className="w-full text-left">
          <thead className="bg-[#f8fafc] text-zinc-600 text-xs font-bold uppercase tracking-wider border-b border-zinc-200">
            <tr>
              <th className="px-6 py-4">BARANG</th>
              <th className="px-6 py-4">HARGA</th>
              <th className="px-6 py-4">STOCK</th>
              <th className="px-6 py-4">KATEGORI</th>
              <th className="px-6 py-4 text-center">ACTION</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-zinc-100 text-sm text-zinc-800">
            {currentData.length > 0 ? currentData.map((item) => (
              <tr key={item.id} className="hover:bg-zinc-50 transition-colors">
                {/* Kolom Barang (Gambar + Teks) */}
                <td className="px-6 py-4 flex items-center gap-4">
                  <div className="w-10 h-10 rounded-lg overflow-hidden shrink-0 bg-zinc-800 border border-zinc-200">
                    <img src={item.gambar} alt={item.nama} className="w-full h-full object-cover" />
                  </div>
                  <div>
                    <p className="font-bold text-zinc-900">{item.nama}</p>
                    <p className="text-zinc-400 text-xs mt-0.5">SKU: {item.sku}</p>
                  </div>
                </td>
                
                {/* Kolom Harga */}
                <td className="px-6 py-4 text-zinc-600">{item.harga}</td>
                
                {/* Kolom Stok + Indikator Warna */}
                <td className="px-6 py-4">
                  <div className="flex items-center gap-2">
                    <span className="font-medium">{item.stok}</span>
                    <span className={`w-1.5 h-1.5 rounded-full ${item.stok <= 10 ? 'bg-red-500' : 'bg-green-500'}`}></span>
                  </div>
                </td>

                {/* Kolom Kategori */}
                <td className="px-6 py-4 text-zinc-600">{item.kategori}</td>

                {/* Kolom Action */}
                <td className="px-6 py-4">
                  <div className="flex gap-4 justify-center text-zinc-400">
                    {/* Ini tombol diskon baru lu */}
                    <button className="hover:text-green-600 transition-colors" title="Set Diskon">
                      <BadgePercent size={18} />
                    </button>
                    
                    <button className="hover:text-blue-500 transition-colors" title="Edit">
                      <Edit2 size={18} />
                    </button>
                    
                    <button className="hover:text-red-500 transition-colors" title="Hapus">
                      <Trash2 size={18} />
                    </button>
                  </div>
                </td>
              </tr>
            )) : (
              <tr>
                <td colSpan={5} className="px-6 py-12 text-center text-zinc-400">
                  Tidak ada barang yang ditemukan.
                </td>
              </tr>
            )}
          </tbody>
        </table>

        {/* Footer Pagination (Logika Dinamis) */}
        {filteredData.length > 0 && (
          <div className="p-4 border-t border-zinc-200 flex justify-between items-center text-sm text-zinc-500 bg-white">
            <p>Menampilkan {startIndex + 1} hingga {Math.min(startIndex + itemsPerPage, filteredData.length)} dari {filteredData.length} barang</p>
            <div className="flex items-center gap-1">
              <button 
                disabled={currentPage === 1}
                onClick={() => setCurrentPage(p => p - 1)}
                className="p-1 px-2 hover:bg-zinc-100 rounded disabled:opacity-50 transition"
              >
                &lt;
              </button>
              
              {(() => {
                let pages = [];
                for (let i = 1; i <= totalPages; i++) {
                  if (i === 1 || i === totalPages || (i >= currentPage - 1 && i <= currentPage + 1)) {
                    pages.push(i);
                  }
                }
                
                let finalPages = [];
                let last = 0;
                for (let page of pages) {
                  if (last && page - last > 1) finalPages.push('...');
                  finalPages.push(page);
                  last = page;
                }

                return finalPages.map((page, index) => {
                  if (page === '...') return <span key={index} className="px-2 text-zinc-400">...</span>;
                  return (
                    <button 
                      key={index} 
                      onClick={() => setCurrentPage(Number(page))}
                      className={`w-8 h-8 flex items-center justify-center rounded-lg transition ${currentPage === page ? 'bg-[#AF520C] text-white font-bold shadow-sm' : 'hover:bg-zinc-100'}`}
                    >
                      {page}
                    </button>
                  );
                });
              })()}

              <button 
                disabled={currentPage === totalPages}
                onClick={() => setCurrentPage(p => p + 1)}
                className="p-1 px-2 hover:bg-zinc-100 rounded disabled:opacity-50 transition"
              >
                &gt;
              </button>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}