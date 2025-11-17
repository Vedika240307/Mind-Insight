import 'package:flutter/material.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE91E63),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "About Mind Insight",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Logo
              Center(
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.black26, width: 2),
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Color(0xFFE91E63),
                    size: 60,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Center(
                child: Text(
                  "Mind Insight",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE91E63),
                  ),
                ),
              ),

              const SizedBox(height: 5),

              const Center(
                child: Text(
                  "Your Mental Wellness Companion",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "What is Mind Insight?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE91E63),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Mind Insight is a mental wellness application designed to help users manage stress, "
                "depression, anxiety, and emotional imbalance. It provides tools like mood tracking, "
                "doctor consultation, meditation, daily exercises, and personalized reports.",
                style: TextStyle(fontSize: 15, color: Colors.black87),
              ),

              const SizedBox(height: 22),

              const Text(
                "Features Included:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE91E63),
                ),
              ),
              const SizedBox(height: 10),

              _featureItem("• Mood Tracker"),
              _featureItem("• Meditation & Yoga Sessions"),
              _featureItem("• Depression Management Program"),
              _featureItem("• Online Doctor Consultation"),
              _featureItem("• Daily Exercises"),
              _featureItem("• AI Chatbot for Mental Support"),
              _featureItem("• Personalized Progress Reports"),
              _featureItem("• Schedule Planner"),

              const SizedBox(height: 25),

              const Text(
                "Our Mission",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE91E63),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Our mission is to help individuals build a healthier mind through guidance, "
                "self-care practices, expert support, and daily motivation.",
                style: TextStyle(fontSize: 15, color: Colors.black87),
              ),

              const SizedBox(height: 25),

              const Text(
                "Developed By:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE91E63),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "👩‍💻 Developed by:\n"
                "1] Siddhi Kakade\n"
                "2] Vedika Barde\n"
                "3] Sakshi Dhakane\n",
                style: TextStyle(fontSize: 15, color: Colors.black87),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _featureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 15, color: Colors.black87),
      ),
    );
  }
}
