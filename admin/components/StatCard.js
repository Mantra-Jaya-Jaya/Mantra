import { Wallet, ShoppingBag, Users, AlertCircle } from 'lucide-react';

const icons = {
  "Total Revenue": <Wallet className="text-zinc-400" size={20} />,
  "Total Orders": <ShoppingBag className="text-zinc-400" size={20} />,
  "Active Customers": <Users className="text-zinc-400" size={20} />,
  "Low Stock Items": <AlertCircle className="text-red-500" size={20} />,
};

export default function StatCard({ item }) {
  return (
    <div className="bg-white p-6 rounded-2xl border border-zinc-100 shadow-sm flex flex-col gap-4">
      <div className="flex justify-between items-start">
        <span className="text-zinc-500 font-medium">{item.title}</span>
        {icons[item.title]}
      </div>
      <div>
        <h3 className="text-2xl font-bold text-zinc-800">{item.value}</h3>
        <p className={`text-sm mt-1 ${item.type === 'danger' ? 'text-red-500 font-medium' : 'text-zinc-400'}`}>
          {item.trend} {item.type === 'increase' && 'from last month'}
        </p>
      </div>
    </div>
  );
}