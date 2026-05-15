import { Package } from 'lucide-react';

export default function CriticalStock({ data }) {
  // Urutkan dari stok terkecil, lalu ambil 4 data saja
  const limitedData = [...data].sort((a, b) => a.sisa - b.sisa).slice(0, 4);

  return (
    <div className="bg-white p-6 rounded-2xl border border-zinc-100 shadow-sm flex-1 flex flex-col h-100">
      <div className="flex justify-between items-center mb-6">
        <div>
          <h3 className="font-bold text-zinc-800 text-lg">Stok Barang Kritis</h3>
          <p className="text-sm text-zinc-400">Items needing restocking soon</p>
        </div>
        <button className="text-orange-600 text-sm font-semibold hover:underline">View All</button>
      </div>
      
      <div className="flex flex-col gap-6 overflow-y-auto pr-2">
        {limitedData.map((item) => (
          <div key={item.id} className="flex items-center gap-4">
            <div className="p-3 bg-zinc-50 rounded-xl text-zinc-400">
              <Package size={20} />
            </div>
            <div className="flex-1">
              <div className="flex justify-between text-sm mb-2">
                <span className="font-semibold text-zinc-700">{item.nama}</span>
                <span className="text-red-600 font-bold">{item.sisa} left</span>
              </div>
              <div className="w-full bg-zinc-100 h-2 rounded-full overflow-hidden">
                <div 
                  className={`h-full rounded-full ${item.status === 'kritis' ? 'bg-red-500' : 'bg-orange-500'}`}
                  style={{ width: `${(item.sisa / 50) * 100}%` }}
                ></div>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}