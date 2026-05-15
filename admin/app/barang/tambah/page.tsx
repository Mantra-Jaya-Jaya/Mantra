"use client";
import { useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { CloudUpload, ScanLine, Trash2, Plus, ChevronRight, ChevronDown } from "lucide-react"; // Tambah ChevronDown

export default function TambahBarangPage() {
  const router = useRouter();
  
  // 1. STATE UNTUK FORM
  const [media, setMedia] = useState(null);
  const [info, setInfo] = useState({ nama: "", hargaBeli: "", kategori: "", satuan: "", deskripsi: "" });
  
  const [barcodes, setBarcodes] = useState([{ id: 1, manual: "", qty: "" }]);
  const [spesifikasi, setSpesifikasi] = useState([{ id: 1, atribut: "", nilai: "", stok: "", hargaJual: "" }]);

  const [loading, setLoading] = useState(false);
  const [errorMsg, setErrorMsg] = useState("");

  // --- FUNGSI FORMAT RUPIAH OTOMATIS ---
  // Fungsi ini ngasih titik otomatis pas diketik, tapi buang huruf/simbol lain
  const formatRupiah = (value) => {
    if (!value) return "";
    const angkaMurni = value.toString().replace(/\D/g, ""); // Buang semua selain angka
    if (!angkaMurni) return "";
    return new Intl.NumberFormat('id-ID').format(angkaMurni); // Format gaya Indonesia (1.000)
  };

  // --- FUNGSI DINAMIS BARCODE ---
  const addBarcodeRow = () => setBarcodes([...barcodes, { id: Date.now(), manual: "", qty: "" }]);
  const updateBarcode = (id, field, value) => {
    setBarcodes(barcodes.map(b => b.id === id ? { ...b, [field]: value } : b));
  };

  // --- FUNGSI DINAMIS SPESIFIKASI ---
  const addSpesifikasiRow = () => setSpesifikasi([...spesifikasi, { id: Date.now(), atribut: "", nilai: "", stok: "", hargaJual: "" }]);
  const removeSpesifikasiRow = (id) => setSpesifikasi(spesifikasi.filter(s => s.id !== id));
  const updateSpesifikasi = (id, field, value) => {
    setSpesifikasi(spesifikasi.map(s => s.id === id ? { ...s, [field]: value } : s));
  };

  // --- LOGIKA VALIDASI & SIMPAN API ---
  const handleSimpan = async () => {
    setErrorMsg("");

    if (!info.nama || !info.hargaBeli || !info.kategori || !info.satuan) {
      return setErrorMsg("Semua kolom Informasi Barang wajib diisi (kecuali deskripsi).");
    }

    const spekValid = spesifikasi.every(s => s.atribut && s.nilai && s.stok && s.hargaJual);
    if (!spekValid || spesifikasi.length === 0) {
      return setErrorMsg("Lengkapi semua kolom pada Spesifikasi Barang.");
    }

    setLoading(true);

    try {
      // Data siap dikirim ke API Golang (Angkanya tetep murni ya bro, nggak ada titiknya pas dikirim)
      const payload = {
        media: media,
        informasi_barang: info,
        barcode: barcodes,
        spesifikasi: spesifikasi
      };

      console.log("Data siap dikirim ke API:", payload);

      setTimeout(() => {
        router.push("/barang");
      }, 1000);

    } catch (error) {
      setErrorMsg("Terjadi kesalahan saat menyimpan data.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="w-full pb-12"> 
      {/* ☝️ max-w-[1200px] dan mx-auto Kak Gem hapus biar marginnya sama kayak halaman sebelumnya */}
      
      {/* HEADER & BREADCRUMB */}
      <div className="flex justify-between items-end mb-8">
        <div>
          <h1 className="text-3xl font-bold text-zinc-900 mb-2">Tambah Barang Baru</h1>
          <div className="flex items-center gap-2 text-sm text-zinc-500 font-medium">
            <Link href="/barang" className="hover:text-[#AF520C] transition">Barang</Link>
            <ChevronRight size={14} />
            <span className="text-[#AF520C]">Tambah Barang</span>
          </div>
        </div>
        
        <div className="flex items-center gap-3">
          <Link href="/barang" className="px-6 py-2.5 bg-white border border-zinc-200 text-zinc-600 rounded-lg text-sm font-bold hover:bg-zinc-50 transition shadow-sm">
            Batal
          </Link>
          <button 
            onClick={handleSimpan}
            disabled={loading}
            className="px-6 py-2.5 bg-[#AF520C] text-white rounded-lg text-sm font-bold hover:bg-[#8e4209] transition shadow-sm disabled:opacity-50"
          >
            {loading ? "Menyimpan..." : "Simpan Perubahan"}
          </button>
        </div>
      </div>

      {/* ERROR MESSAGE BAR */}
      {errorMsg && (
        <div className="mb-6 p-4 bg-red-50 border border-red-200 text-red-600 rounded-lg text-sm font-semibold">
          ⚠️ {errorMsg}
        </div>
      )}

      {/* GRID ATAS: MEDIA & BARCODE */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-6">
        
        {/* MEDIA PRODUK (Kiri) */}
        <div className="bg-white p-6 rounded-xl border border-zinc-200 shadow-sm lg:col-span-2">
          <h2 className="text-lg font-bold text-zinc-800 mb-4">Media Produk</h2>
          <div className="w-full border-2 border-dashed border-zinc-300 rounded-xl p-12 flex flex-col items-center justify-center text-center hover:bg-zinc-50 transition cursor-pointer">
            <div className="w-12 h-12 bg-orange-50 text-[#AF520C] rounded-full flex items-center justify-center mb-4">
              <CloudUpload size={24} />
            </div>
            <p className="font-bold text-zinc-700 mb-1">Unggah Foto Produk</p>
            <p className="text-sm text-zinc-400 max-w-xs">Tarik dan lepas gambar di sini, atau klik untuk memilih file. Gunakan format JPG, PNG (Maks. 5MB).</p>
          </div>
        </div>

        {/* SCAN BARCODE (Kanan) */}
        <div className="bg-white p-6 rounded-xl border border-zinc-200 shadow-sm lg:col-span-1">
          <div className="flex justify-between items-center mb-4">
            <h2 className="text-lg font-bold text-zinc-800">Scan Barcode</h2>
            <button onClick={addBarcodeRow} className="text-[#AF520C] text-xs font-bold flex items-center gap-1 hover:underline">
              <Plus size={14} /> Tambah Atribut
            </button>
          </div>

          <div className="flex flex-col gap-4 mb-6">
            {barcodes.map((item, index) => (
              <div key={item.id} className="flex gap-4">
                <div className="flex-1">
                  {index === 0 && <label className="text-xs font-bold text-zinc-600 mb-2 block">Barcode manual</label>}
                  <input type="text" className="w-full border border-zinc-200 rounded-lg p-2.5 text-sm focus:outline-none focus:border-[#AF520C]" 
                    value={item.manual} onChange={(e) => updateBarcode(item.id, "manual", e.target.value)} />
                </div>
                <div className="w-1/3">
                  {index === 0 && <label className="text-xs font-bold text-zinc-600 mb-2 block">Kuantitas</label>}
                  <input type="number" className="w-full border border-zinc-200 rounded-lg p-2.5 text-sm focus:outline-none focus:border-[#AF520C]" 
                    value={item.qty} onChange={(e) => updateBarcode(item.id, "qty", e.target.value)} />
                </div>
              </div>
            ))}
          </div>

          <div className="flex items-center gap-4 mb-6">
            <div className="h-px bg-zinc-200 flex-1"></div>
            <span className="text-xs font-bold text-zinc-400">ATAU</span>
            <div className="h-px bg-zinc-200 flex-1"></div>
          </div>

          <button className="w-full py-3 border-2 border-dashed border-[#AF520C] text-[#AF520C] rounded-lg font-bold text-sm flex items-center justify-center gap-2 hover:bg-orange-50 transition">
            <ScanLine size={18} /> Scan dengan Kamera
          </button>
        </div>
      </div>

      {/* TENGAH: INFORMASI BARANG */}
      <div className="bg-white p-6 rounded-xl border border-zinc-200 shadow-sm mb-6">
        <h2 className="text-lg font-bold text-zinc-800 mb-6">Informasi Barang</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
          <div>
            <label className="text-sm font-bold text-zinc-600 mb-2 block">Nama barang</label>
            <input type="text" placeholder="Masukkan nama barang" className="w-full border border-zinc-200 rounded-lg p-3 text-sm focus:outline-none focus:border-[#AF520C]" 
              value={info.nama} onChange={(e) => setInfo({ ...info, nama: e.target.value })} />
          </div>
          
          {/* UANG TOTAL HARGA BELI - Otomatis Format */}
          <div>
            <label className="text-sm font-bold text-zinc-600 mb-2 block">Total Harga Beli</label>
            <div className="relative">
              <span className="absolute left-3 top-1/2 -translate-y-1/2 text-zinc-500 text-sm">Rp</span>
              <input 
                type="text" // Diganti type text biar titiknya jalan
                placeholder="0" 
                className="w-full border border-zinc-200 rounded-lg p-3 pl-10 text-sm focus:outline-none focus:border-[#AF520C]" 
                value={formatRupiah(info.hargaBeli)} 
                onChange={(e) => setInfo({ ...info, hargaBeli: e.target.value.replace(/\D/g, "") })} 
              />
            </div>
          </div>

          {/* DROPDOWN KATEGORI */}
          <div>
            <label className="text-sm font-bold text-zinc-600 mb-2 block">Kategori</label>
            <div className="relative">
              <select className="w-full border border-zinc-200 rounded-lg p-3 pr-10 text-sm focus:outline-none focus:border-[#AF520C] appearance-none bg-white cursor-pointer"
                value={info.kategori} onChange={(e) => setInfo({ ...info, kategori: e.target.value })}>
                <option value="" disabled>Pilih kategori</option>
                <option value="Gadget">Gadget</option>
                <option value="Aksesoris">Aksesoris</option>
              </select>
              <ChevronDown className="absolute right-3 top-1/2 -translate-y-1/2 text-zinc-400 pointer-events-none" size={18} />
            </div>
          </div>

          {/* DROPDOWN SATUAN */}
          <div>
            <label className="text-sm font-bold text-zinc-600 mb-2 block">Satuan</label>
            <div className="relative">
              <select className="w-full border border-zinc-200 rounded-lg p-3 pr-10 text-sm focus:outline-none focus:border-[#AF520C] appearance-none bg-white cursor-pointer"
                value={info.satuan} onChange={(e) => setInfo({ ...info, satuan: e.target.value })}>
                <option value="" disabled>Pilih satuan</option>
                <option value="Pcs">Pcs</option>
                <option value="Box">Box</option>
              </select>
              <ChevronDown className="absolute right-3 top-1/2 -translate-y-1/2 text-zinc-400 pointer-events-none" size={18} />
            </div>
          </div>
        </div>

        <div>
          <label className="text-sm font-bold text-zinc-600 mb-2 block">Deskripsi (Opsional)</label>
          <textarea rows={4} placeholder="Tuliskan deskripsi lengkap barang..." className="w-full border border-zinc-200 rounded-lg p-3 text-sm focus:outline-none focus:border-[#AF520C] resize-none"
            value={info.deskripsi} onChange={(e) => setInfo({ ...info, deskripsi: e.target.value })}></textarea>
        </div>
      </div>

      {/* BAWAH: SPESIFIKASI BARANG */}
      <div className="bg-white p-6 rounded-xl border border-zinc-200 shadow-sm">
        <div className="flex justify-between items-center mb-6">
          <h2 className="text-lg font-bold text-zinc-800">Spesifikasi barang</h2>
          <button onClick={addSpesifikasiRow} className="text-[#AF520C] text-sm font-bold flex items-center gap-1 hover:underline">
            <Plus size={16} /> Tambah Atribut
          </button>
        </div>

        <div className="flex flex-col gap-4">
          {spesifikasi.map((item) => (
            <div key={item.id} className="flex flex-col md:flex-row gap-4 items-center">
              <input type="text" placeholder="Nama Atribut (Merek, Warna, dll)" className="flex-1 w-full border border-zinc-200 rounded-lg p-3 text-sm focus:outline-none focus:border-[#AF520C]"
                value={item.atribut} onChange={(e) => updateSpesifikasi(item.id, "atribut", e.target.value)} />
              
              <input type="text" placeholder="Nilai (Samsung, Merah, dll)" className="flex-1 w-full border border-zinc-200 rounded-lg p-3 text-sm focus:outline-none focus:border-[#AF520C]"
                value={item.nilai} onChange={(e) => updateSpesifikasi(item.id, "nilai", e.target.value)} />
              
              <input type="number" placeholder="Stok Barang" className="w-full md:w-32 border border-zinc-200 rounded-lg p-3 text-sm focus:outline-none focus:border-[#AF520C]"
                value={item.stok} onChange={(e) => updateSpesifikasi(item.id, "stok", e.target.value)} />
              
              {/* UANG HARGA JUAL - Otomatis Format */}
              <input 
                type="text" 
                placeholder="Harga Jual" 
                className="w-full md:w-48 border border-zinc-200 rounded-lg p-3 text-sm focus:outline-none focus:border-[#AF520C]"
                value={formatRupiah(item.hargaJual)} 
                onChange={(e) => updateSpesifikasi(item.id, "hargaJual", e.target.value.replace(/\D/g, ""))} 
              />
              
              {spesifikasi.length > 1 && (
                <button onClick={() => removeSpesifikasiRow(item.id)} className="p-3 text-red-500 hover:bg-red-50 rounded-lg transition">
                  <Trash2 size={20} />
                </button>
              )}
            </div>
          ))}
        </div>
      </div>

    </div>
  );
}