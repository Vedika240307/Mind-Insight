import 'package:flutter/material.dart';

class VideoCallScreen extends StatelessWidget {
  final String roomName;
  final String subject;
  final String doctorId;
  final String doctorName;

  const VideoCallScreen({
    super.key,
    required this.roomName,
    required this.subject,
    required this.doctorId,
    required this.doctorName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Call with Dr. $doctorName'),
        backgroundColor: const Color(0xFFE91E63),
      ),
      body: const Center(
        child: Text(
          'Video call feature coming soon.\n(Room will open here.)',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
