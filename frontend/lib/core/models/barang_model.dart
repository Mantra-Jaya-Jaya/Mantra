class BarangModel {
  final int idBarang;
  final String namaBarang;
  final String gambarBarang;
  final String deskripsi;

  BarangModel({
    required this.idBarang,
    required this.namaBarang,
    required this.gambarBarang,
    required this.deskripsi,
  });

  factory BarangModel.fromJson(Map<String, dynamic> json) {
    return BarangModel(
      idBarang: json['id_barang'],
      namaBarang: json['nama_barang'],
      gambarBarang: json['gambar_barang'],
      deskripsi: json['deskripsi'],
    );
  }
}
