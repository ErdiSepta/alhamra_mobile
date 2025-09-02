import 'package:alhamra_1/models/berita_model.dart';

class BeritaService {
  // Static berita data for testing
  static final List<Map<String, dynamic>> _staticBerita = [
    {
      'id': 'berita_001',
      'title': 'Kegiatan Pembelajaran Tahfidz Al-Quran',
      'content': 'Santri-santri Alhamra menunjukkan kemajuan yang luar biasa dalam program tahfidz Al-Quran. Dengan bimbingan ustadz yang berpengalaman, para santri berhasil menghafal dengan baik dan benar.',
      'imageUrl': 'https://example.com/images/tahfidz.jpg',
      'thumbnailUrl': 'https://example.com/images/tahfidz_thumb.jpg',
      'publishedAt': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      'author': 'Admin Alhamra',
    },
    {
      'id': 'berita_002',
      'title': 'Peringatan Maulid Nabi Muhammad SAW',
      'content': 'Pondok Pesantren Alhamra mengadakan peringatan Maulid Nabi Muhammad SAW dengan berbagai kegiatan rohani dan ceramah agama yang menginspirasi.',
      'imageUrl': 'https://example.com/images/maulid.jpg',
      'thumbnailUrl': 'https://example.com/images/maulid_thumb.jpg',
      'publishedAt': DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
      'author': 'Ustadz Ahmad',
    },
    {
      'id': 'berita_003',
      'title': 'Kegiatan Olahraga dan Kesehatan Santri',
      'content': 'Para santri mengikuti kegiatan olahraga rutin untuk menjaga kesehatan jasmani. Kegiatan ini meliputi sepak bola, bulu tangkis, dan senam pagi.',
      'imageUrl': 'https://example.com/images/olahraga.jpg',
      'thumbnailUrl': 'https://example.com/images/olahraga_thumb.jpg',
      'publishedAt': DateTime.now().subtract(const Duration(days: 7)).toIso8601String(),
      'author': 'Ustadz Budi',
    },
    {
      'id': 'berita_004',
      'title': 'Program Keterampilan dan Kemandirian',
      'content': 'Santri diajarkan berbagai keterampilan praktis seperti pertanian, kerajinan tangan, dan teknologi informasi untuk mempersiapkan masa depan mereka.',
      'imageUrl': 'https://example.com/images/keterampilan.jpg',
      'thumbnailUrl': 'https://example.com/images/keterampilan_thumb.jpg',
      'publishedAt': DateTime.now().subtract(const Duration(days: 10)).toIso8601String(),
      'author': 'Ustadzah Siti',
    },
  ];

  Future<List<Berita>> getBerita() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Convert static data to Berita objects and sort by publishedAt (newest first)
      List<Berita> beritaList = _staticBerita
          .map((data) => Berita.fromMap(data, data['id']))
          .toList();
      
      // Sort by publishedAt descending (newest first)
      beritaList.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
      
      return beritaList;
    } catch (e) {
      print('Error getting berita: $e');
      return [];
    }
  }
}