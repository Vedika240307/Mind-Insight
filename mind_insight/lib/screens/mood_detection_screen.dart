import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:permission_handler/permission_handler.dart';

class MoodDetectionScreen extends StatefulWidget {
  const MoodDetectionScreen({super.key});

  @override
  State<MoodDetectionScreen> createState() => _MoodDetectionScreenState();
}

class _MoodDetectionScreenState extends State<MoodDetectionScreen> {
  CameraController? _cameraController;
  FaceDetector? _faceDetector;
  bool _isProcessing = false;
  String _mood = '😐';
  Timer? _timer;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _initializeMoodDetection();
  }

  Future<void> _initializeMoodDetection() async {
    await _initializeCamera();
    _initializeFaceDetector();

    // Automatically detect every 2 seconds
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _detectMoodAutomatically();
    });
  }

  Future<void> _initializeCamera() async {
    if (await Permission.camera.request().isGranted) {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      if (!mounted) return;
      setState(() {});
    } else {
      debugPrint("❌ Camera permission denied");
    }
  }

  void _initializeFaceDetector() {
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true,
        enableContours: false,
        enableLandmarks: false,
        minFaceSize: 0.05,
        performanceMode: FaceDetectorMode.fast,
      ),
    );
  }

  Future<void> _detectMoodAutomatically() async {
    if (_isProcessing ||
        _cameraController == null ||
        !_cameraController!.value.isInitialized) {
      return;
    }

    _isProcessing = true;

    try {
      final XFile file = await _cameraController!.takePicture();
      final inputImage = InputImage.fromFilePath(file.path);
      final faces = await _faceDetector!.processImage(inputImage);

      if (faces.isNotEmpty) {
        final face = faces.first;
        final smileProb = face.smilingProbability ?? 0.0;
        final leftEyeOpenProb = face.leftEyeOpenProbability ?? 0.0;
        final rightEyeOpenProb = face.rightEyeOpenProbability ?? 0.0;

        String detectedMood;

        if (smileProb > 0.8 &&
            leftEyeOpenProb > 0.7 &&
            rightEyeOpenProb > 0.7) {
          detectedMood = '😀 Happy';
        } else if (smileProb > 0.5) {
          detectedMood = '😊 Calm';
        } else if (smileProb > 0.3) {
          detectedMood = '😐 Neutral';
        } else if (smileProb > 0.15) {
          detectedMood = '😔 Sad';
        } else {
          detectedMood = '😢 Depressed';
        }

        setState(() => _mood = detectedMood);

        // ✅ Save mood to Firestore automatically
        await _saveMoodToFirestore(detectedMood, smileProb);
      }

      // delete temp file if exists
      try {
        if (await File(file.path).exists()) {
          await File(file.path).delete();
        }
      } catch (_) {}
    } catch (e) {
      debugPrint("⚠️ Mood detection error: $e");
    } finally {
      _isProcessing = false;
    }
  }

  /// Save mood dynamically per user in 'mood_detection_data' collection
  Future<void> _saveMoodToFirestore(String mood, double smileProb) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final moodRef = _firestore
          .collection('mood_detection_data')
          .doc(user.uid)
          .collection('mood_entries')
          .doc(DateTime.now().toIso8601String());

      await moodRef.set({
        'userId': user.uid,
        'moodScore': (smileProb * 10).round(), // optional numeric score
        'moodLabel': mood,
        'timestamp': FieldValue.serverTimestamp(),
        'notes': '', // optional notes
        'recommendation': '', // optional recommendation
      });
    } catch (e) {
      debugPrint("Error saving mood to Firestore: $e");
    }
  }

  String getExerciseForMood(String mood) {
    if (mood.contains('Happy')) {
      return '🎵 Do a 15-min dance workout or brisk walk!';
    } else if (mood.contains('Calm')) {
      return '🧘 Try meditation or breathing exercises for 10 mins.';
    } else if (mood.contains('Neutral')) {
      return '🏃 Go for light jogging or stretching.';
    } else if (mood.contains('Sad')) {
      return '🎶 Listen to uplifting music and do yoga.';
    } else {
      return '💬 Talk to a friend or counselor today.';
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cameraController?.dispose();
    _faceDetector?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mood Detection"),
        backgroundColor: const Color(0xFFE91E63),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: SizedBox(
                width: 300,
                height: 300,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CameraPreview(_cameraController!),
                    Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.pinkAccent, width: 3),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Detected Mood: $_mood",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            getExerciseForMood(_mood),
            style: const TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Text(
            "📊 Mood data is being saved for your progress report.",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
