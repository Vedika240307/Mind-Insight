import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> addMoodEntry(
  int moodScore,
  String moodLabel,
  String notes,
  String recommendation,
) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return; // User not logged in

  final moodRef = FirebaseFirestore.instance
      .collection('mood_detection_data')
      .doc(user.uid) // User document
      .collection('mood_entries') // Subcollection
      .doc(DateTime.now().toIso8601String()); // Mood entry document

  await moodRef.set({
    'userId': user.uid,
    'moodScore': moodScore,
    'moodLabel': moodLabel,
    'timestamp': FieldValue.serverTimestamp(),
    'notes': notes,
    'recommendation': recommendation,
  });

  print("Mood entry added for ${user.uid}");
}
