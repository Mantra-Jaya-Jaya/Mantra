class AlamatModel {
  // Kita gunakan publicId sebagai string UUID untuk keperluan di Flutter
  final String idAlamat;
  final String publicId;
  final String
  idCustomer; // Menampung UUID/Public ID milik Customer jika dikirim dari backend
  final String namaPenerima;
  final String labelAlamat;
  final String noTelpPenerima; // Tambahkan ini karena ada di backend-mu
  final String alamatLengkap;
  final double latitude;
  final double longitude;
  final String catatanLokasi;
  final bool isUtama;

  AlamatModel({
    required this.idAlamat,
    required this.publicId,
    required this.idCustomer,
    required this.namaPenerima,
    required this.labelAlamat,
    required this.noTelpPenerima,
    required this.alamatLengkap,
    required this.latitude,
    required this.longitude,
    required this.catatanLokasi,
    required this.isUtama,
  });

  factory AlamatModel.fromJson(Map<String, dynamic> json) {
    return AlamatModel(
      idAlamat: json['id_alamat']?.toString() ?? '',
      publicId: json['public_id']?.toString() ?? '',
      idCustomer: json['id_customer']?.toString() ?? '',

      namaPenerima: json['nama_penerima']?.toString() ?? '',
      labelAlamat: json['label_alamat']?.toString() ?? '',

      // 3. Tambahkan no_telp_penerima sesuai model backend
      noTelpPenerima: json['no_telp_penerima']?.toString() ?? '',

      alamatLengkap: json['alamat_lengkap']?.toString() ?? '',

      // 4. Parsing angka desimal dengan aman
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,

      catatanLokasi: json['catatan_lokasi']?.toString() ?? '',
      isUtama: json['is_utama'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_alamat': idAlamat,
      'public_id': publicId,
      'id_customer': idCustomer,
      'nama_penerima': namaPenerima,
      'label_alamat': labelAlamat,
      'no_telp_penerima': noTelpPenerima,
      'alamat_lengkap': alamatLengkap,
      'latitude': latitude,
      'longitude': longitude,
      'catatan_lokasi': catatanLokasi,
      'is_utama': isUtama,
    };
  }
}
