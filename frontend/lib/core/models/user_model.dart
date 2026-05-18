class UserModel {
  final int idUser;
  final String username;
  final String email;
  final String namaLengkap;
  final String role;
  final int? profileId;
  final String? fotoProfil;

  UserModel({
    required this.idUser,
    required this.username,
    required this.email,
    required this.namaLengkap,
    required this.role,
    this.profileId,
    this.fotoProfil,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idUser: json['id_user'],
      username: json['username'],
      email: json['email'] ?? '',
      namaLengkap: json['nama_lengkap'],
      role: json['role'],
      profileId: json['profile_id'],
      fotoProfil: json['foto_profil'],
    );
  }
}
