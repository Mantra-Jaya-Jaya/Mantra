"use client";
import { useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { 
  CloudUpload, ChevronRight, User, Phone, Mail, Lock, 
  Fingerprint, MapPin, GraduationCap, Sun, Sunset, Moon,
  Briefcase, ChevronDown, Eye, EyeOff, Clock, LogIn, Circle, AlertTriangle
} from "lucide-react";

export default function EditKaryawanPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(false);
  
  // Data Dummy (Nantinya dapet dari API berdasarkan ID)
  const [role, setRole] = useState("Kasir");
  const [shift, setShift] = useState("Siang");
  const [status, setStatus] = useState("Aktif");
  const [showPassword, setShowPassword] = useState(false);

  const [formData, setFormData] = useState({
    nama: "Siti Aminah",
    noTelp: "81234567890",
    email: "siti.aminah@mantra.com",
    nik: "3275001234567890",
    tempatLahir: "Jakarta",
    tglLahir: "1995-05-15",
    gender: "Wanita",
    pendidikan: "D3 / S1",
    alamat: "Jl. Merdeka No. 123, Kebayoran Baru, Jakarta Selatan, 12110"
  });

  const handleSimpan = async () => {
    setLoading(true);
    // Logic update ke API Golang temen lu
    console.log("Update Data:", { ...formData, role, shift, status });
    
    setTimeout(() => {
      setLoading(false);
      router.push("/karyawan");
    }, 1000);
  };

  return (
    <div className="w-full pb-12">
      {/* HEADER */}
      <div className="flex justify-between items-end mb-8">
        <div>
          <h1 className="text-3xl font-bold text-zinc-900 mb-2">Edit Data Karyawan</h1>
          <div className="flex items-center gap-2 text-sm text-zinc-500 font-medium">
            <Link href="/karyawan" className="hover:text-[#AF520C] transition">Management</Link>
            <ChevronRight size={14} />
            <span className="text-zinc-400">{role}</span>
            <ChevronRight size={14} />
            <span className="text-[#AF520C]">Edit</span>
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
            {loading ? "Menyimpan..." : "Simpan Perubahan"}
          </button>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        
        {/* KIRI: INFORMASI PRIBADI */}
        <div className="lg:col-span-4 flex flex-col gap-6">
          <div className="bg-white p-6 rounded-2xl border border-zinc-200 shadow-sm">
            <h2 className="text-lg font-bold text-zinc-800 mb-6 flex items-center gap-2">
              <User size={20} className="text-[#AF520C]" /> Informasi Pribadi
            </h2>
            
            {/* Foto Profil */}
            <div className="flex flex-col items-center mb-8">
              <div className="relative group">
                <div className="w-32 h-32 rounded-3xl border-4 border-orange-50 overflow-hidden shadow-inner bg-zinc-100 relative z-0">
                  <img src={`https://ui-avatars.com/api/?name=${formData.nama}&background=AF520C&color=fff&size=128`} alt="Profile" className="w-full h-full object-cover" />
                  
                  {/* Overlay Blur kalau status Nonaktif biar kerasa estetik mati suri */}
                  {status === "Nonaktif" && (
                    <div className="absolute inset-0 bg-white/70 backdrop-blur-[2px] flex items-center justify-center">
                       <EyeOff size={32} className="text-zinc-400" />
                    </div>
                  )}
                </div>
                <button className="absolute -right-2 -bottom-2 bg-[#AF520C] text-white p-2 rounded-xl shadow-lg border-4 border-white hover:scale-110 transition z-10">
                  <CloudUpload size={16} />
                </button>
              </div>
              <p className="text-[10px] font-bold text-zinc-400 mt-4 uppercase tracking-tighter">Click icon to upload new photo</p>
            </div>

            <div className="space-y-4">
              <div>
                <label className="text-xs font-bold text-zinc-500 mb-1.5 block uppercase tracking-wider">Nama Lengkap</label>
                <input type="text" value={formData.nama} onChange={(e) => setFormData({...formData, nama: e.target.value})} className="w-full border border-zinc-200 rounded-xl p-3 text-sm focus:border-[#AF520C] outline-none" />
              </div>
              <div>
                <label className="text-xs font-bold text-zinc-500 mb-1.5 block uppercase tracking-wider">Nomor Telepon</label>
                <div className="relative">
                  <span className="absolute left-3 top-1/2 -translate-y-1/2 text-zinc-400 text-sm font-bold">+62</span>
                  <input type="text" value={formData.noTelp} onChange={(e) => setFormData({...formData, noTelp: e.target.value})} className="w-full border border-zinc-200 rounded-xl p-3 pl-12 text-sm focus:border-[#AF520C] outline-none" />
                </div>
              </div>
              <div>
                <label className="text-xs font-bold text-zinc-500 mb-1.5 block uppercase tracking-wider">Email</label>
                <input type="email" value={formData.email} onChange={(e) => setFormData({...formData, email: e.target.value})} className="w-full border border-zinc-200 rounded-xl p-3 text-sm focus:border-[#AF520C] outline-none" />
              </div>
              <div>
                <label className="text-xs font-bold text-zinc-500 mb-1.5 block uppercase tracking-wider">Password</label>
                <div className="relative">
                  <input type={showPassword ? "text" : "password"} placeholder="********" className="w-full border border-zinc-200 rounded-xl p-3 text-sm focus:border-[#AF520C] outline-none" />
                  <button onClick={() => setShowPassword(!showPassword)} className="absolute right-3 top-1/2 -translate-y-1/2 text-zinc-400">
                    {showPassword ? <EyeOff size={18} /> : <Eye size={18} />}
                  </button>
                </div>
                <p className="text-[10px] text-zinc-400 mt-1.5">Kosongkan jika tidak ingin mengubah password</p>
              </div>
            </div>
          </div>
        </div>

        {/* KANAN: DETAIL & AKTIVITAS */}
        <div className="lg:col-span-8 flex flex-col gap-6">
          <div className="bg-white p-8 rounded-2xl border border-zinc-200 shadow-sm">
            <h2 className="text-lg font-bold text-zinc-800 mb-8 flex items-center gap-2">
              <Fingerprint size={20} className="text-[#AF520C]" /> Detail Tambahan
            </h2>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
              <div className="md:col-span-2">
                <label className="text-xs font-bold text-zinc-500 mb-1.5 block uppercase tracking-wider">NIK (Nomor Induk Kependudukan)</label>
                <input type="text" value={formData.nik} readOnly className="w-full border border-zinc-100 bg-zinc-50 text-zinc-500 rounded-xl p-3 text-sm outline-none cursor-not-allowed" />
              </div>
              <div>
                <label className="text-xs font-bold text-zinc-500 mb-1.5 block uppercase tracking-wider">Tempat Lahir</label>
                <input type="text" value={formData.tempatLahir} onChange={(e) => setFormData({...formData, tempatLahir: e.target.value})} className="w-full border border-zinc-200 rounded-xl p-3 text-sm focus:border-[#AF520C] outline-none" />
              </div>
              <div>
                <label className="text-xs font-bold text-zinc-500 mb-1.5 block uppercase tracking-wider">Tanggal Lahir</label>
                <input type="date" value={formData.tglLahir} onChange={(e) => setFormData({...formData, tglLahir: e.target.value})} className="w-full border border-zinc-200 rounded-xl p-3 text-sm focus:border-[#AF520C] outline-none" />
              </div>
              <div>
                <label className="text-xs font-bold text-zinc-500 mb-2 block uppercase tracking-wider">Jenis Kelamin</label>
                <div className="flex bg-zinc-100 p-1 rounded-xl gap-1">
                  <button onClick={() => setFormData({...formData, gender: "Wanita"})} className={`flex-1 py-2 rounded-lg text-sm font-bold transition ${formData.gender === "Wanita" ? "bg-white text-[#AF520C] shadow-sm border border-orange-200" : "text-zinc-500"}`}>Wanita</button>
                  <button onClick={() => setFormData({...formData, gender: "Pria"})} className={`flex-1 py-2 rounded-lg text-sm font-bold transition ${formData.gender === "Pria" ? "bg-white text-[#AF520C] shadow-sm border border-orange-200" : "text-zinc-500"}`}>Pria</button>
                </div>
              </div>
              <div>
                <label className="text-xs font-bold text-zinc-500 mb-2 block uppercase tracking-wider">Pendidikan Terakhir</label>
                <div className="relative">
                  <select value={formData.pendidikan} onChange={(e) => setFormData({...formData, pendidikan: e.target.value})} className="w-full border border-zinc-200 rounded-xl p-3 pr-10 text-sm focus:border-[#AF520C] outline-none bg-white appearance-none cursor-pointer">
                    <option>SMA / SMK</option>
                    <option>D3 / Diploma</option>
                    <option>S1 / Sarjana</option>
                  </select>
                  <ChevronDown size={18} className="absolute right-3 top-1/2 -translate-y-1/2 text-zinc-400 pointer-events-none" />
                </div>
              </div>
              <div className="md:col-span-2">
                <label className="text-xs font-bold text-zinc-500 mb-1.5 block uppercase tracking-wider">Alamat Lengkap</label>
                <textarea rows={3} value={formData.alamat} onChange={(e) => setFormData({...formData, alamat: e.target.value})} className="w-full border border-zinc-200 rounded-xl p-3 text-sm focus:border-[#AF520C] outline-none resize-none"></textarea>
              </div>
            </div>

            {/* SEKSI SHIFT (Hanya Muncul Jika Kasir) */}
            {role === "Kasir" && (
              <div className="pt-8 border-t border-zinc-100 transition-all">
                <h3 className="text-xs font-bold text-zinc-500 mb-4 uppercase tracking-wider">Shift Kerja</h3>
                <div className="grid grid-cols-3 gap-3">
                  <button onClick={() => setShift("Pagi")} className={`flex flex-col items-center p-3 rounded-2xl border-2 transition ${shift === "Pagi" ? "border-[#AF520C] bg-orange-50/50" : "border-zinc-100 bg-zinc-50"}`}>
                    <Sun size={18} className={shift === "Pagi" ? "text-[#AF520C]" : "text-zinc-300"} />
                    <span className="text-[10px] font-bold mt-1 text-zinc-800">PAGI</span>
                    <span className="text-[9px] text-zinc-400 font-medium">07:00 - 15:00</span>
                  </button>
                  <button onClick={() => setShift("Siang")} className={`flex flex-col items-center p-3 rounded-2xl border-2 transition ${shift === "Siang" ? "border-[#AF520C] bg-orange-50/50" : "border-zinc-100 bg-zinc-50"}`}>
                    <Sunset size={18} className={shift === "Siang" ? "text-[#AF520C]" : "text-zinc-300"} />
                    <span className="text-[10px] font-bold mt-1 text-zinc-800">SIANG</span>
                    <span className="text-[9px] text-zinc-400 font-medium">15:00 - 23:00</span>
                  </button>
                  <button onClick={() => setShift("Malam")} className={`flex flex-col items-center p-3 rounded-2xl border-2 transition ${shift === "Malam" ? "border-[#AF520C] bg-orange-50/50" : "border-zinc-100 bg-zinc-50"}`}>
                    <Moon size={18} className={shift === "Malam" ? "text-[#AF520C]" : "text-zinc-300"} />
                    <span className="text-[10px] font-bold mt-1 text-zinc-800">MALAM</span>
                    <span className="text-[9px] text-zinc-400 font-medium">23:00 - 07:00</span>
                  </button>
                </div>
              </div>
            )}
          </div>

          {/* 🚀 SEKSI AKTIVITAS TERAKHIR & UBAH STATUS (REVISI TOTAL) */}
          <div className="bg-white p-6 rounded-2xl border border-zinc-200 shadow-sm flex flex-col gap-6">
            
            {/* Header & Indikator Status Coklat (No more Green/Red palette) */}
            <div className="flex justify-between items-center">
              <h2 className="text-sm font-bold text-zinc-800 flex items-center gap-2 uppercase tracking-widest">
                Aktivitas Terakhir
              </h2>
              {/* REVISI: Badge Status Pakai Coklat Mantra / Zinc Netral */}
              <div className={`inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold border transition ${
                status === "Aktif" 
                  ? "bg-orange-50 text-[#AF520C] border-[#AF520C]/20" // AKTIF: Coklat Mantra
                  : "bg-zinc-100 text-zinc-600 border-zinc-200" // NONAKTIF: Zinc Netral
              }`}>
                <Circle size={8} className={`fill-current ${status === "Aktif" ? "text-[#AF520C]" : "text-zinc-400"}`} />
                Akun {status}
              </div>
            </div>

            {/* Kotak Metadata Aktivitas */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className="bg-zinc-50 p-4 rounded-xl flex items-center gap-4">
                <div className="w-10 h-10 bg-white rounded-lg flex items-center justify-center text-zinc-400 border border-zinc-100 shadow-sm">
                  <Clock size={18} />
                </div>
                <div>
                  <p className="text-[9px] font-bold text-zinc-400 uppercase tracking-wider">Dibuat Pada</p>
                  <p className="text-sm font-bold text-zinc-700">12 Jan 2024, 10:45 AM</p>
                </div>
              </div>
              <div className="bg-zinc-50 p-4 rounded-xl flex items-center gap-4">
                <div className="w-10 h-10 bg-white rounded-lg flex items-center justify-center text-zinc-400 border border-zinc-100 shadow-sm">
                  <LogIn size={18} />
                </div>
                <div>
                  <p className="text-[9px] font-bold text-zinc-400 uppercase tracking-wider">Login Terakhir</p>
                  <p className="text-sm font-bold text-zinc-700">24 Mar 2024, 08:30 PM</p>
                </div>
              </div>
            </div>

            {/* Separator Garis Tipis */}
            <hr className="border-zinc-100" />

            {/* 🚀 BARU: AREA EXPLICIT ACTION BUAT UBAH STATUS (Minimal & Elegan) */}
            <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 pt-2">
              <div>
                <h3 className="text-sm font-bold text-zinc-800">Ubah Status Akses Karyawan</h3>
                <p className="text-xs text-zinc-500 mt-1 max-w-lg">
                  Lakukan penonaktifan jika karyawan sudah tidak bekerja. Status 'Nonaktif' akan mencabut akses login ke semua aplikasi Mantra.
                </p>
              </div>

              {/* REVISI: Tombol Explicit, Minimal, & Pakai Palette Coklat */}
              {status === "Aktif" ? (
                <button 
                  onClick={() => setStatus("Nonaktif")}
                  className="px-5 py-2.5 bg-zinc-100 text-zinc-700 rounded-lg text-xs font-bold hover:bg-zinc-200 hover:text-red-700 transition flex items-center gap-2 border border-zinc-200 shrink-0"
                >
                  <AlertTriangle size={16} />
                  Nonaktifkan Akun
                </button>
              ) : (
                <button 
                  onClick={() => setStatus("Aktif")}
                  className="px-5 py-2.5 bg-orange-50 text-[#AF520C] rounded-lg text-xs font-bold hover:bg-orange-100 transition flex items-center gap-2 border border-[#AF520C]/20 shrink-0"
                >
                  <Eye size={16} />
                  Aktifkan Akun Kembali
                </button>
              )}
            </div>
          </div>
        </div>

      </div>
    </div>
  );
}