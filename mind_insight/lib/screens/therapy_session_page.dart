import 'package:flutter/material.dart';

class TherapySessionPage extends StatelessWidget {
  const TherapySessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final therapies = [
      "Cognitive Behavioral Therapy (CBT)",
      "Mindfulness-Based Stress Reduction",
      "Art & Music Therapy",
      "Dialectical Behavior Therapy (DBT)",
      "Emotion-Focused Therapy",
      "Couple & Family Therapy",
    ];

    final doctors = [
      {"name": "Dr. Neha Patil", "specialization": "Clinical Psychologist"},
      {"name": "Dr. Rohan Mehta", "specialization": "Therapist & Life Coach"},
      {"name": "Dr. Anjali Sharma", "specialization": "Cognitive Therapist"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Therapy Sessions",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFE91E63),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFFFF0F6),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Available Therapies",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE91E63),
            ),
          ),
          const SizedBox(height: 10),
          ...therapies.map(
            (t) => Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.spa, color: Color(0xFFE91E63)),
                title: Text(t),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Our Experts",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE91E63),
            ),
          ),
          const SizedBox(height: 10),
          ...doctors.map(
            (d) => Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE91E63),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(d["name"]!),
                subtitle: Text(d["specialization"]!),
                trailing: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Booked session with ${d["name"]}"),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E63),
                  ),
                  child: const Text("Book"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
