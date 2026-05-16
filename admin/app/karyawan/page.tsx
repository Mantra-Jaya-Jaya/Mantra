"use client";
import { useState } from "react";
import Link from "next/link";
import { Search, Plus, Trash2, Edit2, ChevronLeft, ChevronRight } from "lucide-react";

export default function KaryawanPage() {
  // State untuk filter pencarian (persiapan buat disambung ke API nanti)
  const [searchQuery, setSearchQuery] = useState("");
  const [roleFilter, setRoleFilter] = useState("Semua Role");
  const [statusFilter, setStatusFilter] = useState("Status Aktif");

  // Data Dummy Karyawan (Role dibatasi Kasir & Kurir)
  const dummyKaryawan = [
    { id: 1, nama: "Budi Kusuma", email: "budi@mantrapos.com", role: "Kasir", terakhirLogin: "12 Oct 2023, 14:30", status: "Aktif", inisial: "BK" },
    { id: 2, nama: "Siti Aminah", email: "siti@mantrapos.com", role: "Kurir", terakhirLogin: "12 Oct 2023, 11:15", status: "Aktif", inisial: "SA" },
    { id: 3, nama: "Riztika Amelia", email: "riztika@mantrapos.com", role: "Kasir", terakhirLogin: "11 Oct 2023, 09:00", status: "Aktif", inisial: "RA" },
    { id: 4, nama: "Rafa Ahmad", email: "rafa@mantrapos.com", role: "Kurir", terakhirLogin: "10 Oct 2023, 18:20", status: "Nonaktif", inisial: "RA" },
    { id: 5, nama: "King Arthur", email: "king@mantrapos.com", role: "Kasir", terakhirLogin: "09 Oct 2023, 08:30", status: "Aktif", inisial: "KA" },
    { id: 6, nama: "Nabila Syalwa", email: "nabila@mantrapos.com", role: "Kasir", terakhirLogin: "08 Oct 2023, 16:45", status: "Aktif", inisial: "NS" },
  ];

  const [currentPage, setCurrentPage] = useState(1);
  const itemsPerPage = 5; // Kita batasin 1 halaman tampil 5 orang aja

  // Menghitung total halaman (6 orang / 5 = 2 halaman)
  const totalPages = Math.ceil(dummyKaryawan.length / itemsPerPage);

  // Memotong data asli biar yang tampil cuma 5 baris sesuai halaman aktif
  const startIndex = (currentPage - 1) * itemsPerPage;
  const currentData = dummyKaryawan.slice(startIndex, startIndex + itemsPerPage);

  return (
    <div className="w-full pb-12">
      
      {/* HEADER */}
      <div className="flex justify-between items-end mb-6">
        <div>
          <h1 className="text-3xl font-bold text-zinc-900 mb-1">Daftar Karyawan</h1>
          <p className="text-sm text-zinc-500 font-medium">Kelola Karyawan Anda</p>
        </div>
        
        <Link 
          href="/karyawan/tambah" 
          className="flex items-center gap-2 px-5 py-2.5 bg-[#AF520C] text-white rounded-lg text-sm font-bold hover:bg-[#8e4209] transition shadow-sm"
        >
          <Plus size={18} />
          Tambah Karyawan
        </Link>
      </div>

      {/* FILTER BAR (Putih melengkung kayak di desain lu) */}
      <div className="bg-white p-4 rounded-xl border border-zinc-200 shadow-sm flex flex-col md:flex-row gap-4 mb-6">
        {/* Search */}
        <div className="relative flex-1">
          <Search size={18} className="absolute left-3 top-1/2 -translate-y-1/2 text-zinc-400" />
          <input 
            type="text" 
            placeholder="Cari nama atau email karyawan..." // Kak Gem benerin copy-paste lu wkwk
            className="w-full pl-10 pr-4 py-2 border border-zinc-200 rounded-lg text-sm focus:outline-none focus:border-[#AF520C]"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
          />
        </div>

        {/* Dropdown Role */}
        <div className="w-full md:w-48">
          <select 
            className="w-full px-4 py-2 border border-zinc-200 rounded-lg text-sm focus:outline-none focus:border-[#AF520C] appearance-none bg-white cursor-pointer"
            value={roleFilter}
            onChange={(e) => setRoleFilter(e.target.value)}
          >
            <option value="Semua Role">Semua Role</option>
            <option value="Kasir">Kasir</option>
            <option value="Kurir">Kurir</option>
          </select>
        </div>

        {/* Dropdown Status */}
        <div className="w-full md:w-48">
          <select 
            className="w-full px-4 py-2 border border-zinc-200 rounded-lg text-sm focus:outline-none focus:border-[#AF520C] appearance-none bg-white cursor-pointer"
            value={statusFilter}
            onChange={(e) => setStatusFilter(e.target.value)}
          >
            <option value="Status Aktif">Status Aktif</option>
            <option value="Semua Status">Semua Status</option>
            <option value="Nonaktif">Nonaktif</option>
          </select>
        </div>
      </div>

      {/* TABEL KARYAWAN */}
      <div className="bg-white rounded-xl border border-zinc-200 shadow-sm overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-zinc-50 border-b border-zinc-200">
                <th className="px-6 py-4 text-xs font-bold text-zinc-500 uppercase tracking-wider">User</th>
                <th className="px-6 py-4 text-xs font-bold text-zinc-500 uppercase tracking-wider">Role</th>
                <th className="px-6 py-4 text-xs font-bold text-zinc-500 uppercase tracking-wider">Terakhir Login</th>
                <th className="px-6 py-4 text-xs font-bold text-zinc-500 uppercase tracking-wider">Status</th>
                <th className="px-6 py-4 text-xs font-bold text-zinc-500 uppercase tracking-wider">Action</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-zinc-100">
              {currentData.map((user) => (
                <tr key={user.id} className="hover:bg-orange-50/30 transition">
                  {/* Kolom User (Foto + Nama + Email) */}
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 rounded-full bg-zinc-200 flex items-center justify-center text-zinc-500 font-bold text-sm shrink-0">
                        {user.inisial}
                      </div>
                      <div>
                        <p className="font-bold text-sm text-zinc-800">{user.nama}</p>
                        <p className="text-xs text-zinc-500 mt-0.5">{user.email}</p>
                      </div>
                    </div>
                  </td>
                  
                  {/* Kolom Role */}
                  <td className="px-6 py-4">
                    <span className="text-sm font-semibold text-zinc-700">{user.role}</span>
                  </td>
                  
                  {/* Kolom Terakhir Login */}
                  <td className="px-6 py-4">
                    <span className="text-sm text-zinc-500">{user.terakhirLogin}</span>
                  </td>
                  
                  {/* Kolom Status (Badge) */}
                  <td className="px-6 py-4">
                    <div className={`inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold ${
                      user.status === "Aktif" ? "bg-green-50 text-green-700 border border-green-200" : "bg-red-50 text-red-700 border border-red-200"
                    }`}>
                      <span className={`w-1.5 h-1.5 rounded-full ${user.status === "Aktif" ? "bg-green-500" : "bg-red-500"}`}></span>
                      {user.status}
                    </div>
                  </td>
                  
                  {/* Kolom Action */}
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-3">
                      <button className="text-zinc-400 hover:text-red-500 transition" title="Hapus">
                        <Trash2 size={18} />
                      </button>
                      <button className="text-zinc-400 hover:text-blue-500 transition" title="Edit">
                        <Edit2 size={18} />
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        {/* PAGINATION */}
        <div className="px-6 py-4 border-t border-zinc-200 flex items-center justify-between bg-white">
          <p className="text-sm text-zinc-500">
            Menampilkan {startIndex + 1} hingga {Math.min(startIndex + itemsPerPage, dummyKaryawan.length)} dari {dummyKaryawan.length} karyawan
          </p>
          
          {/* Cuma tampil kalau halamannya lebih dari 1 */}
          {totalPages > 1 && (
            <div className="flex items-center gap-1">
              {/* Tombol Previous */}
              <button 
                onClick={() => setCurrentPage(prev => Math.max(prev - 1, 1))}
                disabled={currentPage === 1}
                className="p-1.5 text-zinc-400 hover:text-zinc-800 transition rounded-md hover:bg-zinc-100 disabled:opacity-30 disabled:cursor-not-allowed"
              >
                <ChevronLeft size={18} />
              </button>
              
              {/* Generate Angka Halaman Otomatis */}
              {[...Array(totalPages)].map((_, i) => (
                <button 
                  key={i}
                  onClick={() => setCurrentPage(i + 1)}
                  className={`w-8 h-8 flex items-center justify-center rounded-md text-sm transition ${
                    currentPage === i + 1 
                      ? "bg-[#AF520C] text-white font-bold shadow-sm" // Warna aktif
                      : "text-zinc-600 hover:bg-zinc-100" // Warna mati
                  }`}
                >
                  {i + 1}
                </button>
              ))}
              
              {/* Tombol Next */}
              <button 
                onClick={() => setCurrentPage(prev => Math.min(prev + 1, totalPages))}
                disabled={currentPage === totalPages}
                className="p-1.5 text-zinc-400 hover:text-zinc-800 transition rounded-md hover:bg-zinc-100 disabled:opacity-30 disabled:cursor-not-allowed"
              >
                <ChevronRight size={18} />
              </button>
            </div>
          )}
        </div>
      </div>

    </div>
  );
}