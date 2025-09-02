import 'package:alhamra_1/models/santri_model.dart';

class SantriService {
  // Static santri data for testing
  static final List<Map<String, dynamic>> _staticSantri = [
    {
      'id': 'santri_001',
      'namaLengkap': 'Muhammad Rizki Pratama',
      'namaPanggilan': 'Rizki',
      'tempatLahir': 'Jakarta',
      'tanggalLahir': DateTime(2010, 5, 15).toIso8601String(),
      'jenisKelamin': 'Laki-laki',
      'fotoUrl': 'https://example.com/photos/rizki.jpg',
    },
    {
      'id': 'santri_002',
      'namaLengkap': 'Ahmad Fauzi Rahman',
      'namaPanggilan': 'Fauzi',
      'tempatLahir': 'Bandung',
      'tanggalLahir': DateTime(2011, 8, 22).toIso8601String(),
      'jenisKelamin': 'Laki-laki',
      'fotoUrl': 'https://example.com/photos/fauzi.jpg',
    },
    {
      'id': 'santri_003',
      'namaLengkap': 'Fatimah Azzahra',
      'namaPanggilan': 'Fatimah',
      'tempatLahir': 'Surabaya',
      'tanggalLahir': DateTime(2012, 3, 10).toIso8601String(),
      'jenisKelamin': 'Perempuan',
      'fotoUrl': 'https://example.com/photos/fatimah.jpg',
    },
    {
      'id': 'santri_004',
      'namaLengkap': 'Abdullah Al-Farisi',
      'namaPanggilan': 'Abdullah',
      'tempatLahir': 'Medan',
      'tanggalLahir': DateTime(2009, 12, 5).toIso8601String(),
      'jenisKelamin': 'Laki-laki',
      'fotoUrl': 'https://example.com/photos/abdullah.jpg',
    },
    {
      'id': 'santri_005',
      'namaLengkap': 'Khadijah Nur Hidayah',
      'namaPanggilan': 'Khadijah',
      'tempatLahir': 'Yogyakarta',
      'tanggalLahir': DateTime(2013, 7, 18).toIso8601String(),
      'jenisKelamin': 'Perempuan',
      'fotoUrl': 'https://example.com/photos/khadijah.jpg',
    },
  ];

  // Fetches a list of Santri documents based on a list of their IDs.
  Future<List<Santri>> getSantriByIds(List<String> ids) async {
    if (ids.isEmpty) {
      return []; // Return empty list if there are no IDs to fetch.
    }

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Filter static data by the provided IDs
      List<Map<String, dynamic>> filteredData = _staticSantri
          .where((santri) => ids.contains(santri['id']))
          .toList();

      if (filteredData.isEmpty) {
        return [];
      }

      // Map the filtered data to a list of Santri objects.
      return filteredData
          .map((data) => Santri.fromMap(data, data['id']))
          .toList();
    } catch (e) {
      print('Error fetching santri by IDs: $e');
      return [];
    }
  }

  // Get all santri (useful for testing)
  Future<List<Santri>> getAllSantri() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      return _staticSantri
          .map((data) => Santri.fromMap(data, data['id']))
          .toList();
    } catch (e) {
      print('Error fetching all santri: $e');
      return [];
    }
  }
}