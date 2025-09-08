class UserModel {
  final String uid;
  final String fullName;
  final String gender;
  final String phoneNumber;
  final String address;
  final String email;
  final DateTime? lastLogin;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.gender,
    required this.phoneNumber,
    required this.address,
    required this.email,
    this.lastLogin,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      uid: documentId,
      fullName: data['namaLengkap'] ?? '',
      gender: data['jenisKelamin'] ?? '',
      phoneNumber: data['nomorHp'] ?? '',
      address: data['alamatLengkap'] ?? '',
      email: data['emailPengguna'] ?? '',
      lastLogin: data['lastLogin'] != null ? DateTime.parse(data['lastLogin']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'namaLengkap': fullName,
      'jenisKelamin': gender,
      'nomorHp': phoneNumber,
      'alamatLengkap': address,
      'emailPengguna': email,
      'lastLogin': lastLogin?.toIso8601String(),
    };
  }
}
