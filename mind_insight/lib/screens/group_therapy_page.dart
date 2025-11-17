import 'package:flutter/material.dart';

class GroupTherapyPage extends StatelessWidget {
  const GroupTherapyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final groups = [
      {"title": "Anxiety Support Group", "time": "Mon 5 PM"},
      {"title": "Stress Relief Group", "time": "Wed 7 PM"},
      {"title": "Positive Mindset Circle", "time": "Fri 6 PM"},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F6),
      appBar: AppBar(
        title: const Text(
          "Group Therapy",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFE91E63),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Available Groups",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE91E63),
            ),
          ),
          const SizedBox(height: 10),
          ...groups.map(
            (g) => Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.group, color: Color(0xFFE91E63)),
                title: Text(g["title"]!),
                subtitle: Text("Next Session: ${g["time"]}"),
                trailing: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Joined ${g["title"]}")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E63),
                  ),
                  child: const Text("Join"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
