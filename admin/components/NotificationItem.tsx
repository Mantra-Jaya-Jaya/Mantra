import { AlertTriangle, UserX } from "lucide-react";

// WAJIB ADA 'export default' BIAR BISA DI-IMPORT SAMA HALAMAN LAIN
export default function NotificationItem({ notif, onDismiss }: { notif: any, onDismiss: any }) {
  // Beda tipe, beda ikon dan warna
  const getIcon = () => {
    if (notif.type === "stock") {
      return <AlertTriangle size={20} className="text-red-500" />;
    }
    if (notif.type === "employee") {
      return <UserX size={20} className="text-zinc-500" />;
    }
    return null;
  };

  return (
    <div className={`relative flex gap-4 p-6 border-b border-zinc-100 last:border-0 transition-colors hover:bg-zinc-50/50 ${notif.isRead ? 'opacity-70' : 'bg-white'}`}>
      
      {/* Indikator Unread (Garis Oranye di kiri) */}
      {!notif.isRead && (
        <div className="absolute left-0 top-0 bottom-0 w-1 bg-[#AF520C] rounded-l-xl"></div>
      )}

      {/* Ikon */}
      <div className={`w-12 h-12 rounded-full flex items-center justify-center shrink-0 ${notif.type === "stock" ? "bg-red-50" : "bg-zinc-100"}`}>
        {getIcon()}
      </div>

      {/* Konten Text */}
      <div className="flex-1">
        <div className="flex justify-between items-start mb-1">
          <h3 className={`text-sm ${notif.isRead ? 'font-semibold text-zinc-700' : 'font-bold text-zinc-900'}`}>
            {notif.title}
          </h3>
          <span className="text-[11px] text-zinc-400 font-medium whitespace-nowrap ml-4">
            {notif.time}
          </span>
        </div>
        
        <p className="text-xs text-zinc-500 leading-relaxed max-w-3xl mb-3">
          {notif.description}
        </p>

        {/* Action Buttons */}
        <div className="flex gap-4">
          <button className="text-[10px] font-bold text-[#AF520C] uppercase tracking-wider hover:underline">
            View Details
          </button>
          <button 
            onClick={() => onDismiss(notif.id)}
            className="text-[10px] font-bold text-zinc-400 uppercase tracking-wider hover:text-zinc-600 transition"
          >
            Dismiss
          </button>
        </div>
      </div>
    </div>
  );
}