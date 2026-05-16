"use client";
import { useState } from "react";
import { AlertTriangle, UserX, CheckCheck } from "lucide-react";
import NotificationItem from "@/components/NotificationItem";

export default function NotifikasiPage() {
  // Data Dummy sesuai request lu (Cuma Stok & Karyawan)
  const [notifications, setNotifications] = useState([
    {
      id: 1,
      type: "stock",
      title: "Low Stock Alert: Kertas HVS A4",
      description: "Inventory for 'Kertas HVS A4 70gsm' has dropped below the threshold of 5 Rim. Current stock is 2 Rim. Reorder recommended.",
      time: "10m ago",
      isRead: false,
    },
    {
      id: 2,
      type: "employee",
      title: "Inactive Employee Alert",
      description: "Admin 'Siti Aminah' (Kasir) has not logged into the POS system for the past 3 days. Please check their active status.",
      time: "1h ago",
      isRead: false,
    },
    {
      id: 3,
      type: "stock",
      title: "Low Stock Alert: Tinta Printer Epson Black",
      description: "Inventory for 'Tinta Epson 664 Black' has dropped to 1 bottle. Immediate restock required.",
      time: "Yesterday",
      isRead: true, // Ini ceritanya udah dibaca
    }
  ]);

  // Fungsi tandai semua dibaca
  const markAllAsRead = () => {
    setNotifications(notifications.map(n => ({ ...n, isRead: true })));
  };

  // Fungsi hapus/dismiss notif
  const dismissNotification = (id: number) => {
    setNotifications(notifications.filter(n => n.id !== id));
  };

  return (
    <div className="w-full pb-12">
      {/* HEADER */}
      <div className="flex justify-between items-end mb-6">
        <div>
          <h1 className="text-3xl font-bold text-zinc-900 mb-1">Notifikasi</h1>
          <p className="text-sm text-zinc-500 font-medium">Atur notifikasi & update sistem.</p>
        </div>
        
        <button 
          onClick={markAllAsRead}
          className="flex items-center gap-2 px-4 py-2 bg-zinc-100 text-zinc-600 rounded-lg text-xs font-bold hover:bg-zinc-200 transition"
        >
          <CheckCheck size={16} />
          Mark All as Read
        </button>
      </div>

      {/* CONTAINER LIST NOTIFIKASI */}
      <div className="bg-white rounded-xl border border-zinc-200 shadow-sm overflow-hidden mb-6">
        {notifications.length > 0 ? (
          notifications.map((notif) => (
            <NotificationItem 
              key={notif.id} 
              notif={notif} 
              onDismiss={dismissNotification} 
            />
          ))
        ) : (
          <div className="p-12 text-center flex flex-col items-center">
            <CheckCheck size={40} className="text-zinc-300 mb-3" />
            <p className="text-sm font-bold text-zinc-500">Semua notifikasi sudah dibaca</p>
            <p className="text-xs text-zinc-400 mt-1">Belum ada peringatan baru hari ini.</p>
          </div>
        )}
      </div>

      {/* TOMBOL LOAD MORE */}
      {notifications.length > 0 && (
        <div className="flex justify-center">
          <button className="px-6 py-2 bg-zinc-50 border border-zinc-200 text-zinc-500 rounded-lg text-xs font-bold hover:bg-zinc-100 hover:text-zinc-700 transition shadow-sm">
            Load More
          </button>
        </div>
      )}

    </div>
  );
}