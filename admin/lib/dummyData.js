// lib/dummyData.js

export const statData = [
  { title: "Total Revenue", value: "Rp 45.2M", trend: "+15.3%", type: "increase" },
  { title: "Total Orders", value: "1,250", trend: "+5.2%", type: "increase" },
  { title: "Active Customers", value: "854", trend: "+2.1%", type: "increase" },
  { title: "Low Stock Items", value: "12", trend: "Requires immediate attention", type: "danger" },
];

const generateRawChartData = () => {
  const data = [];
  const start = new Date(2025, 0, 1);
  const end = new Date(2026, 11, 31);
  
  for (let d = new Date(start); d <= end; d.setDate(d.getDate() + 1)) {
    // Format YYYY-MM-DD biar kayak API aslinya
    const dateStr = d.toISOString().split('T')[0]; 
    data.push({
      date: dateStr,
      // Acak pendapatan harian Rp 1jt - Rp 6jt
      total: Math.floor(Math.random() * 5000000) + 1000000 
    });
  }
  return data;
};

export const rawChartData = generateRawChartData();

export const criticalStockData = [
  { id: 1, nama: "Kopi Arabica 1kg", sisa: 5, status: "kritis" },
  { id: 2, nama: "Gula Aren Cair 500ml", sisa: 12, status: "warning" },
  { id : 3, nama: "Susu Kental Manis 370g", sisa: 3, status: "kritis" },
  { id : 4, nama: "Coklat Bubuk 250g", sisa: 50, status: "warning" },
];

export const transactionData = Array.from({ length: 48 }).map((_, i) => ({
  id: `TRX-${1000 + i}`,
  kasir: i % 2 === 0 ? "Budi Santoso" : "Siti Aminah",
  pelanggan: `Pelanggan ${i + 1}`,
  tanggal: "12 Oct 2023, 14:30",
  total: `Rp ${(Math.floor(Math.random() * 50) + 10) * 100}.000`,
  status: i % 3 === 0 ? "Proses" : i % 5 === 0 ? "Batal" : "Selesai"
}));