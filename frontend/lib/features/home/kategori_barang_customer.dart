import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/base_header_widget.dart';

class KategoriBarangPage extends StatefulWidget {
  // Tambahkan parameter initialCategory (opsional, default 'Semua')
  final String initialCategory;
  final List<dynamic> apiCategories;

  const KategoriBarangPage({
    Key? key,
    this.initialCategory = 'Semua',
    required this.apiCategories, // Wajib diisi saat pindah halaman
  }) : super(key: key);

  @override
  State<KategoriBarangPage> createState() => _KategoriBarangPageState();
}

class _KategoriBarangPageState extends State<KategoriBarangPage> {
  final ScrollController _scrollController = ScrollController();

  // Biarkan kosong dulu, kita isi di initState
  List<String> categories = [];
  late String selectedCategory;

  @override
  void initState() {
    super.initState();

    // 1. Masukkan opsi 'Semua' di awal slider
    categories.add('Semua');

    // 2. Ambil semua namaKategori dari database dan masukkan ke dalam list slider
    for (var k in widget.apiCategories) {
      categories.add(k.namaKategori);
    }

    // 3. Set kategori yang aktif sesuai yang diklik dari halaman Home
    if (categories.contains(widget.initialCategory)) {
      selectedCategory = widget.initialCategory;
    } else {
      selectedCategory = 'Semua';
    }

    // 2. Jalankan fungsi scroll otomatis setelah UI selesai digambar oleh Flutter
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedCategory();
    });
  }

  void _scrollToSelectedCategory() {
    int index = categories.indexOf(selectedCategory);

    // Jika index ditemukan dan bukan 'Semua' (index 0 tidak perlu digeser karena sudah di paling kiri)
    if (index > 0) {
      // 95.0 adalah estimasi lebar (lebar box + margin) tiap item kategori dalam pixel.
      // Kamu bisa menaikkan/menurunkan angka ini sedikit agar pas di tengah layar.
      double targetOffset = index * 95.0;

      // Cek apakah posisi scroll saat ini belum melampaui batas maksimum scroll ListView
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          targetOffset,
          duration: const Duration(
            milliseconds: 300,
          ), // Kecepatan geser (300 ms)
          curve: Curves.easeInOut, // Efek animasi halus
        );
      }
    }
  }

  // 4. Hapus controller dari memori saat halaman ditutup untuk mencegah memory leak
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // 2. Dummy Data Produk Sesuai Gambar
  final List<Map<String, dynamic>> products = [
    {
      'title': 'Totebag Wanita Kuliah',
      'price': 'Rp. 200.000',
      'image':
          'https://via.placeholder.com/150', // Ganti dengan asset/network image aslimu
      'category': 'Totebag',
    },
    {
      'title': 'Tas Punggung Laptop',
      'price': 'Rp. 400.000',
      'image': 'https://via.placeholder.com/150',
      'category': 'Laptop',
    },
    {
      'title': 'Tas Ransel Wanita',
      'price': 'Rp. 300.000',
      'image': 'https://via.placeholder.com/150',
      'category': 'Ransel',
    },
    {
      'title': 'Tas Selempang Wanita',
      'price': 'Rp. 200.000',
      'image': 'https://via.placeholder.com/150',
      'category': 'Selempang',
    },
    {
      'title': 'Tas Laptop Wanita',
      'price': 'Rp. 200.000',
      'image': 'https://via.placeholder.com/150',
      'category': 'Laptop',
    },
    {
      'title': 'Tas Bahu Pria',
      'price': 'Rp. 355.000',
      'image': 'https://via.placeholder.com/150',
      'category': 'Pria',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // 3. Filter produk berdasarkan kategori yang dipilih
    List<Map<String, dynamic>> filteredProducts = selectedCategory == 'Semua'
        ? products
        : products.where((p) => p['category'] == selectedCategory).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      // Custom Header sesuai warna cokelat di gambar
      appBar: BaseHeaderWidget(
        title: 'Kategori Barang',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // ==================== BOX KATEGORI HORIZONTAL ====================
          SizedBox(
            height: 40,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                bool isSelected = categories[index] == selectedCategory;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = categories[index];
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFAD510D)
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFAD510D)
                            : Colors.transparent,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // ==================== GRID BARANG / PRODUK ====================
          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(child: Text('Tidak ada produk di kategori ini.'))
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 2 Kolom ke samping
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio:
                              0.75, // Mengatur rasio tinggi vs lebar card
                        ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final item = filteredProducts[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Box Gambar dengan Border Rounded Grey tipis
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  24,
                                ), // Sesuai lengkungan di gambar
                                border: Border.all(
                                  color: Colors.blueGrey.shade100,
                                  width: 1,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(23),
                                child: Image.network(
                                  item['image']!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.image,
                                      color: Colors.grey,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Nama Produk
                          Text(
                            item['title']!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          // Harga Produk (Bold)
                          Text(
                            item['price']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
