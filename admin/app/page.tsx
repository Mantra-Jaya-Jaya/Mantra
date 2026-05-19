"use client";
import { useState, useEffect } from "react";
import StatCard from '@/components/StatCard';
import RevenueChart from '@/components/RevenueChart';
import CriticalStock from '@/components/CriticalStock';
import TransactionTable from '@/components/TransactionTable';
import { Loader2 } from "lucide-react";

export default function Home() {
  const [data, setData] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [errorMsg, setErrorMsg] = useState("");

  useEffect(() => {
    const fetchDashboardData = async () => {
      try {
        const res = await fetch("/api/v1/admin/dashboard");
        const json = await res.json();
        
        if (res.ok && json.data) {
          setData(json.data);
        } else {
          setErrorMsg("Gagal memuat data dashboard.");
        }
      } catch (err) {
        console.error("Fetch error:", err);
        setErrorMsg("Gagal terhubung ke API Server.");
      } finally {
        setLoading(false);
      }
    };

    fetchDashboardData();
  }, []);

  if (loading) {
    return (
      <div className="w-full h-96 flex flex-col items-center justify-center text-zinc-400 gap-3">
        <Loader2 className="animate-spin text-[#AF520C]" size={40} />
        <p className="font-bold text-sm text-zinc-700">Memuat data dashboard...</p>
      </div>
    );
  }

  if (errorMsg) {
    return (
      <div className="w-full p-4 bg-red-50 border border-red-200 text-red-600 rounded-xl text-sm font-semibold mb-6">
        ⚠️ {errorMsg}
      </div>
    );
  }

  const formatRupiah = (angka: number) => {
    if (angka >= 1000000) {
      return `Rp ${(angka / 1000000).toFixed(1)}M`;
    }
    return new Intl.NumberFormat("id-ID", {
      style: "currency",
      currency: "IDR",
      minimumFractionDigits: 0,
    }).format(angka);
  };

  const statData = [
    { title: "Total Revenue", value: formatRupiah(data?.penjualan_hari_ini || 0), trend: data?.trend_revenue, type: "increase" },
    { title: "Total Orders", value: (data?.total_pesanan || 0).toLocaleString(), trend: data?.trend_pesanan, type: "increase" },
    { title: "Active Customers", value: (data?.total_customer_aktif || 0).toLocaleString(), trend: data?.trend_customer, type: "increase" },
    { title: "Low Stock Items", value: (data?.total_stok_menipis || 0).toString(), trend: "Requires immediate attention", type: "danger" },
  ];

  return (
    <>
      <header className="mb-6">
        <h1 className="text-2xl font-bold text-zinc-800">Home</h1>
        <p className="text-zinc-500 text-sm">Selamat datang kembali Admin</p>
      </header>

      {/* 4 Kotak Metrik */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-6">
        {statData.map((item, idx) => (
          <StatCard key={idx} item={item} />
        ))}
      </div>

      {/* Grafik & Stok Kritis */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div className="lg:col-span-2">
          <RevenueChart />
        </div>
        <CriticalStock data={data?.stok_menipis || []} />
      </div>

      {/* Tabel Transaksi */}
      <TransactionTable data={data?.transaksi_terbaru || []} />
    </>
  );
}