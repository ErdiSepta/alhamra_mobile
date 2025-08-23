import 'package:cloud_firestore/cloud_firestore.dart';

class Santri {
  final String id;
  final String namaLengkap;
  final String namaPanggilan;
  final String tempatLahir;
  final Timestamp tanggalLahir;
  final String jenisKelamin;
  final String? fotoUrl;

  Santri({
    required this.id,
    required this.namaLengkap,
    required this.namaPanggilan,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.jenisKelamin,
    this.fotoUrl,
  });

  factory Santri.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data()!;
    return Santri(
      id: doc.id,
      namaLengkap: data['namaLengkap'] ?? '',
      namaPanggilan: data['namaPanggilan'] ?? '',
      tempatLahir: data['tempatLahir'] ?? '',
      tanggalLahir: data['tanggalLahir'] ?? Timestamp.now(),
      jenisKelamin: data['jenisKelamin'] ?? '',
      fotoUrl: data['fotoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'namaLengkap': namaLengkap,
      'namaPanggilan': namaPanggilan,
      'tempatLahir': tempatLahir,
      'tanggalLahir': tanggalLahir,
      'jenisKelamin': jenisKelamin,
      'fotoUrl': fotoUrl,
    };
  }
}