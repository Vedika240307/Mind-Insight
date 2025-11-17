// lib/services/tracking_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TrackingService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> saveMood({
    required String mood,
    String? note,
    double? smileProbability,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('No authenticated user');

    await _firestore
        .collection('mood_records')
        .doc(uid)
        .collection('entries')
        .add({
          'userId': uid,
          'mood': mood,
          'note': note ?? '',
          'smileProbability': smileProbability ?? 0,
          'timestamp': FieldValue.serverTimestamp(),
        });
  }

  Future<void> saveSleep({
    required double sleepHours,
    required String start,
    required String end,
    required double goal,
    DateTime? date,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('No authenticated user');
    final d = date ?? DateTime.now();
    final dateKey = d.toIso8601String().split('T').first; // yyyy-MM-dd

    await _firestore
        .collection('sleep_records')
        .doc(uid)
        .collection('entries')
        .doc(dateKey)
        .set({
          'userId': uid,
          'date': dateKey,
          'start': start,
          'end': end,
          'hours': sleepHours,
          'goal': goal,
          'timestamp': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }

  Future<void> saveExercise({
    required String exerciseName,
    required int minutes,
    double? calories,
    DateTime? date,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('No authenticated user');
    final d = date ?? DateTime.now();

    await _firestore
        .collection('exercise_progress')
        .doc(uid)
        .collection('entries')
        .add({
          'userId': uid,
          'exerciseName': exerciseName,
          'minutes': minutes,
          'calories': calories ?? 0,
          'date': d.toIso8601String().split('T').first,
          'timestamp': FieldValue.serverTimestamp(),
        });
  }
}
