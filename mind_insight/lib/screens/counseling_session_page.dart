import 'package:flutter/material.dart';

class CounselingSessionPage extends StatelessWidget {
  const CounselingSessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final counselors = [
      {"name": "Dr. Riya Kapoor", "specialization": "Family & Youth Counselor"},
      {
        "name": "Dr. Pranav Joshi",
        "specialization": "Stress Management Expert",
      },
      {
        "name": "Dr. Ayesha Khan",
        "specialization": "Anxiety & Depression Specialist",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F6),
      appBar: AppBar(
        title: const Text(
          "Counseling Sessions",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFE91E63),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Our Professional Counselors",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE91E63),
            ),
          ),
          const SizedBox(height: 10),
          ...counselors.map(
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
                        content: Text("Session booked with ${d["name"]}"),
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
