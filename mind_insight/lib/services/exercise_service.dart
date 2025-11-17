import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseService {
  final CollectionReference _exerciseCollection = FirebaseFirestore.instance
      .collection('exercise_yoga');

  /// Add a new exercise if it does not exist
  Future<void> addExercise({
    required String id,
    required String name,
    required String category,
    String description = '',
    String benefits = '',
    String instructions = '',
    String duration = 'N/A',
    String imageUrl = '',
    String videoUrl = '',
  }) async {
    final docRef = _exerciseCollection.doc(id);
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      await docRef.set({
        'Name': name,
        'Category': category,
        'Description': description,
        'Benefits': benefits,
        'Instructions': instructions,
        'Duration': duration,
        'ImgUrl': imageUrl,
        'VideoUrl': videoUrl,
      });
    }
  }

  /// Stream of exercises for real-time updates
  Stream<QuerySnapshot> getExercisesStream() {
    return _exerciseCollection.snapshots();
  }
}
