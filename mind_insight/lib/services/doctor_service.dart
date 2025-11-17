import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorService {
  final CollectionReference _doctorsCollection = FirebaseFirestore.instance
      .collection('doctors');

  /// Add a new doctor (if not already exists)
  Future<void> addDoctor({
    required String id,
    required String name,
    required String specialization,
    required String contact,
    required double fee,
    required double rating,
    String imageUrl = '',
  }) async {
    final docRef = _doctorsCollection.doc(id);

    final docSnapshot = await docRef.get();
    if (!docSnapshot.exists) {
      await docRef.set({
        'Name': name,
        'Specialization': specialization,
        'Contact': contact,
        'Fee': fee,
        'Rating': rating,
        'Image': imageUrl,
      });
    }
  }

  /// Get all doctors ordered by name
  Stream<QuerySnapshot> getDoctorsStream() {
    return _doctorsCollection.orderBy('Name').snapshots();
  }
}
