"use client";
import { useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { 
  CloudUpload, ChevronRight, User, Phone, Mail, Lock, 
  IdCardLanyard, MapPin, GraduationCap, Sun, Sunset, Moon,
  Briefcase, ChevronDown
} from "lucide-react";

export default function TambahKaryawanPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(false);
  const [role, setRole] = useState("Kasir"); // Default Kasir
  const [shift, setShift] = useState("Pagi");

  // State Form
  const [formData, setFormData] = useState({
    nama: "", noTelp: "", email: "", password: "",
    nik: "", tempatLahir: "", tglLahir: "",
    gender: "Wanita", pendidikan: "D3 / S1", alamat: ""
  });

  const handleSimpan = async () => {
    setLoading(true);
    // Simulasi Payload buat temen backend lu
    const payload = {
      ...formData,
      role: role,
      shift: role === "Kasir" ? shift : null // Shift null kalau Kurir
    };
    
    console.log("Kirim ke Golang:", payload);

    setTimeout(() => {
      setLoading(false);
      router.push("/karyawan");
    }, 1000);
  };

  return (
    <div className="w-full pb-12">
      {/* HEADER & BREADCRUMB */}
      <div className="flex justify-between items-end mb-8">
        <div>
          <h1 className="text-3xl font-bold text-zinc-900 mb-2">Tambah Karyawan</h1>
          <div className="flex items-center gap-2 text-sm text-zinc-500 font-medium">
            <Link href="/karyawan" className="hover:text-[#AF520C] transition">Karyawan</Link>
            <ChevronRight size={14} />
            <span className="text-[#AF520C]">Tambah Karyawan</span>
          </div>
        </div>
        
        <div className="flex items-center gap-3">
          <Link href="/karyawan" className="px-6 py-2.5 bg-white border border-zinc-200 text-zinc-600 rounded-lg text-sm font-bold hover:bg-zinc-50 transition">
            Batal
          </Link>
          <button 
            onClick={handleSimpan}
            disabled={loading}
            className="px-6 py-2.5 bg-[#AF520C] text-white rounded-lg text-sm font-bold hover:bg-[#8e4209] transition shadow-md disabled:opacity-50"
          >
            {loading ? "Menyimpan..." : "Simpan Karyawan"}
          </button>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        
        {/* KIRI: INFORMASI PRIBADI & AKUN */}
        <div className="lg:col-span-4 flex flex-col gap-6">
          <div className="bg-white p-6 rounded-2xl border border-zinc-200 shadow-sm">
            <h2 className="text-lg font-bold text-zinc-800 mb-6 flex items-center gap-2">
              <User size={20} className="text-[#AF520C]" /> Informasi Akun
            </h2>
            
            {/* Upload Foto */}
            <div className="flex flex-col items-center mb-8">
              <div className="w-32 h-32 rounded-full border-2 border-dashed border-zinc-300 flex flex-col items-center justify-center bg-zinc-50 hover:bg-orange-50 transition cursor-pointer group relative overflow-hidden">
                <CloudUpload size={24} className="text-zinc-400 group-hover:text-[#AF520C]" />
                <span className="text-[10px] font-bold text-zinc-400 mt-1">Upload Foto</span>
              </div>
              <p className="text-[11px] text-zinc-400 mt-3 text-center">Rekomendasi rasio 1:1 (Max 2MB)</p>
            </div>

            <div className="space-y-4">
              <div>
                <label className="text-xs font-bold text-zinc-500 mb-1.5 block uppercase tracking-wider">Nama Lengkap</label>
                <input type="text" className="w-full border border-zinc-200 rounded-xl p-3 text-sm focus:border-[#AF520C] outline-none transition" placeholder="Cth: Budi Kusuma" />
              </div>
              <div>
                <label className="text-xs font-bold text-zinc-500 mb-1.5 block uppercase tracking-wider">Nomor Telepon</label>
                <input type="text" className="w-full border border-zinc-200 rounded-xl p-3 text-sm focus:border-[#AF520C] outline-none transition" placeholder="+62 8..." />
              </div>
              <div>
                <label className="text-xs font-bold text-zinc-500 mb-1.5 block uppercase tracking-wider">Email</label>
                <input type="email" className="w-full border border-zinc-200 rounded-xl p-3 text-sm focus:border-[#AF520C] outline-none transition" placeholder="budi@mantra.com" />
              </div>
              <div>
                <label className="text-xs font-bold text-zinc-500 mb-1.5 block uppercase tracking-wider">Password</label>
                <input type="password" className="w-full border border-zinc-200 rounded-xl p-3 text-sm focus:border-[#AF520C] outline-none transition" placeholder="••••••••" />
              </div>
            </div>
          </div>
        </div>

        {/* KANAN: DETAIL TAMBAHAN & ROLE */}
        <div className="lg:col-span-8 flex flex-col gap-6">
          <div className="bg-white p-8 rounded-2xl border border-zinc-200 shadow-sm">
            <h2 className="text-lg font-bold text-zinc-800 mb-8 flex items-center gap-2">
              <IdCardLanyard size={20} className="text-[#AF520C]" /> Detail Karyawan
            </h2>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
              <div className="md:col-span-2">
                <label className="text-xs font-bold text-zinc-500 mb-1.5 block uppercase tracking-wider">NIK (Nomor Induk Kependudukan)</label>
                <input type="text" className="w-full border border-zinc-200 rounded-xl p-3 text-sm focus:border-[#AF520C] outline-none" placeholder="16 Digit NIK" />
              </div>
              <div>
                <label className="text-xs font-bold text-zinc-500 mb-1.5 block uppercase tracking-wider">Tempat Lahir</label>
                <input type="text" className="w-full border border-zinc-200 rounded-xl p-3 text-sm focus:border-[#AF520C] outline-none" placeholder="Cth: Jakarta" />
              </div>
              <div>
                <label className="text-xs font-bold text-zinc-500 mb-1.5 block uppercase tracking-wider">Tanggal Lahir</label>
                <input type="date" className="w-full border border-zinc-200 rounded-xl p-3 text-sm focus:border-[#AF520C] outline-none" />
              </div>
              <div>
                <label className="text-xs font-bold text-zinc-500 mb-2 block uppercase tracking-wider">Jenis Kelamin</label>
                <div className="flex bg-zinc-100 p-1 rounded-xl">
                  <button onClick={() => setFormData({...formData, gender: "Wanita"})} className={`flex-1 py-2 rounded-lg text-sm font-bold transition ${formData.gender === "Wanita" ? "bg-white text-[#AF520C] shadow-sm" : "text-zinc-500"}`}>Wanita</button>
                  <button onClick={() => setFormData({...formData, gender: "Pria"})} className={`flex-1 py-2 rounded-lg text-sm font-bold transition ${formData.gender === "Pria" ? "bg-white text-[#AF520C] shadow-sm" : "text-zinc-500"}`}>Pria</button>
                </div>
              </div>
              <div>
                <label className="text-xs font-bold text-zinc-500 mb-2 block uppercase tracking-wider">Pendidikan Terakhir</label>
                <div className="relative">
                  <select className="w-full border border-zinc-200 rounded-xl p-3 pr-10 text-sm focus:border-[#AF520C] outline-none bg-white appearance-none cursor-pointer">
                    <option>SMA / SMK</option>
                    <option>D3 / S1</option>
                    <option>S2</option>
                  </select>
                  <ChevronDown size={18} className="absolute right-3 top-1/2 -translate-y-1/2 text-zinc-400 pointer-events-none" />
                </div>
              </div>
              <div className="md:col-span-2">
                <label className="text-xs font-bold text-zinc-500 mb-1.5 block uppercase tracking-wider">Alamat Lengkap</label>
                <textarea rows={3} className="w-full border border-zinc-200 rounded-xl p-3 text-sm focus:border-[#AF520C] outline-none resize-none" placeholder="Jl. Merdeka No. 123..."></textarea>
              </div>
            </div>

            {/* SEKSI ROLE & SHIFT KERJA (REFECTORED) */}
            <div className="pt-8 border-t border-zinc-100">
              <h3 className="text-md font-bold text-zinc-800 mb-4 flex items-center gap-2">
                <Briefcase size={18} className="text-[#AF520C]" /> Penempatan Tugas
              </h3>
              
              <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
                {/* 1. Pilih Role */}
                <div>
                  <label className="text-xs font-bold text-zinc-500 mb-3 block uppercase tracking-wider">Pilih Peran (Role)</label>
                  <div className="flex bg-zinc-100 p-1.5 rounded-2xl gap-1">
                    <button 
                      onClick={() => setRole("Kasir")}
                      className={`flex-1 py-3 rounded-xl text-sm font-bold flex items-center justify-center gap-2 transition ${role === "Kasir" ? "bg-white text-[#AF520C] shadow-md scale-[1.02]" : "text-zinc-500 hover:text-zinc-700"}`}
                    >
                      Kasir
                    </button>
                    <button 
                      onClick={() => setRole("Kurir")}
                      className={`flex-1 py-3 rounded-xl text-sm font-bold flex items-center justify-center gap-2 transition ${role === "Kurir" ? "bg-white text-[#AF520C] shadow-md scale-[1.02]" : "text-zinc-500 hover:text-zinc-700"}`}
                    >
                      Kurir
                    </button>
                  </div>
                </div>

                {/* 2. Pilih Shift (Hanya Muncul Jika Kasir) */}
                <div className={`transition-all duration-300 ${role === "Kasir" ? "opacity-100 translate-y-0" : "opacity-0 translate-y-4 pointer-events-none"}`}>
                  <label className="text-xs font-bold text-zinc-500 mb-3 block uppercase tracking-wider">Shift Kerja (WIB)</label>
                  <div className="grid grid-cols-3 gap-2">
                    <button onClick={() => setShift("Pagi")} className={`flex flex-col items-center p-2 rounded-xl border-2 transition ${shift === "Pagi" ? "border-[#AF520C] bg-orange-50" : "border-zinc-100 bg-zinc-50"}`}>
                      <Sun size={16} className={shift === "Pagi" ? "text-[#AF520C]" : "text-zinc-400"} />
                      <span className="text-[10px] font-bold mt-1">PAGI</span>
                      <span className="text-[9px] text-zinc-400">07:00-15:00</span>
                    </button>
                    <button onClick={() => setShift("Siang")} className={`flex flex-col items-center p-2 rounded-xl border-2 transition ${shift === "Siang" ? "border-[#AF520C] bg-orange-50" : "border-zinc-100 bg-zinc-50"}`}>
                      <Sunset size={16} className={shift === "Siang" ? "text-[#AF520C]" : "text-zinc-400"} />
                      <span className="text-[10px] font-bold mt-1">SIANG</span>
                      <span className="text-[9px] text-zinc-400">15:00-23:00</span>
                    </button>
                    <button onClick={() => setShift("Malam")} className={`flex flex-col items-center p-2 rounded-xl border-2 transition ${shift === "Malam" ? "border-[#AF520C] bg-orange-50" : "border-zinc-100 bg-zinc-50"}`}>
                      <Moon size={16} className={shift === "Malam" ? "text-[#AF520C]" : "text-zinc-400"} />
                      <span className="text-[10px] font-bold mt-1">MALAM</span>
                      <span className="text-[9px] text-zinc-400">23:00-07:00</span>
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

      </div>
    </div>
  );
}