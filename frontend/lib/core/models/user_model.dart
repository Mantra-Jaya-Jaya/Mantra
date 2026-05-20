class UserModel {
  final String idUser;
  final String username;
  final String email;
  final String namaLengkap;
  final String role;
  final String? profileId;
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
      idUser: (json['id_user'] ?? json['public_id'] ?? '').toString(),
      username: json['username'],
      email: json['email'] ?? '',
      namaLengkap: json['nama_lengkap'],
      role: json['role'],
      profileId: json['profile_id']?.toString(),
      fotoProfil: json['foto_profil'],
    );
  }
}
