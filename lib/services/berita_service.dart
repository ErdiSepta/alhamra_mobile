import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alhamra_1/models/berita_model.dart';

class BeritaService {
  final CollectionReference _beritaCollection =
      FirebaseFirestore.instance.collection('berita');

  Future<List<Berita>> getBerita() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _beritaCollection.orderBy('publishedAt', descending: true).get()
              as QuerySnapshot<Map<String, dynamic>>;
      return querySnapshot.docs.map((doc) => Berita.fromFirestore(doc)).toList();
    } catch (e) {
      // Handle error, misalnya dengan logging atau melempar exception kembali
      print('Error getting berita: $e');
      return [];
    }
  }
}