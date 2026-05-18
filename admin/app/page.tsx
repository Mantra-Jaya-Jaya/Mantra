// app/page.tsx (atau page.js)
import StatCard from '@/components/StatCard';
import RevenueChart from '@/components/RevenueChart';
import CriticalStock from '@/components/CriticalStock';
import TransactionTable from '@/components/TransactionTable';
import { statData, rawChartData, criticalStockData, transactionData } from '@/lib/dummyData';

export default function Home() {
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
          <RevenueChart rawData={rawChartData} />
        </div>
        <CriticalStock data={criticalStockData} />
      </div>

      {/* Tabel Transaksi */}
      <TransactionTable data={transactionData} />
    </>
  );
}