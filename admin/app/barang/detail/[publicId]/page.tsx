"use client";
import { useState, useEffect } from "react";
import { useParams, useRouter } from "next/navigation";
import Link from "next/link";
import { ArrowLeft, Edit2, Package, Barcode, Layers, Tag, Coins, Info, Loader2, Percent } from "lucide-react"; 

export default function DetailBarangPage() {
  const params = useParams();
  const router = useRouter();
  
  // 🚀 1. FIX: Tangkap sesuai nama folder [publicId]
  const publicId = params.publicId; 

  // STATE DETAIL DATA FROM DB GOLANG
  const [barang, setBarang] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [errorMsg, setErrorMsg] = useState("");

  // 🚀 2. FIX: Fetch data menggunakan publicId ke endpoint detail yang bener
  useEffect(() => {
    if (!publicId) return;

    const fetchDetailBarang = async () => {
      try {
        const res = await fetch(`/api/v1/admin/barang/detail/${publicId}`);
        const json = await res.json();
        
        if (res.ok && json.data) {
          setBarang(json.data); // Data riil Postman masuk ke sini
        } else {
          setErrorMsg("Gagal memuat detail produk dari database.");
        }
      } catch (err) {
        console.error("Fetch detail error:", err);
        setErrorMsg("Gagal terhubung ke server. Pastikan backend Golang aktif!");
      } finally {
        setLoading(false);
      }
    };

    fetchDetailBarang();
  }, [publicId]);

  // 💸 HELPER FORMAT RUPIAH
  const formatRupiah = (angka: number) => {
    if (!angka) return "Rp 0";
    return new Intl.NumberFormat("id-ID", {
      style: "currency",
      currency: "IDR",
      minimumFractionDigits: 0,
    }).format(angka);
  };

  // LOADING STATE ANIMATION
  if (loading) {
    return (
      <div className="w-full h-96 flex flex-col items-center justify-center text-zinc-400 gap-3">
        <Loader2 className="animate-spin text-[#AF520C]" size={40} />
        <p className="font-bold text-sm text-zinc-700">Mengambil data produk Mantra...</p>
      </div>
    );
  }

  // ERROR BOX STATE
  if (errorMsg || !barang) {
    return (
      <div className="w-full">
        <div className="mb-6 p-4 bg-red-50 border border-red-200 text-red-600 rounded-xl text-sm font-semibold">
          ⚠️ {errorMsg || "Data produk tidak ditemukan."}
        </div>
        <Link href="/barang" className="inline-flex items-center gap-2 text-sm font-bold text-[#AF520C] hover:underline">
          <ArrowLeft size={16} /> Kembali ke Daftar Barang
        </Link>
      </div>
    );
  }

  return (
    <div className="w-full pb-12">
      
      {/* Header Halaman */}
      <div className="flex justify-between items-end mb-8">
        <div>
          <div className="flex items-center gap-2 text-sm text-zinc-500 font-medium mb-2">
            <Link href="/barang" className="hover:text-[#AF520C] transition">Barang</Link>
            <span className="text-zinc-300">/</span>
            <span className="text-[#AF520C]">Detail Produk</span>
          </div>
          <h1 className="text-3xl font-bold text-zinc-900 capitalize">{barang.nama_barang}</h1>
        </div>
        
        <div className="flex items-center gap-3">
          <Link href="/barang" className="px-5 py-2.5 bg-white border border-zinc-200 text-zinc-600 rounded-lg text-sm font-bold hover:bg-zinc-50 transition shadow-sm flex items-center gap-2">
            <ArrowLeft size={16} /> Kembali
          </Link>
          <Link href={`/barang/edit/${publicId}`} className="px-5 py-2.5 bg-[#AF520C] text-white rounded-lg text-sm font-bold hover:bg-[#8e4209] transition shadow-sm flex items-center gap-2">
            <Edit2 size={16} /> Edit Produk
          </Link>
        </div>
      </div>

      {/* GRID KONTEN UTAMA */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        
        {/* KOLOM KIRI: Informasi Utama & Varian */}
        <div className="lg:col-span-2 flex flex-col gap-6">
          
          {/* INFORMASI DASAR */}
          <div className="bg-white p-6 rounded-xl border border-zinc-200 shadow-sm">
            <h2 className="text-base font-bold text-zinc-800 mb-6 flex items-center gap-2 border-b border-zinc-100 pb-3">
              <Info size={18} className="text-[#AF520C]" />
              Informasi Dasar Produk
            </h2>
            
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
              <div>
                <span className="text-xs font-bold text-zinc-400 block mb-1 uppercase tracking-wider">Nama Barang</span>
                <p className="text-sm font-semibold text-zinc-800 bg-zinc-50 p-3 rounded-lg border border-zinc-100">{barang.nama_barang}</p>
              </div>
              
              <div>
                <span className="text-xs font-bold text-zinc-400 block mb-1 uppercase tracking-wider">Kategori</span>
                <p className="text-sm font-semibold text-zinc-800 bg-zinc-50 p-3 rounded-lg border border-zinc-100 flex items-center gap-1.5 capitalize">
                  <Tag size={16} className="text-zinc-400" />
                  {barang.kategori || "Tanpa Kategori"}
                </p>
              </div>

              <div>
                <span className="text-xs font-bold text-zinc-400 block mb-1 uppercase tracking-wider">Satuan Dasar</span>
                <p className="text-sm font-semibold text-zinc-800 bg-zinc-50 p-3 rounded-lg border border-zinc-100 flex items-center gap-1.5">
                  <Layers size={16} className="text-zinc-400" />
                  {barang.satuan || "Pcs"}
                </p>
              </div>

              {/* TAMPILAN DISKON AKTIF (JIKA ADA) */}
              {barang.diskon && (
                <div>
                  <span className="text-xs font-bold text-red-500 block mb-1 uppercase tracking-wider">Promo Diskon Aktif</span>
                  <p className="text-sm font-bold text-red-600 bg-red-50 p-3 rounded-lg border border-red-100 flex items-center gap-1.5">
                    <Percent size={16} />
                    {barang.diskon.nama_diskon} ({barang.diskon.besar_diskon}%)
                  </p>
                </div>
              )}
            </div>

            <div>
              <span className="text-xs font-bold text-zinc-400 block mb-1 uppercase tracking-wider">Deskripsi Produk</span>
              <div className="text-sm text-zinc-600 bg-zinc-50 p-3 rounded-lg border border-zinc-100 min-h-25 whitespace-pre-line">
                {barang.deskripsi || "Tidak ada deskripsi untuk produk ini."}
              </div>
            </div>
          </div>

          {/* 🚀 3. FIX: PEMETAAN VARIAN (Disesuaikan dengan key 'varian' dari Golang) */}
          <div className="bg-white p-6 rounded-xl border border-zinc-200 shadow-sm">
            <h2 className="text-base font-bold text-zinc-800 mb-6 flex items-center gap-2 border-b border-zinc-100 pb-3">
              <Package size={18} className="text-[#AF520C]" />
              Daftar Spesifikasi Varian Produk
            </h2>

            <div className="flex flex-col gap-6">
              {barang.varian && barang.varian.length > 0 ? (
                barang.varian.map((item: any, index: number) => (
                  <div key={item.id_spesifikasi_barang || index} className="border border-zinc-200 rounded-xl overflow-hidden bg-white shadow-sm">
                    
                    {/* Info Varian */}
                    <div className="p-5 bg-zinc-50/50">
                      <div className="flex justify-between items-center mb-4">
                        <span className="text-xs font-extrabold text-[#AF520C] bg-orange-50 px-3 py-1 rounded-full uppercase tracking-wide">
                          Varian #{index + 1}
                        </span>
                        <div className="flex gap-4 text-xs font-semibold text-zinc-500">
                          <span>Stok: <strong className="text-zinc-800">{item.stok || 0}</strong></span>
                        </div>
                      </div>

                      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                        <div>
                          <span className="text-[10px] font-bold text-zinc-400 uppercase tracking-wider block mb-1">Nama Atribut</span>
                          <p className="text-sm font-bold text-zinc-800 capitalize">{item.nama_spesifikasi || "-"}</p>
                        </div>
                        <div>
                          <span className="text-[10px] font-bold text-zinc-400 uppercase tracking-wider block mb-1">Nilai Atribut</span>
                          <p className="text-sm font-medium text-zinc-700 capitalize">{item.nama_detail || "-"}</p>
                        </div>
                        <div>
                          <span className="text-[10px] font-bold text-zinc-400 uppercase tracking-wider block mb-1">Stok Fisik</span>
                          <p className="text-sm font-bold text-zinc-800">{item.stok || 0} {barang.satuan || "Pcs"}</p>
                        </div>
                        <div>
                          <span className="text-[10px] font-bold text-zinc-400 uppercase tracking-wider block mb-1">Harga Jual</span>
                          <div className="text-sm">
                            {barang.diskon ? (
                              <>
                                <p className="font-extrabold text-green-600">{formatRupiah(item.harga_diskon)}</p>
                                <p className="text-[10px] text-zinc-400 line-through">{formatRupiah(item.harga_barang)}</p>
                              </>
                            ) : (
                              <p className="font-extrabold text-zinc-800">{formatRupiah(item.harga_barang)}</p>
                            )}
                          </div>
                        </div>
                      </div>
                    </div>
                    
                    {/* Daftar Barcode per Varian */}
                    <div className="p-4 border-t border-zinc-100 bg-white">
                      <span className="text-xs font-bold text-zinc-500 mb-3 flex items-center gap-1.5 uppercase tracking-wider">
                        <Barcode size={14} className="text-[#AF520C]" /> Daftar Barcode
                      </span>
                      {item.barcodes && item.barcodes.length > 0 ? (
                        <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                          {item.barcodes.map((bc: any, bIdx: number) => (
                            <div key={bIdx} className="flex justify-between items-center bg-zinc-50 border border-zinc-200 rounded-lg p-3">
                              <div className="flex items-center gap-2">
                                <div className="p-1.5 bg-white rounded border border-zinc-200 shadow-sm">
                                  <Barcode size={16} className="text-zinc-700" />
                                </div>
                                <span className="font-mono text-sm font-bold text-zinc-800 tracking-wider">
                                  {bc.id_barcode}
                                </span>
                              </div>
                              <div className="text-xs font-semibold text-zinc-500 bg-white px-2 py-1 rounded border border-zinc-200">
                                Isi: <span className="text-zinc-800 font-bold">{bc.kuantitas}</span>
                              </div>
                            </div>
                          ))}
                        </div>
                      ) : (
                        <p className="text-xs text-zinc-400 italic">Belum ada barcode terdaftar untuk varian ini.</p>
                      )}
                    </div>

                  </div>
                ))
              ) : (
                <div className="text-center p-6 text-zinc-400 text-sm border border-dashed border-zinc-200 rounded-xl">
                  Tidak ada spesifikasi varian terdaftar.
                </div>
              )}
            </div>
          </div>

        </div>

        {/* KOLOM KANAN: Media Gambar Produk */}
        <div className="lg:col-span-1">
          <div className="bg-white p-6 rounded-xl border border-zinc-200 shadow-sm sticky top-6">
            <h2 className="text-base font-bold text-zinc-800 mb-4">Media Foto Produk</h2>
            <div className="w-full aspect-square bg-zinc-50 border border-zinc-200 rounded-xl overflow-hidden flex items-center justify-center relative shadow-inner group">
              {barang.gambar_barang ? (
                <img 
                  src={barang.gambar_barang} 
                  alt={barang.nama_barang} 
                  className="w-full h-full object-cover transition-transform duration-300 group-hover:scale-105"
                />
              ) : (
                <div className="text-center text-zinc-400 p-6 flex flex-col items-center gap-2">
                  <Package size={40} className="text-zinc-300" />
                  <p className="text-xs font-semibold">Tidak ada foto produk</p>
                </div>
              )}
            </div>
            
            {/* STATS SINGKAT */}
            <div className="mt-6 border-t border-zinc-100 pt-4 flex flex-col gap-3 text-xs text-zinc-500 font-medium">
              <div className="flex justify-between">
                <span>ID Internal Database:</span>
                <span className="text-zinc-800 font-mono font-bold">#MTR-{barang.id_barang}</span>
              </div>
              <div className="flex justify-between">
                <span>Total Varian Aktif:</span>
                <span className="text-zinc-800 font-bold">{barang.varian?.length || 0} Varian</span>
              </div>
            </div>
          </div>
        </div>

      </div>

    </div>
  );
}