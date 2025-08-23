import 'package:cloud_firestore/cloud_firestore.dart';

class SeederService {
  final CollectionReference _beritaCollection =
      FirebaseFirestore.instance.collection('berita');
  final CollectionReference _santriCollection =
      FirebaseFirestore.instance.collection('santri');

  Future<void> seedAll() async {
    print('[Seeder] Starting to seed all data...');
    await seedBerita();
    await seedDummySantri();
    print('[Seeder] Seeding process finished.');
  }

  Future<void> seedDummySantri() async {
    try {
      print('[Seeder] Checking for existing santri data...');
      QuerySnapshot snapshot = await _santriCollection.limit(1).get();
      if (snapshot.docs.isEmpty) {
        print('[Seeder] No santri data found. Seeding 4 dummy santri...');

        await _addSantri('Muhammad Ainul Fikri', 'Fikri', 'Malang',
            Timestamp.fromDate(DateTime(2016, 2, 16)), 'Laki-Laki');
        await _addSantri('Budi Doremi', 'Budi', 'Yogyakarta',
            Timestamp.fromDate(DateTime(2017, 5, 20)), 'Laki-Laki');
        await _addSantri('Citra Lestari', 'Citra', 'Bandung',
            Timestamp.fromDate(DateTime(2015, 9, 1)), 'Perempuan');
        await _addSantri('Dewi Anggraini', 'Dewi', 'Surabaya',
            Timestamp.fromDate(DateTime(2016, 11, 12)), 'Perempuan');

        print('[Seeder] Successfully seeded 4 santri.');
      } else {
        print('[Seeder] Santri data already exists. Skipping santri seeding.');
      }
    } catch (e) {
      print('[Seeder] ERROR during seedDummySantri: $e');
    }
  }

  Future<void> seedBerita() async {
    try {
      print('[Seeder] Checking for existing berita data...');
      QuerySnapshot snapshot = await _beritaCollection.limit(1).get();
      if (snapshot.docs.isEmpty) {
        print('[Seeder] No berita data found. Seeding new berita...');
        await _addBerita(
          'SMA Ar-Rohmah Putra IBS Juara Umum OSN-P 2025 Se-Kabupaten Malang, Ungguli Semua Sekolah Negeri',
          'Konten berita lengkap di sini...',
          'https://firebasestorage.googleapis.com/v0/b/alhamra-2024.appspot.com/o/berita%2Fberita_1.png?alt=media&token=c1f8a8b1-3e5e-4b9b-9a5c-5e6a8e3d8f4e',
          'https://firebasestorage.googleapis.com/v0/b/alhamra-2024.appspot.com/o/berita%2Fthumbnail_1.png?alt=media&token=c1f8a8b1-3e5e-4b9b-9a5c-5e6a8e3d8f4e',
          Timestamp.fromDate(DateTime(2025, 7, 21, 18, 11)),
        );
        // Add more news items if you want
        print('[Seeder] Seeded berita items.');
      } else {
        print('[Seeder] Berita data already exists. Skipping berita seeding.');
      }
    } catch (e) {
      print('[Seeder] ERROR during seedBerita: $e');
    }
  }

  Future<void> _addBerita(String title, String content, String imageUrl,
      String thumbnailUrl, Timestamp publishedAt) {
    return _beritaCollection.add({
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'thumbnailUrl': thumbnailUrl,
      'publishedAt': publishedAt,
      'author': 'Al-Hamra News',
    });
  }

  Future<DocumentReference> _addSantri(
      String namaLengkap,
      String namaPanggilan,
      String tempatLahir,
      Timestamp tanggalLahir,
      String jenisKelamin) {
    return _santriCollection.add({
      'namaLengkap': namaLengkap,
      'namaPanggilan': namaPanggilan,
      'tempatLahir': tempatLahir,
      'tanggalLahir': tanggalLahir,
      'jenisKelamin': jenisKelamin,
      'fotoUrl': null,
    });
  }
}