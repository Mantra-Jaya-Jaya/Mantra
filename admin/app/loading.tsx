// app/loading.js

export default function GlobalLoading() {
  return (
    <div className="min-h-screen w-full flex flex-col items-center justify-center bg-white z-50">
      
      {/* 1. Kontainer Logo dengan Efek Pulse (Kelap-kelip lembut) */}
      {/* Di sini keajaibannya, class 'animate-pulse' bikin element memudar perlahan */}
      <div className="w-32 h-32 flex items-center justify-center mb-6 animate-pulse">
        <img 
          src="/logo_mantra.png" 
          alt="Mantra Logo Loading" 
          className="w-24 h-24 object-contain" 
        />
      </div>

      {/* 2. Teks Info Loading (Biar user gak bingung) */}
      <div className="text-center">
        {/* Pakai warna coklat utama Mantra #301905 */}
        <h2 className="text-xl font-bold text-[#301905]">
          Mantra
        </h2>
        <p className="text-sm text-zinc-500 mt-1 tracking-wide">
          Memuat...
        </p>
      </div>
      
    </div>
  );
}