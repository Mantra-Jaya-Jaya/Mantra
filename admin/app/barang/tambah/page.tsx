"use client";
import { useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { CloudUpload, ScanLine, Trash2, Plus, ChevronRight, ChevronDown, Package, Barcode, Loader2 } from "lucide-react"; 

export default function TambahBarangPage() {
  const router = useRouter();
  
  // STATE INFORMASI DASAR
  const [media, setMedia] = useState(""); // Ubah dari null ke string kosong
  const [info, setInfo] = useState({ nama: "", hargaBeli: "", kategori: "", satuan: "", deskripsi: "" });
  
  // STATE SPESIFIKASI 
  const [spesifikasi, setSpesifikasi] = useState([
    { 
      id: 1, 
      atribut: "", 
      nilai: "", 
      stok: "", 
      hargaJual: "", 
      barcodes: [{ b_id: 101, code: "", qty: "" }] 
    }
  ]);

  const [loading, setLoading] = useState(false);
  const [errorMsg, setErrorMsg] = useState("");

  const formatRupiah = (value: any) => {
    if (!value) return "";
    const angkaMurni = value.toString().replace(/\D/g, "");
    if (!angkaMurni) return "";
    return new Intl.NumberFormat('id-ID').format(angkaMurni);
  };

  // --- HANDLER SPESIFIKASI (VARIAN INDUK) ---
  const addSpesifikasiRow = () => {
    setSpesifikasi([...spesifikasi, { 
      id: Date.now(), atribut: "", nilai: "", stok: "", hargaJual: "", 
      barcodes: [{ b_id: Date.now() + 1, code: "", qty: "" }] 
    }]);
  };
  const removeSpesifikasiRow = (id: number) => setSpesifikasi(spesifikasi.filter(s => s.id !== id));
  const updateSpesifikasi = (id: number, field: string, value: any) => {
    setSpesifikasi(spesifikasi.map(s => s.id === id ? { ...s, [field]: value } : s));
  };

  // --- HANDLER BARCODE (SUB-VARIAN) ---
  const addBarcodeToSpesifikasi = (spekId: number) => {
    setSpesifikasi(spesifikasi.map(s => {
      if (s.id === spekId) {
        return { ...s, barcodes: [...s.barcodes, { b_id: Date.now(), code: "", qty: "" }] };
      }
      return s;
    }));
  };
  
  const removeBarcodeFromSpesifikasi = (spekId: number, barcodeId: number) => {
    setSpesifikasi(spesifikasi.map(s => {
      if (s.id === spekId) {
        return { ...s, barcodes: s.barcodes.filter(b => b.b_id !== barcodeId) };
      }
      return s;
    }));
  };
  
  const updateBarcodeInSpek = (spekId: number, barcodeId: number, field: string, value: any) => {
    setSpesifikasi(spesifikasi.map(s => {
      if (s.id === spekId) {
        return {
          ...s,
          barcodes: s.barcodes.map(b => b.b_id === barcodeId ? { ...b, [field]: value } : b)
        };
      }
      return s;
    }));
  };

  // --- 🚀 LOGIKA SIMPAN API KE GOLANG ---
  const handleSimpan = async () => {
    setErrorMsg("");

    // Validasi Frontend
    if (!info.nama || !info.hargaBeli || !info.kategori || !info.satuan) {
      return setErrorMsg("Semua kolom Informasi Barang wajib diisi (kecuali deskripsi).");
    }

    setLoading(true);

    try {
      // Pastikan format data 100% sama dengan struct di Golang
      const payload = {
        media: media,
        informasi_barang: {
          nama: info.nama,
          hargaBeli: info.hargaBeli,
          kategori: info.kategori,
          satuan: info.satuan,
          deskripsi: info.deskripsi
        },
        spesifikasi: spesifikasi.map(spek => ({
          atribut: spek.atribut,
          nilai: spek.nilai,
          stok: spek.stok.toString(), // Pastikan string biar Golang nggak nangis
          hargaJual: spek.hargaJual.toString(),
          barcodes: spek.barcodes.map(bc => ({
            code: bc.code,
            qty: bc.qty.toString()
          }))
        }))
      };

      const res = await fetch("/api/v1/admin/barang", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(payload),
      });

      const json = await res.json();

      if (!res.ok) {
        throw new Error(json.message || "Gagal menyimpan data barang.");
      }

      // Kalau sukses, lempar admin balik ke halaman daftar barang
      router.push("/barang");

    } catch (error: any) {
      console.error("Save error:", error);
      setErrorMsg(error.message || "Terjadi kesalahan saat menyimpan data.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="w-full pb-12"> 
      
      {/* Header Halaman */}
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
            onClick={handleSimpan} disabled={loading}
            className="px-6 py-2.5 bg-[#AF520C] text-white rounded-lg text-sm font-bold hover:bg-[#8e4209] transition shadow-sm flex items-center gap-2 disabled:opacity-50"
          >
            {loading ? <><Loader2 className="animate-spin" size={16} /> Menyimpan...</> : "Simpan Perubahan"}
          </button>
        </div>
      </div>

      {errorMsg && (
        <div className="mb-6 p-4 bg-red-50 border border-red-200 text-red-600 rounded-lg text-sm font-semibold">
          ⚠️ {errorMsg}
        </div>
      )}

      {/* MEDIA PRODUK */}
      <div className="bg-white p-6 rounded-xl border border-zinc-200 shadow-sm mb-6">
        <h2 className="text-lg font-bold text-zinc-800 mb-4">Media Produk</h2>
        <div className="w-full border-2 border-dashed border-zinc-300 rounded-xl p-12 flex flex-col items-center justify-center text-center hover:bg-zinc-50 transition cursor-pointer">
          <div className="w-12 h-12 bg-orange-50 text-[#AF520C] rounded-full flex items-center justify-center mb-4">
            <CloudUpload size={24} />
          </div>
          <p className="font-bold text-zinc-700 mb-1">Unggah Foto Produk</p>
          <p className="text-sm text-zinc-400 max-w-xs">Tarik dan lepas gambar di sini, atau klik untuk memilih file. Gunakan format JPG, PNG (Maks. 5MB).</p>
        </div>
      </div>

      {/* INFORMASI BARANG */}
      <div className="bg-white p-6 rounded-xl border border-zinc-200 shadow-sm mb-6">
        <h2 className="text-lg font-bold text-zinc-800 mb-6">Informasi Dasar Barang</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
          <div>
            <label className="text-sm font-bold text-zinc-600 mb-2 block">Nama barang</label>
            <input type="text" placeholder="Masukkan nama barang" className="w-full border border-zinc-200 rounded-lg p-3 text-sm focus:outline-none focus:border-[#AF520C]" 
              value={info.nama} onChange={(e) => setInfo({ ...info, nama: e.target.value })} />
          </div>
          
          <div>
            <label className="text-sm font-bold text-zinc-600 mb-2 block">Total Harga Beli (Modal Induk)</label>
            <div className="relative">
              <span className="absolute left-3 top-1/2 -translate-y-1/2 text-zinc-500 text-sm">Rp</span>
              <input type="text" placeholder="0" className="w-full border border-zinc-200 rounded-lg p-3 pl-10 text-sm focus:outline-none focus:border-[#AF520C]" 
                value={formatRupiah(info.hargaBeli)} onChange={(e) => setInfo({ ...info, hargaBeli: e.target.value.replace(/\D/g, "") })} />
            </div>
          </div>

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

          <div>
            <label className="text-sm font-bold text-zinc-600 mb-2 block">Satuan Dasar</label>
            <input type="text" placeholder="Pcs, Box, dll..." className="w-full border border-zinc-200 rounded-lg p-3 text-sm focus:outline-none focus:border-[#AF520C]"
              value={info.satuan} onChange={(e) => setInfo({ ...info, satuan: e.target.value })} />
          </div>
        </div>

        <div>
          <label className="text-sm font-bold text-zinc-600 mb-2 block">Deskripsi (Opsional)</label>
          <textarea rows={4} placeholder="Tuliskan deskripsi lengkap barang..." className="w-full border border-zinc-200 rounded-lg p-3 text-sm focus:outline-none focus:border-[#AF520C] resize-none"
            value={info.deskripsi} onChange={(e) => setInfo({ ...info, deskripsi: e.target.value })}></textarea>
        </div>
      </div>

      {/* SPESIFIKASI BARANG & BARCODE (UI BERTINGKAT) */}
      <div className="bg-white p-6 rounded-xl border border-zinc-200 shadow-sm">
        <div className="flex justify-between items-center mb-6">
          <h2 className="text-lg font-bold text-zinc-800 flex items-center gap-2">
            <Package size={20} className="text-[#AF520C]" />
            Spesifikasi & Relasi Barcode
          </h2>
          <button onClick={addSpesifikasiRow} className="px-4 py-2 bg-orange-50 text-[#AF520C] rounded-lg text-sm font-bold flex items-center gap-2 hover:bg-orange-100 transition">
            <Plus size={16} /> Tambah Varian
          </button>
        </div>

        <div className="flex flex-col gap-6">
          {spesifikasi.map((item, index) => (
            <div key={item.id} className="border border-zinc-200 rounded-xl overflow-hidden bg-white shadow-sm group">
              
              {/* BAGIAN ATAS: Info Varian (Putih) */}
              <div className="p-5 border-b border-zinc-200">
                <div className="flex justify-between items-center mb-4">
                  <h3 className="text-sm font-bold text-zinc-700 bg-zinc-100 px-3 py-1 rounded-full">Varian {index + 1}</h3>
                  {spesifikasi.length > 1 && (
                    <button onClick={() => removeSpesifikasiRow(item.id)} className="text-red-500 hover:text-red-700 transition flex items-center gap-1 text-xs font-bold">
                      <Trash2 size={14} /> Hapus Varian
                    </button>
                  )}
                </div>

                <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
                  <div>
                    <label className="text-xs font-bold text-zinc-600 mb-2 block">Nama Atribut</label>
                    <input type="text" placeholder="Cth: Ukuran / Rasa" className="w-full border border-zinc-200 rounded-lg p-2.5 text-sm focus:outline-none focus:border-[#AF520C]"
                      value={item.atribut} onChange={(e) => updateSpesifikasi(item.id, "atribut", e.target.value)} />
                  </div>
                  <div>
                    <label className="text-xs font-bold text-zinc-600 mb-2 block">Nilai Atribut</label>
                    <input type="text" placeholder="Cth: 100ml / Pedas" className="w-full border border-zinc-200 rounded-lg p-2.5 text-sm focus:outline-none focus:border-[#AF520C]"
                      value={item.nilai} onChange={(e) => updateSpesifikasi(item.id, "nilai", e.target.value)} />
                  </div>
                  <div>
                    <label className="text-xs font-bold text-zinc-600 mb-2 block">Total Stok Fisik</label>
                    <input type="number" placeholder="0" className="w-full border border-zinc-200 rounded-lg p-2.5 text-sm focus:outline-none focus:border-[#AF520C]"
                      value={item.stok} onChange={(e) => updateSpesifikasi(item.id, "stok", e.target.value)} />
                  </div>
                  <div>
                    <label className="text-xs font-bold text-zinc-600 mb-2 block">Harga Jual Dasar</label>
                    <div className="relative">
                      <span className="absolute left-3 top-1/2 -translate-y-1/2 text-zinc-500 text-xs font-semibold">Rp</span>
                      <input type="text" placeholder="0" className="w-full border border-zinc-200 rounded-lg p-2.5 pl-8 text-sm focus:outline-none focus:border-[#AF520C]"
                        value={formatRupiah(item.hargaJual)} onChange={(e) => updateSpesifikasi(item.id, "hargaJual", e.target.value.replace(/\D/g, ""))} />
                    </div>
                  </div>
                </div>
              </div>

              {/* BAGIAN BAWAH: Daftar Barcode (Abu-abu muda) */}
              <div className="p-5 bg-zinc-50">
                <div className="flex justify-between items-center mb-3">
                  <label className="text-xs font-bold text-zinc-600 flex items-center gap-1.5">
                    <Barcode size={14} /> Pemetaan Barcode & Kuantitas
                  </label>
                </div>
                
                <div className="flex flex-col gap-3">
                  {item.barcodes.map((bc, bcIndex) => (
                    <div key={bc.b_id} className="flex items-center gap-3">
                      <div className="relative flex-1">
                        <input type="text" placeholder="Scan atau Ketik Barcode/SKU..." className="w-full border border-zinc-300 rounded-lg p-2.5 pl-3 text-sm focus:outline-none focus:border-[#AF520C] bg-white"
                          value={bc.code} onChange={(e) => updateBarcodeInSpek(item.id, bc.b_id, "code", e.target.value)} />
                        <button className="absolute right-0 top-0 h-full px-3 text-zinc-400 hover:text-[#AF520C] border-l border-zinc-200" title="Scan Barcode">
                          <ScanLine size={16} />
                        </button>
                      </div>
                      
                      <div className="w-32 relative">
                        <input type="number" placeholder="Qty" className="w-full border border-zinc-300 rounded-lg p-2.5 pr-8 text-sm focus:outline-none focus:border-[#AF520C] bg-white"
                          value={bc.qty} onChange={(e) => updateBarcodeInSpek(item.id, bc.b_id, "qty", e.target.value)} />
                        <span className="absolute right-3 top-1/2 -translate-y-1/2 text-xs text-zinc-400 font-bold">Qty</span>
                      </div>

                      {item.barcodes.length > 1 && (
                        <button onClick={() => removeBarcodeFromSpesifikasi(item.id, bc.b_id)} className="p-2.5 text-zinc-400 hover:text-red-500 transition">
                          <Trash2 size={18} />
                        </button>
                      )}
                    </div>
                  ))}
                </div>

                <button onClick={() => addBarcodeToSpesifikasi(item.id)} className="mt-4 text-[#AF520C] text-xs font-bold flex items-center gap-1 hover:underline">
                  <Plus size={14} /> Tambah Relasi Barcode Lain
                </button>
              </div>

            </div>
          ))}
        </div>
      </div>

    </div>
  );
}