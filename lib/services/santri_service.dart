import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alhamra_1/models/santri_model.dart';

class SantriService {
  final CollectionReference _santriCollection =
      FirebaseFirestore.instance.collection('santri');

  // Fetches a list of Santri documents based on a list of their IDs.
  Future<List<Santri>> getSantriByIds(List<String> ids) async {
    if (ids.isEmpty) {
      return []; // Return empty list if there are no IDs to fetch.
    }

    try {
      // Use a 'whereIn' query to fetch all documents where the document ID is in the provided list.
      // Note: 'whereIn' can handle a maximum of 30 equality clauses.
      final querySnapshot = await _santriCollection
          .where(FieldPath.documentId, whereIn: ids)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return [];
      }

      // Map the documents to a list of Santri objects.
      return querySnapshot.docs
          .map((doc) =>
              Santri.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      print('Error fetching santri by IDs: $e');
      // Depending on the use case, you might want to rethrow the error or handle it differently.
      return [];
    }
  }
}