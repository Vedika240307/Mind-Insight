import 'package:flutter/material.dart';
import 'therapy_session_page.dart';
import 'depression_course_page.dart';
import 'group_therapy_page.dart';
import 'motivational_videos_page.dart';
import 'counseling_session_page.dart';
import 'chatbot_screen.dart'; // ✅ Import your chatbot screen

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      {
        "title": "Therapy Sessions",
        "icon": Icons.self_improvement,
        "page": const TherapySessionPage(),
      },
      {
        "title": "Depression Management Course",
        "icon": Icons.psychology,
        "page": const DepressionCoursePage(),
      },
      {
        "title": "Group Therapy",
        "icon": Icons.groups,
        "page": const GroupTherapyPage(),
      },
      {
        "title": "Motivational Videos",
        "icon": Icons.video_library,
        "page": const MotivationalVideosPage(),
      },
      {
        "title": "Counseling Session",
        "icon": Icons.headset_mic,
        "page": const CounselingSessionPage(),
      },
      {
        "title": "AI Chatbot",
        "icon": Icons.chat,
        "page": const ChatbotScreen(), // ✅ Chatbot added directly
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F6),
      appBar: AppBar(
        title: const Text(
          "Our Services",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFE91E63),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        padding: const EdgeInsets.all(16),
        children: services.map((service) {
          return _buildServiceCard(
            context,
            service["icon"] as IconData,
            service["title"] as String,
            service["page"] as Widget,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    IconData icon,
    String title,
    Widget page,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12, width: 2),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(2, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFFE91E63), size: 45),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
