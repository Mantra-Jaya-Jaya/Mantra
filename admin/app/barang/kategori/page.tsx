"use client";
import { useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { CloudUpload, ChevronRight, Tags, Trash2, Info } from "lucide-react";

export default function TambahKategoriPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(false);
  
  // Data kategori (Deskripsi udah dihapus dari database dummy)
  const [existingKategori] = useState([
    { id: 1, nama: "Alat Tulis", icon: "https://ui-avatars.com/api/?name=AT&background=AF520C&color=fff&rounded=true" },
    { id: 2, nama: "Kertas & Buku", icon: "https://ui-avatars.com/api/?name=KB&background=18181b&color=fff&rounded=true" },
    { id: 3, nama: "Aksesoris Komputer", icon: "https://ui-avatars.com/api/?name=AK&background=18181b&color=fff&rounded=true" }
  ]);

  const handleSimpan = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    setLoading(true);
    // Simulasi API
    setTimeout(() => {
      router.push("/barang");
    }, 1000);
  };

  return (
    <div className="w-full pb-12">
      {/* HEADER */}
      <div className="flex justify-between items-end mb-8">
        <div>
          <h1 className="text-3xl font-bold text-zinc-900 mb-2">Kelola Kategori</h1>
          <div className="flex items-center gap-2 text-sm text-zinc-500 font-medium">
            <Link href="/barang" className="hover:text-[#AF520C] transition">Barang</Link>
            <ChevronRight size={14} />
            <span className="text-[#AF520C]">Kategori</span>
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        
        {/* KIRI: FORM TAMBAH KATEGORI */}
        <div className="lg:col-span-2">
          <div className="bg-white p-6 rounded-xl border border-zinc-200 shadow-sm">
            <h2 className="text-lg font-bold text-zinc-800 mb-6 flex items-center gap-2">
              <Tags size={20} className="text-[#AF520C]" />
              Tambah Kategori Baru
            </h2>

            <form onSubmit={handleSimpan} className="flex flex-col gap-6">
              
              {/* Layout Form Baru: Kiri Upload, Kanan Input & Tips */}
              <div className="grid grid-cols-1 md:grid-cols-5 gap-6">
                
                {/* Bagian Upload Ikon (Porsi lebih kecil) */}
                <div className="md:col-span-2">
                  <label className="text-sm font-bold text-zinc-600 mb-2 block">Ikon Kategori</label>
                  <div className="w-full h-36 border-2 border-dashed border-zinc-300 rounded-xl flex flex-col items-center justify-center text-center hover:bg-zinc-50 transition cursor-pointer">
                    <div className="w-10 h-10 bg-orange-50 text-[#AF520C] rounded-full flex items-center justify-center mb-2">
                      <CloudUpload size={20} />
                    </div>
                    <p className="font-bold text-zinc-700 text-xs mb-1">Unggah Ikon</p>
                    <p className="text-[10px] text-zinc-400">PNG Transparan (512px)</p>
                  </div>
                </div>

                {/* Bagian Input Nama & Kotak Tips biar nggak kosong */}
                <div className="md:col-span-3 flex flex-col justify-between">
                  <div>
                    <label className="text-sm font-bold text-zinc-600 mb-2 block">Nama Kategori</label>
                    <input type="text" required placeholder="Cth: Kertas & Buku" className="w-full border border-zinc-200 rounded-lg p-3 text-sm focus:outline-none focus:border-[#AF520C]" />
                  </div>

                  {/* Kotak Estetik Pengisi Kekosongan */}
                  <div className="mt-4 p-3.5 bg-orange-50/50 border border-[#AF520C]/20 rounded-lg flex gap-3 items-start">
                    <Info size={16} className="text-[#AF520C] mt-0.5 shrink-0" />
                    <div>
                      <h3 className="text-xs font-bold text-zinc-800 mb-1">Panduan Kategori</h3>
                      <p className="text-[11px] text-zinc-600 leading-relaxed">
                        Gunakan nama yang singkat dan padat. Jika Anda melakukan kesalahan penamaan, silakan hapus kategori di panel kanan dan buat ulang.
                      </p>
                    </div>
                  </div>
                </div>

              </div>

              {/* Tombol Aksi */}
              <div className="flex justify-end gap-3 mt-2 pt-6 border-t border-zinc-100">
                <Link href="/barang" className="px-6 py-2.5 bg-zinc-50 border border-zinc-200 text-zinc-600 rounded-lg text-sm font-bold hover:bg-zinc-100 transition">
                  Batal
                </Link>
                <button type="submit" disabled={loading} className="px-6 py-2.5 bg-[#AF520C] text-white rounded-lg text-sm font-bold hover:bg-[#8e4209] transition shadow-sm disabled:opacity-50">
                  {loading ? "Menyimpan..." : "Simpan Kategori"}
                </button>
              </div>
            </form>
          </div>
        </div>

        {/* KANAN: LIST KATEGORI TERSEDIA */}
        <div className="lg:col-span-1">
          <div className="bg-white p-6 rounded-xl border border-zinc-200 shadow-sm h-full flex flex-col">
            <h2 className="text-lg font-bold text-zinc-800 mb-6">Kategori Tersedia</h2>
            
            <div className="flex flex-col gap-3 flex-1">
              {existingKategori.map((item) => (
                <div key={item.id} className="flex items-center justify-between p-3.5 border border-zinc-100 rounded-lg hover:border-red-200 hover:bg-red-50/30 transition group">
                  <div className="flex items-center gap-3">
                    <img src={item.icon} alt={item.nama} className="w-9 h-9 rounded-lg shadow-sm" />
                    {/* Teks Deskripsi udah lenyap, sisa nama aja biar clean */}
                    <p className="font-bold text-zinc-800 text-sm">{item.nama}</p>
                  </div>
                  
                  {/* Tombol Edit dihanguskan, sisa tombol Hapus warna merah */}
                  <div className="opacity-0 group-hover:opacity-100 transition-opacity">
                    <button className="text-zinc-400 hover:text-red-500 bg-white p-1.5 rounded-md shadow-sm border border-zinc-100 hover:border-red-200 transition-all">
                      <Trash2 size={16} />
                    </button>
                  </div>
                </div>
              ))}
            </div>

            <div className="mt-6 p-4 bg-zinc-50 rounded-lg border border-zinc-100 text-center">
              <p className="text-xs text-zinc-500 leading-relaxed">
                Menghapus kategori akan memindahkan semua barang di dalamnya menjadi status <span className="font-bold text-zinc-700">Uncategorized</span>.
              </p>
            </div>
          </div>
        </div>

      </div>
    </div>
  );
}