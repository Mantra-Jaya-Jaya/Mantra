"use client";
import { useState, useEffect } from 'react';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';
import { ChevronLeft, ChevronRight, Loader2 } from 'lucide-react';

export default function RevenueChart() {
  const [periode, setPeriode] = useState('minggu');
  const [currentDate, setCurrentDate] = useState(new Date()); // Start dari hari ini
  
  const [chartBars, setChartBars] = useState<any[]>([]);
  const [chartLabel, setChartLabel] = useState("");
  const [chartLoading, setChartLoading] = useState(false);

  // Fetch data tiap periode atau currentDate berubah
  useEffect(() => {
    const fetchChart = async () => {
      setChartLoading(true);
      try {
        const dateStr = currentDate.toISOString().split('T')[0];
        const res = await fetch(`/api/v1/admin/dashboard/chart?periode=${periode}&tanggal=${dateStr}`);
        const json = await res.json();
        
        if (res.ok && json.data) {
          setChartBars(json.data.bars || []);
          setChartLabel(json.data.label || "");
        }
      } catch (err) {
        console.error("Fetch chart error:", err);
      } finally {
        setChartLoading(false);
      }
    };
    
    fetchChart();
  }, [periode, currentDate]);

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

  return (
    <div className="bg-white p-6 rounded-2xl border border-zinc-100 shadow-sm h-100 relative">
      {chartLoading && (
        <div className="absolute inset-0 bg-white/60 backdrop-blur-sm z-10 flex items-center justify-center rounded-2xl">
          <Loader2 className="animate-spin text-[#AF520C]" size={32} />
        </div>
      )}
      
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
              {chartLabel}
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
          <BarChart data={chartBars}>
            <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#f0f0f0" />
            <XAxis dataKey="name" axisLine={false} tickLine={false} tick={{fill: '#9ca3af', fontSize: 12}} dy={10} />
            <YAxis axisLine={false} tickLine={false} tick={{fill: '#9ca3af', fontSize: 12}} tickFormatter={(value) => `Rp ${value / 1000000}M`} width={80} />
            <Tooltip 
              cursor={{fill: '#f9fafb'}} 
              contentStyle={{ borderRadius: '12px', border: 'none', boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)' }}
              formatter={(value) => [`Rp ${Number(value || 0).toLocaleString('id-ID')}`, 'Total Revenue']}
            />
            <Bar dataKey="total" fill="#a8571d" radius={[6, 6, 0, 0]} barSize={40} />
          </BarChart>
        </ResponsiveContainer>
      </div>
    </div>
  );
}