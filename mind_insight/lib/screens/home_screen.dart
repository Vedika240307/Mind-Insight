import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mind_insight/services/firestore_initializer.dart';

// Screens
import 'package:mind_insight/screens/blogs_screen.dart';
import 'package:mind_insight/screens/chatbot_screen.dart';
import 'package:mind_insight/screens/doctor_screen.dart';
import 'package:mind_insight/screens/emergency_screen.dart';
import 'package:mind_insight/screens/exercises_screen.dart';
import 'package:mind_insight/screens/feedback_screen.dart';
import 'package:mind_insight/screens/mood_detection_screen.dart';
import 'package:mind_insight/screens/progress_report_screen.dart';
import 'package:mind_insight/screens/schedule_screen.dart';
import 'package:mind_insight/screens/services_screen.dart';
import 'package:mind_insight/screens/sleep_screen.dart';
import 'package:mind_insight/screens/login_screen.dart';

// Temporary placeholders if not created yet
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: const Center(child: Text("Profile Screen")),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: const Center(child: Text("Settings Screen")),
    );
  }
}

// 🩷 MAIN HOME SCREEN
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    FirestoreInitializer.initialize(); // 🔥 Auto-create all collections
  }

  @override
  Widget build(BuildContext context) {
    const Color pink = Color(0xFFE91E63);
    const Color background = Color(0xFFFFF0F6);
    const Color textColor = Colors.black;
    const Color cardColor = Colors.white;
    const Color dividerColor = Colors.black54;

    User? user = _auth.currentUser;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: pink,
        elevation: 2,
        iconTheme: const IconThemeData(color: textColor),
        title: const Text(
          "Mind Insight",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      // 🩷 Drawer
      drawer: Drawer(
        backgroundColor: cardColor,
        width: MediaQuery.of(context).size.width * 0.65,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFFFFF0F5)),
              accountName: Text(
                user?.displayName ?? "Mind Insight User",
                style: const TextStyle(color: textColor),
              ),
              accountEmail: Text(
                user?.email ?? user?.phoneNumber ?? "No contact info",
                style: TextStyle(color: textColor.withOpacity(0.7)),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: pink,
                child: Icon(Icons.person, color: Colors.white, size: 35),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.person, color: textColor),
              title: const Text("Profile", style: TextStyle(color: textColor)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.settings, color: textColor),
              title: const Text("Settings", style: TextStyle(color: textColor)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),

            const Divider(color: dividerColor),

            ListTile(
              leading: const Icon(Icons.logout, color: textColor),
              title: const Text("Logout", style: TextStyle(color: textColor)),
              onTap: () async {
                await _auth.signOut();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),

      // 🏠 Main Grid
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              "Fight For Bright",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // All Feature Cards
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
                children: [
                  _buildCard(
                    context,
                    Icons.people,
                    "Doctor Counselling",
                    const DoctorScreen(),
                    pink,
                    cardColor,
                    textColor,
                  ),
                  _buildCard(
                    context,
                    Icons.miscellaneous_services,
                    "Services",
                    const ServicesScreen(),
                    pink,
                    cardColor,
                    textColor,
                  ),
                  _buildCard(
                    context,
                    Icons.mood,
                    "Mood Tracker",
                    const MoodDetectionScreen(),
                    pink,
                    cardColor,
                    textColor,
                  ),
                  _buildCard(
                    context,
                    Icons.nightlight_round,
                    "Sleep Tracker",
                    const SleepScreen(),
                    pink,
                    cardColor,
                    textColor,
                  ),
                  _buildCard(
                    context,
                    Icons.fitness_center,
                    "Exercise",
                    const ExercisesScreen(),
                    pink,
                    cardColor,
                    textColor,
                  ),
                  _buildCard(
                    context,
                    Icons.calendar_month,
                    "Schedule",
                    const ScheduleScreen(),
                    pink,
                    cardColor,
                    textColor,
                  ),
                  _buildCard(
                    context,
                    Icons.article,
                    "Blogs",
                    const BlogsScreen(),
                    pink,
                    cardColor,
                    textColor,
                  ),
                  _buildCard(
                    context,
                    Icons.insert_chart,
                    "Progress Report",
                    const ProgressReportScreen(),
                    pink,
                    cardColor,
                    textColor,
                  ),
                  _buildCard(
                    context,
                    Icons.local_hospital,
                    "Emergency",
                    const EmergencyScreen(),
                    pink,
                    cardColor,
                    textColor,
                  ),
                  _buildCard(
                    context,
                    Icons.feedback,
                    "Feedback",
                    const FeedbackScreen(),
                    pink,
                    cardColor,
                    textColor,
                  ),
                  _buildCard(
                    context,
                    Icons.smart_toy,
                    "Chatbot",
                    const ChatbotScreen(),
                    pink,
                    cardColor,
                    textColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🟣 Reusable Feature Card Widget
  Widget _buildCard(
    BuildContext context,
    IconData icon,
    String title,
    Widget page,
    Color pink,
    Color cardColor,
    Color textColor,
  ) {
    return GestureDetector(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          border: Border.all(color: textColor.withOpacity(0.6), width: 1.5),
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: pink, size: 40),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
