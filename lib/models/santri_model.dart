class Santri {
  final String id;
  final String namaLengkap;
  final String namaPanggilan;
  final String tempatLahir;
  final DateTime tanggalLahir;
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

  factory Santri.fromMap(Map<String, dynamic> data, String id) {
    return Santri(
      id: id,
      namaLengkap: data['namaLengkap'] ?? '',
      namaPanggilan: data['namaPanggilan'] ?? '',
      tempatLahir: data['tempatLahir'] ?? '',
      tanggalLahir: data['tanggalLahir'] != null 
          ? DateTime.parse(data['tanggalLahir']) 
          : DateTime.now(),
      jenisKelamin: data['jenisKelamin'] ?? '',
      fotoUrl: data['fotoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'namaLengkap': namaLengkap,
      'namaPanggilan': namaPanggilan,
      'tempatLahir': tempatLahir,
      'tanggalLahir': tanggalLahir.toIso8601String(),
      'jenisKelamin': jenisKelamin,
      'fotoUrl': fotoUrl,
    };
  }
}