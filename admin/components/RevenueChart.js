"use client";
import { useState, useMemo } from 'react';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';
import { ChevronLeft, ChevronRight } from 'lucide-react';

export default function RevenueChart({ rawData }) {
  const [periode, setPeriode] = useState('minggu');
  const [currentDate, setCurrentDate] = useState(new Date()); // Start dari hari ini

  // 1. Logika Geser Waktu (Mesin Waktu)
  const handlePrev = () => {
    const newDate = new Date(currentDate);
    if (periode === 'minggu') newDate.setDate(newDate.getDate() - 7);
    if (periode === 'bulan') newDate.setMonth(newDate.getMonth() - 1);
    if (periode === 'tahun') newDate.setFullYear(newDate.getFullYear() - 1);
    setCurrentDate(newDate);
  };

  const handleNext = () => {
    const newDate = new Date(currentDate);
    if (periode === 'minggu') newDate.setDate(newDate.getDate() + 7);
    if (periode === 'bulan') newDate.setMonth(newDate.getMonth() + 1);
    if (periode === 'tahun') newDate.setFullYear(newDate.getFullYear() + 1);
    setCurrentDate(newDate);
  };

  // 2. Pabrik Pengolah Data Mentah (Dihitung ulang kalau tanggal/periode berubah)
  const chartDataToShow = useMemo(() => {
    if (!rawData) return [];

    const year = currentDate.getFullYear();
    const month = currentDate.getMonth();

    if (periode === 'minggu') {
      // Cari hari Senin di minggu yang dipilih
      const day = currentDate.getDay() || 7; 
      const senin = new Date(currentDate);
      senin.setDate(currentDate.getDate() - day + 1);

      const result = [];
      const namaHari = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];

      for (let i = 0; i < 7; i++) {
        const targetDate = new Date(senin);
        targetDate.setDate(senin.getDate() + i);
        // Penting: Bikin jadi YYYY-MM-DD biar cocok sama format API
        const dateStr = targetDate.toISOString().split('T')[0]; 
        
        const found = rawData.find(d => d.date === dateStr);
        result.push({ name: namaHari[i], total: found ? found.total : 0 });
      }
      return result;
    }

    if (periode === 'bulan') {
      // Agregasi jadi 4/5 Minggu
      const result = [
        { name: 'Minggu 1', total: 0 }, { name: 'Minggu 2', total: 0 },
        { name: 'Minggu 3', total: 0 }, { name: 'Minggu 4', total: 0 },
        { name: 'Minggu 5', total: 0 },
      ];

      rawData.forEach(d => {
        const dateObj = new Date(d.date);
        if (dateObj.getFullYear() === year && dateObj.getMonth() === month) {
          const weekIndex = Math.floor((dateObj.getDate() - 1) / 7);
          if (weekIndex < 5) result[weekIndex].total += d.total;
        }
      });
      // Hapus minggu ke-5 kalau gak ada isinya
      if (result[4].total === 0) result.pop();
      return result;
    }

    if (periode === 'tahun') {
      // Agregasi jadi 12 Bulan
      const result = [
        { name: 'Jan', total: 0 }, { name: 'Feb', total: 0 }, { name: 'Mar', total: 0 },
        { name: 'Apr', total: 0 }, { name: 'Mei', total: 0 }, { name: 'Jun', total: 0 },
        { name: 'Jul', total: 0 }, { name: 'Ags', total: 0 }, { name: 'Sep', total: 0 },
        { name: 'Okt', total: 0 }, { name: 'Nov', total: 0 }, { name: 'Des', total: 0 },
      ];

      rawData.forEach(d => {
        const dateObj = new Date(d.date);
        if (dateObj.getFullYear() === year) {
          result[dateObj.getMonth()].total += d.total;
        }
      });
      return result;
    }
  }, [rawData, periode, currentDate]);

  // 3. Bikin Teks Label Tanggal Dinamis
  const getLabelTanggal = () => {
    const monthNames = ["Januari", "Februari", "Maret", "April", "Mei", "Juni", "Juli", "Agustus", "September", "Oktober", "November", "Desember"];
    if (periode === 'tahun') return currentDate.getFullYear().toString();
    if (periode === 'bulan') return `${monthNames[currentDate.getMonth()]} ${currentDate.getFullYear()}`;

    const day = currentDate.getDay() || 7;
    const senin = new Date(currentDate);
    senin.setDate(currentDate.getDate() - day + 1);
    const minggu = new Date(senin);
    minggu.setDate(senin.getDate() + 6);

    return `${senin.getDate()} ${monthNames[senin.getMonth()].substring(0,3)} - ${minggu.getDate()} ${monthNames[minggu.getMonth()].substring(0,3)} ${minggu.getFullYear()}`;
  };

  return (
    <div className="bg-white p-6 rounded-2xl border border-zinc-100 shadow-sm h-100">
      <div className="flex justify-between items-start mb-6">
        <div>
          <h3 className="font-bold text-zinc-800 text-lg">Revenue Over Time</h3>
          <p className="text-sm text-zinc-400">Total pendapatan berdasarkan rentang waktu</p>
        </div>
        
        <div className="flex items-center gap-4">
          {/* Navigasi Kiri Kanan & Label */}
          <div className="flex items-center gap-3 bg-zinc-50 border border-zinc-200 rounded-lg p-1">
            <button onClick={handlePrev} className="p-1 hover:bg-white rounded shadow-sm text-zinc-600 transition">
              <ChevronLeft size={18} />
            </button>
            <span className="text-sm font-semibold text-zinc-700 min-w-35 text-center">
              {getLabelTanggal()}
            </span>
            <button onClick={handleNext} className="p-1 hover:bg-white rounded shadow-sm text-zinc-600 transition">
              <ChevronRight size={18} />
            </button>
          </div>

          <select 
            value={periode}
            onChange={(e) => {
              setPeriode(e.target.value);
              setCurrentDate(new Date()); // Reset ke hari ini tiap ganti mode
            }}
            className="bg-white border border-zinc-200 text-zinc-700 text-sm font-medium rounded-lg px-3 py-2 outline-none cursor-pointer hover:bg-zinc-50 transition"
          >
            <option value="minggu">Mingguan</option>
            <option value="bulan">Bulanan</option>
            <option value="tahun">Tahunan</option>
          </select>
        </div>
      </div>

      <div className="w-full h-62.5 mt-4">
        <ResponsiveContainer width="100%" height="100%" minWidth={0} minHeight={0}>
          <BarChart data={chartDataToShow}>
            <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#f0f0f0" />
            <XAxis dataKey="name" axisLine={false} tickLine={false} tick={{fill: '#9ca3af', fontSize: 12}} dy={10} />
            <YAxis axisLine={false} tickLine={false} tick={{fill: '#9ca3af', fontSize: 12}} tickFormatter={(value) => `Rp ${value / 1000000}M`} width={80} />
            <Tooltip 
              cursor={{fill: '#f9fafb'}} 
              contentStyle={{ borderRadius: '12px', border: 'none', boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)' }}
              formatter={(value) => [`Rp ${value.toLocaleString('id-ID')}`, 'Total Revenue']}
            />
            <Bar dataKey="total" fill="#a8571d" radius={[6, 6, 0, 0]} barSize={40} />
          </BarChart>
        </ResponsiveContainer>
      </div>
    </div>
  );
}