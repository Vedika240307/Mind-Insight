import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreInitializer {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // MAIN FUNCTION
  static Future<void> initialize() async {
    final User? user = _auth.currentUser;
    if (user == null) return;

    String uid = user.uid;

    await _createUserDocument(uid);
    await _createDoctorsCollection();
    await _createExerciseCollection();
    await _createBlogCollection();
    await _createMotivationalVideos();
    await _createCoursesCollection();
    await _createTrackerCollections(uid);
    await _createChatbotCollection(uid);
  }

  // 1️⃣ USER DOCUMENT
  static Future<void> _createUserDocument(String uid) async {
    final userDoc = _firestore.collection('users').doc(uid);

    if (!(await userDoc.get()).exists) {
      await userDoc.set({
        'name': 'New User',
        'email': _auth.currentUser!.email,
        'createdAt': DateTime.now(),
        'profileImage': '',
      });
    }
  }

  // 2️⃣ DOCTORS COLLECTION
  static Future<void> _createDoctorsCollection() async {
    final doctors = _firestore.collection('doctors');

    if ((await doctors.get()).docs.isEmpty) {
      await doctors.add({
        'name': 'Dr. A Sharma',
        'specialization': 'Psychologist',
        'experience': '7 years',
      });

      await doctors.add({
        'name': 'Dr. B Singh',
        'specialization': 'Therapist',
        'experience': '5 years',
      });
    }
  }

  // 3️⃣ EXERCISE / YOGA COLLECTION
  static Future<void> _createExerciseCollection() async {
    final exercise = _firestore.collection('exercise_yoga');

    if ((await exercise.get()).docs.isEmpty) {
      await exercise.add({
        'title': 'Breathing Exercise',
        'duration': '5 minutes',
        'description': 'Calm breathing session',
      });

      await exercise.add({
        'title': 'Stretch & Relax',
        'duration': '10 minutes',
        'description': 'Body relaxation yoga',
      });
    }
  }

  // 4️⃣ BLOGS COLLECTION
  static Future<void> _createBlogCollection() async {
    final blogs = _firestore.collection('blogs');

    if ((await blogs.get()).docs.isEmpty) {
      await blogs.add({
        'title': 'How to Manage Stress',
        'content': 'Simple ways to stay mentally healthy...',
        'author': 'Admin',
      });

      await blogs.add({
        'title': '5 Tips for Better Sleep',
        'content': 'Follow these steps for quality sleep...',
        'author': 'Admin',
      });
    }
  }

  // 5️⃣ MOTIVATIONAL VIDEOS
  static Future<void> _createMotivationalVideos() async {
    final videos = _firestore.collection('motivational_videos');

    if ((await videos.get()).docs.isEmpty) {
      await videos.add({
        'title': 'Stay Positive',
        'url': 'https://youtu.be/example1',
      });

      await videos.add({
        'title': 'Never Give Up',
        'url': 'https://youtu.be/example2',
      });
    }
  }

  // 6️⃣ DEPRESSION MANAGEMENT COURSE
  static Future<void> _createCoursesCollection() async {
    final courses = _firestore.collection('depression_courses');

    if ((await courses.get()).docs.isEmpty) {
      await courses.add({
        'title': 'Depression Management Course',
        'description': 'Step-by-step guided recovery plan',
        'duration': '7 Days',
      });
    }
  }

  // 7️⃣ TRACKERS (Mood, Sleep, Schedule)
  static Future<void> _createTrackerCollections(String uid) async {
    final mood = _firestore.collection('mood_tracker');
    final sleep = _firestore.collection('sleep_tracker');
    final schedule = _firestore.collection('schedules');

    if ((await mood.doc(uid).get()).exists == false) {
      await mood.doc(uid).set({'createdAt': DateTime.now()});
    }

    if ((await sleep.doc(uid).get()).exists == false) {
      await sleep.doc(uid).set({'createdAt': DateTime.now()});
    }

    if ((await schedule.doc(uid).get()).exists == false) {
      await schedule.doc(uid).set({'createdAt': DateTime.now()});
    }
  }

  // 8️⃣ CHATBOT MESSAGES COLLECTION
  static Future<void> _createChatbotCollection(String uid) async {
    final chatbot = _firestore.collection('chatbot_messages').doc(uid);

    if (!(await chatbot.get()).exists) {
      await chatbot.set({
        'messages': [
          {
            'sender': 'bot',
            'message': 'Hello! How can I help you today?',
            'timestamp': DateTime.now(),
          },
        ],
      });
    }
  }
}
