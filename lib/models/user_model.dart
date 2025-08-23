import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String fullName;
  final String gender;
  final String phoneNumber;
  final String address;
  final String email;
  final Timestamp? lastLogin;
  final List<String> santriIds;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.gender,
    required this.phoneNumber,
    required this.address,
    required this.email,
    this.lastLogin,
    this.santriIds = const [],
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      uid: documentId,
      fullName: data['namaLengkap'] ?? '',
      gender: data['jenisKelamin'] ?? '',
      phoneNumber: data['nomorHp'] ?? '',
      address: data['alamatLengkap'] ?? '',
      email: data['emailPengguna'] ?? '',
      lastLogin: data['lastLogin'],
      santriIds: List<String>.from(data['santriIds'] ?? []),
    );
  }
}
