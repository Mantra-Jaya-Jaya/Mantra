"use client";
import { useState } from "react";
import { useRouter } from "next/navigation";
import { Rocket } from "lucide-react"; // Pake icon roket biar mirip gambar lu

export default function LoginPage() {
  const router = useRouter();
  const [formData, setFormData] = useState({ email: "", password: "" });
  const [loading, setLoading] = useState(false);
  const [errorMsg, setErrorMsg] = useState("");

  const handleLogin = async (e) => {
    e.preventDefault();
    setLoading(true);
    setErrorMsg("");

    try {
      // Nembak ke API Golang via proxy Next.js
      const res = await fetch("/api/v1/login", {
        method: "POST",
        headers: { 
          "Content-Type": "application/json",
          "X-Client-Type": "nextjs"
        },
        // formData isinya udah sesuai sama { email, password }
        body: JSON.stringify(formData), 
      });
      
      const data = await res.json();
      
      // Cek kalau responsenya sukses kayak di dokumentasi temen lu
      if (res.ok && data.status === "success") {
        // Karena pakai HttpOnly Cookie, token udah otomatis kesimpen di browser.
        // Kita tinggal arahin admin ke Dashboard.
        router.push("/"); 
      } else {
        // Kalau gagal, nampilin pesan error asli dari Golang (misal: "email atau password salah")
        setErrorMsg(data.message || "Login gagal, silakan coba lagi.");
      }

    } catch (err) {
      console.error("Login error:", err);
      // Ini bakal muncul kalau server Golang lu (make run) lupa dinyalain
      setErrorMsg("Gagal terhubung ke server. Pastikan API Golang sudah menyala!");
    } finally {
      // Apapun hasilnya (sukses/gagal), matiin efek loadingnya
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-zinc-100 p-4">
      {/* Container Utama (Card) */}
      <div className="flex w-full max-w-5xl bg-white rounded-[2.5rem] shadow-2xl overflow-hidden min-h-[600px] relative">
        
        {/* BAGIAN KIRI (Orange Branding + Efek Awan) */}
        <div className="hidden md:flex w-1/2 bg-[#AF520C] relative flex-col justify-center items-center text-white p-12 overflow-hidden">
          
          {/* Konten Teks Kiri */}
          <div className="z-10 flex flex-col items-center text-center">
            <h2 className="text-3xl font-bold mb-8">Welcome to</h2>
            <div className="w-24 h-24 bg-white rounded-full flex items-center justify-center mb-4 shadow-lg">
              <Rocket size={48} className="text-[#AF520C]" />
            </div>
            <h1 className="text-4xl font-bold tracking-wider mb-6">Mantra</h1>
            <p className="text-sm text-white/80 max-w-[250px] leading-relaxed">
              Login ke panel admin untuk mengelola stok barang, karyawan, dan memantau transaksi harian Anda.
            </p>
          </div>

          {/* Efek Awan (Ellipses dengan Opacity di batas kanan) */}
          <div className="absolute -right-24 top-10 w-48 h-48 bg-white/20 rounded-full blur-sm"></div>
          <div className="absolute -right-32 top-1/4 w-64 h-64 bg-white/30 rounded-full"></div>
          <div className="absolute -right-20 bottom-1/3 w-56 h-56 bg-white/40 rounded-full blur-sm"></div>
          <div className="absolute -right-40 bottom-10 w-80 h-80 bg-white/20 rounded-full"></div>
          
          {/* Footer Kiri */}
          <div className="absolute bottom-8 text-xs text-white/60 font-semibold tracking-widest">
            ADMIN PANEL | V1.0
          </div>
        </div>

        {/* BAGIAN KANAN (Form Login) */}
        <div className="w-full md:w-1/2 flex flex-col justify-center px-12 sm:px-20 py-12 relative z-10 bg-white rounded-l-[3rem] md:-ml-8 shadow-[-10px_0_30px_rgba(0,0,0,0.05)]">
          <h2 className="text-3xl font-bold text-zinc-800 mb-12">Login to your account</h2>

          <form onSubmit={handleLogin} className="flex flex-col gap-8">
            {/* Input email */}
            <div className="flex flex-col">
              <label className="text-sm font-bold text-zinc-600 mb-2">Email</label>
              <input
                type="text"
                required
                spellCheck="false"
                placeholder="Enter your email"
                className="w-full border-b-2 border-zinc-200 py-2 text-zinc-800 focus:outline-none focus:border-[#AF520C] transition-colors placeholder:text-zinc-300"
                value={formData.email}
                onChange={(e) => setFormData({ ...formData, email: e.target.value })}
              />
            </div>

            {/* Input Password */}
            <div className="flex flex-col">
              <label className="text-sm font-bold text-zinc-600 mb-2">Password</label>
              <input
                type="password"
                required
                placeholder="Enter your password"
                className="w-full border-b-2 border-zinc-200 py-2 text-zinc-800 focus:outline-none focus:border-[#AF520C] transition-colors placeholder:text-zinc-300"
                value={formData.password}
                onChange={(e) => setFormData({ ...formData, password: e.target.value })}
              />
            </div>

            {/* Error Message */}
            {errorMsg && (
              <p className="text-red-500 text-sm font-semibold mt-[-10px]">{errorMsg}</p>
            )}

            {/* Button Sign In */}
            <div className="mt-4">
              <button
                type="submit"
                disabled={loading}
                className="w-[140px] bg-white text-[#AF520C] border-2 border-[#AF520C] font-bold py-3 rounded-full hover:bg-[#AF520C] hover:text-white transition-all disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {loading ? "Loading..." : "Sign In"}
              </button>
            </div>
          </form>
        </div>

      </div>
    </div>
  );
}