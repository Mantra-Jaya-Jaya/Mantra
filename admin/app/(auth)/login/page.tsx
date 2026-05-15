"use client";
import { useState } from "react";
import { useRouter } from "next/navigation";
import { Loader2 } from "lucide-react";

export default function LoginPage() {
  const router = useRouter();
  const [formData, setFormData] = useState({ email: "", password: "" });
  const [loading, setLoading] = useState(false);
  const [errorMsg, setErrorMsg] = useState("");

  const handleLogin = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    setLoading(true);
    setErrorMsg("");

    try {
      const res = await fetch("/api/v1/login", {
        method: "POST",
        headers: { 
          "Content-Type": "application/json",
          "X-Client-Type": "nextjs"
        },
        body: JSON.stringify(formData), 
      });
      
      const data = await res.json();
      
      if (res.ok && data.status === "success") {
        router.push("/"); 
      } else {
        setErrorMsg(data.message || "Login gagal, silakan coba lagi.");
      }

    } catch (err) {
      console.error("Login error:", err);
      setErrorMsg("Gagal terhubung ke server. Pastikan API Golang sudah menyala!");
    } finally {
      setLoading(false);
    }
  };

  return (
    // 🚀 fixed inset-0 z-50: Jurus maksa full screen nutupin semua margin/padding bawaan layout!
    <div className="fixed inset-0 z-50 flex flex-col md:flex-row font-sans antialiased overflow-hidden bg-white">
      
      {/* BAGIAN KIRI (Gradient Branding + Efek Bokeh Awan) */}
      <div className="w-full md:w-1/2 flex flex-col justify-center items-center text-white p-12 relative overflow-hidden bg-linear-to-b from-[#924300] to-[#BF8040]">
        
        {/* Konten Teks Kiri */}
        <div className="z-20 flex flex-col items-center text-center max-w-md">
          <h2 className="text-3xl font-normal mb-8 text-white/90">Welcome to</h2>
          
          <div className="w-24 h-24 bg-white rounded-full flex items-center justify-center mb-6 shadow-xl border-4 border-white/30 overflow-hidden">
            <img src="/logo_mantra.png" alt="Logo Mantra" className="w-16 h-16 object-contain" />
          </div>
          
          <h1 className="text-5xl font-bold tracking-tight mb-6">Mantra</h1>
          
          <p className="text-sm text-white/85 leading-relaxed font-light px-8">
            Login ke panel admin untuk mengelola stok barang, karyawan, dan memantau transaksi harian Anda.
          </p>
        </div>

        {/* Efek Awan Bokeh (Lingkaran sempurna dengan Blur) */}
        {/* Menggunakan w-[px] dan h-[px] agar tidak melar jadi sosis */}
        <div className="absolute top-0 right-0 h-full w-full pointer-events-none z-10 overflow-hidden">
          <div className="absolute -right-20 top-[-5%] w-62.5 h-62.5 rounded-full bg-white "></div>
          <div className="absolute right-0 top-[-15%] w-50 h-50 rounded-full bg-white "></div>
          <div className="absolute -right-25 top-[10%] w-37.5 h-37.5 rounded-full bg-white "></div>
          <div className="absolute -right-25 top-[20%] w-37.5 h-37.5 rounded-full bg-white "></div>
          <div className="absolute -right-30 top-[40%] w-37.5 h-37.5 rounded-full bg-white "></div>
          <div className="absolute -right-25 top-[55%] w-25 h-25 rounded-full bg-white "></div>
          <div className="absolute -right-25 top-[65%] w-50 h-50 rounded-full bg-white "></div>
          <div className="absolute -right-20 bottom-[30%] w-37.5 h-37.5 rounded-full bg-white "></div>
          <div className="absolute right-[-10%] bottom-[-15%] w-87.5 h-87.5 rounded-full bg-white "></div>
          <div className="absolute top-0 right-0 h-full w-full pointer-events-none z-10 overflow-hidden opacity-60">
            <div className="absolute right-[-5%] bottom-[5%] w-62.5 h-62.5 rounded-full bg-white"></div>
            <div className="absolute right-[-3%] bottom-[30%] w-37.5 h-37.5 rounded-full bg-white"></div>
            <div className="absolute right-[-5%] bottom-[43%] w-25 h-25 rounded-full bg-white"></div>
            <div className="absolute right-[-4%] top-[40%] w-25 h-25 rounded-full bg-white"></div>
            <div className="absolute right-[-4%] top-[30%] w-37.5 h-37.5 rounded-full bg-white"></div>
            <div className="absolute right-[-4%] top-[10%] w-50 h-50 rounded-full bg-white"></div>
          </div>
        </div>
        
        {/* Footer Kiri */}
        <div className="absolute bottom-10 text-xs text-white/60 font-semibold tracking-widest z-20">
          ADMIN PANEL | V1.0
        </div>
      </div>

      {/* BAGIAN KANAN (Form Login Modern) */}
      <div className="w-full md:w-1/2 flex flex-col justify-center px-12 sm:px-24 py-12 relative z-10 bg-white">
        
        <div className="max-w-md w-full mx-auto">
          <h2 className="text-4xl font-bold text-[#301905] mb-12">Login to your account</h2>

          <form onSubmit={handleLogin} className="flex flex-col gap-8">
            {/* Input Email */}
            <div className="flex flex-col">
              <label className="text-sm font-bold text-[#301905] mb-2">Email</label>
              <input
                type="email"
                required
                spellCheck="false"
                placeholder="Email address"
                className="w-full border-b border-zinc-300 py-2 text-base text-zinc-900 focus:outline-none focus:border-[#301905] transition-colors placeholder:text-zinc-400 bg-transparent"
                value={formData.email}
                onChange={(e) => setFormData({ ...formData, email: e.target.value })}
              />
            </div>

            {/* Input Password */}
            <div className="flex flex-col">
              <label className="text-sm font-bold text-[#301905] mb-2">Password</label>
              <input
                type="password"
                required
                placeholder="Enter your password"
                className="w-full border-b border-zinc-300 py-2 text-base text-zinc-900 focus:outline-none focus:border-[#301905] transition-colors placeholder:text-zinc-400 bg-transparent"
                value={formData.password}
                onChange={(e) => setFormData({ ...formData, password: e.target.value })}
              />
            </div>

            {/* Error Message */}
            {errorMsg && (
              <p className="text-red-600 text-xs font-semibold -mt-2.5 leading-relaxed">
                {errorMsg}
              </p>
            )}

            {/* Button Sign In */}
            <div className="mt-4 flex justify-start">
              <button
                type="submit"
                disabled={loading}
                className="w-40 flex items-center justify-center gap-2 bg-white text-[#301905] border border-[#301905] font-bold py-3 rounded-full hover:bg-[#301905] hover:text-white transition-all disabled:opacity-60 disabled:cursor-not-allowed text-sm"
              >
                {loading ? (
                  <>
                    <Loader2 size={18} className="animate-spin" />
                    Memproses...
                  </>
                ) : (
                  "Sign In"
                )}
              </button>
            </div>
          </form>
        </div>
      </div>

    </div>
  );
}