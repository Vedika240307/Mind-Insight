import 'package:flutter/material.dart';

class DepressionCoursePage extends StatelessWidget {
  const DepressionCoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    final modules = [
      "Understanding Depression",
      "Coping Techniques & Journaling",
      "Self-Care & Mindfulness",
      "Positive Thinking Exercises",
      "Healing Through Routine",
      "Building a Support System",
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F6),
      appBar: AppBar(
        title: const Text(
          "Depression Management",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFE91E63),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Course Modules",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE91E63),
            ),
          ),
          const SizedBox(height: 10),
          ...modules.map(
            (m) => Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                leading: const Icon(Icons.book, color: Color(0xFFE91E63)),
                title: Text(m),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("You have enrolled successfully!"),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE91E63),
              minimumSize: const Size(double.infinity, 50),
            ),
            icon: const Icon(Icons.play_circle_fill),
            label: const Text("Start Course"),
          ),
        ],
      ),
    );
  }
}
