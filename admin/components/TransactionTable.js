"use client";
import { useState } from 'react';
import { Search } from 'lucide-react';

export default function TransactionTable({ data }) {
  const [searchTerm, setSearchTerm] = useState('');
  const [currentPage, setCurrentPage] = useState(1);
  const itemsPerPage = 10;

  // Logic Search: Bisa cari ID Transaksi, nama Kasir, atau Pelanggan
  const filteredData = data.filter((trx) => 
    trx.id.toLowerCase().includes(searchTerm.toLowerCase()) ||
    trx.kasir.toLowerCase().includes(searchTerm.toLowerCase()) ||
    trx.pelanggan.toLowerCase().includes(searchTerm.toLowerCase())
  );

  // Logic Pagination
  const totalPages = Math.ceil(filteredData.length / itemsPerPage);
  const startIndex = (currentPage - 1) * itemsPerPage;
  const currentData = filteredData.slice(startIndex, startIndex + itemsPerPage);

  return (
    <div className="bg-white rounded-2xl border border-zinc-100 shadow-sm overflow-hidden mt-8">
      {/* Header Table & Search */}
      <div className="p-4 border-b border-zinc-100 flex justify-between items-center">
        <h3 className="font-bold text-zinc-800 text-lg">Riwayat Transaksi</h3>
        <div className="relative">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-zinc-400" size={18} />
          <input 
            type="text" 
            spellCheck="false"
            placeholder="Cari transaksi, kasir, atau pelanggan..."
            className="pl-10 pr-4 py-2 border border-zinc-200 rounded-lg text-sm text-zinc-800 placeholder:text-zinc-400 focus:outline-none focus:border-[#c26027] w-72"
            value={searchTerm}
            onChange={(e) => {
              setSearchTerm(e.target.value);
              setCurrentPage(1); 
            }}
          />
        </div>
      </div>

      <table className="w-full text-left">
        <thead className="bg-[#f8fafc] text-zinc-500 text-xs font-bold uppercase tracking-wider">
          <tr>
            <th className="px-6 py-4">ID Transaksi</th>
            <th className="px-6 py-4">Kasir</th>
            <th className="px-6 py-4">Pelanggan</th>
            <th className="px-6 py-4">Tanggal</th>
            <th className="px-6 py-4">Total</th>
            <th className="px-6 py-4">Status</th>
          </tr>
        </thead>
        <tbody className="divide-y divide-zinc-100 text-sm text-zinc-700">
          {currentData.map((trx) => (
            <tr key={trx.id} className="hover:bg-zinc-50 transition">
              <td className="px-6 py-4 font-bold">{trx.id}</td>
              <td className="px-6 py-4">{trx.kasir}</td>
              <td className="px-6 py-4">{trx.pelanggan}</td>
              <td className="px-6 py-4 text-zinc-400">{trx.tanggal}</td>
              <td className="px-6 py-4 font-semibold">{trx.total}</td>
              <td className="px-6 py-4">
                <span className={`px-3 py-1 rounded-full text-xs font-bold flex items-center gap-2 w-fit ${
                  trx.status === 'Selesai' ? 'bg-green-50 text-green-600' : 
                  trx.status === 'Proses' ? 'bg-orange-50 text-orange-600' : 'bg-red-50 text-red-600'
                }`}>
                  <span className={`w-1.5 h-1.5 rounded-full ${
                    trx.status === 'Selesai' ? 'bg-green-600' : 
                    trx.status === 'Proses' ? 'bg-orange-600' : 'bg-red-600'
                  }`}></span>
                  {trx.status}
                </span>
              </td>
            </tr>
          ))}
        </tbody>
      </table>

      {/* Pagination Footer */}
      <div className="p-4 border-t border-zinc-100 flex justify-between items-center text-sm text-zinc-500">
        <p>Menampilkan {filteredData.length === 0 ? 0 : startIndex + 1} hingga {Math.min(startIndex + itemsPerPage, filteredData.length)} dari {filteredData.length} transaksi</p>
        <div className="flex items-center gap-1">
          <button 
            disabled={currentPage === 1}
            onClick={() => setCurrentPage(p => p - 1)}
            className="p-1 px-2 hover:bg-zinc-100 rounded disabled:opacity-50"
          >
            &lt;
          </button>
          
          {/* LOGIKA PAGINATION DINAMIS */}
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
              if (last && page - last > 1) {
                finalPages.push('...'); // Kasih titik-titik kalau ada angka yang kelompat
              }
              finalPages.push(page);
              last = page;
            }

            return finalPages.map((page, index) => {
              if (page === '...') {
                return <span key={index} className="px-2 text-zinc-400">...</span>;
              }
              return (
                <button 
                  key={index} 
                  onClick={() => setCurrentPage(page)}
                  className={`w-8 h-8 flex items-center justify-center rounded-lg ${currentPage === page ? 'bg-[#c26027] text-white font-bold' : 'hover:bg-zinc-100'}`}
                >
                  {page}
                </button>
              );
            });
          })()}

          <button 
            disabled={currentPage === totalPages}
            onClick={() => setCurrentPage(p => p + 1)}
            className="p-1 px-2 hover:bg-zinc-100 rounded disabled:opacity-50"
          >
            &gt;
          </button>
        </div>
      </div>
    </div>
  );
}