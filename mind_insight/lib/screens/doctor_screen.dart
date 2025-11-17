import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/doctor_service.dart';
import '../screens/chat_screen.dart'; // Import your ChatScreen

class DoctorScreen extends StatelessWidget {
  const DoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color pink = Color(0xFFE91E63);
    final DoctorService doctorService = DoctorService();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F6),
      appBar: AppBar(
        title: const Text(
          "Available Doctors",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: pink,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: doctorService.getDoctorsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Error loading doctors 😢",
                style: TextStyle(color: Colors.black),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: pink));
          }

          final data = snapshot.data!.docs;

          if (data.isEmpty) {
            return const Center(
              child: Text(
                "No doctors found 🩺",
                style: TextStyle(color: Colors.black),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final doctor = data[index].data() as Map<String, dynamic>;

              final name = doctor['Name'] ?? 'Unknown Doctor';
              final specialization =
                  doctor['Specialization'] ?? 'Not specified';
              final contact = doctor['Contact'] ?? 'Not available';
              final fee = doctor['Fee']?.toString() ?? 'N/A';
              final rating = doctor['Rating']?.toString() ?? 'N/A';
              final imageUrl = doctor['Image'] ?? '';
              final doctorUid = doctor['uid'] ?? data[index].id;

              return Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        leading: CircleAvatar(
                          radius: 35,
                          backgroundImage: (imageUrl.isNotEmpty)
                              ? NetworkImage(imageUrl)
                              : const AssetImage('assets/default_doctor.png')
                                    as ImageProvider,
                        ),
                        title: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                specialization,
                                style: const TextStyle(color: Colors.black87),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Fee: ₹$fee | Rating: ⭐ $rating",
                                style: const TextStyle(color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "📅 Appointment booked with $name",
                                  ),
                                  backgroundColor: pink,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: pink,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 20,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                            ),
                            icon: const Icon(Icons.calendar_month),
                            label: const Text(
                              "Book Appointment",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          // ✅ Chat Button
                          ElevatedButton.icon(
                            onPressed: () async {
                              final user = FirebaseAuth.instance.currentUser;
                              if (user == null) return;

                              final chatId = _generateChatId(
                                user.uid,
                                doctorUid,
                              );

                              // Create chat doc if not exists
                              final chatRef = FirebaseFirestore.instance
                                  .collection('chats')
                                  .doc(chatId);
                              final chatSnapshot = await chatRef.get();
                              if (!chatSnapshot.exists) {
                                await chatRef.set({
                                  'userId': user.uid,
                                  'doctorId': doctorUid,
                                  'doctorName': name,
                                  'createdAt': Timestamp.now(),
                                });
                              }

                              // Navigate to ChatScreen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChatScreen(
                                    chatId: chatId,
                                    doctorId: doctorUid,
                                    doctorName: name,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 20,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                            ),
                            icon: const Icon(Icons.chat),
                            label: const Text(
                              "Chat",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          IconButton(
                            icon: const Icon(
                              Icons.phone,
                              color: pink,
                              size: 30,
                            ),
                            onPressed: () async {
                              final Uri phoneUri = Uri(
                                scheme: 'tel',
                                path: contact,
                              );
                              if (await canLaunchUrl(phoneUri)) {
                                await launchUrl(phoneUri);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("📞 Call $contact"),
                                    backgroundColor: pink,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Helper function to create unique chatId
  String _generateChatId(String userId, String doctorId) {
    final ids = [userId, doctorId]..sort();
    return ids.join('_');
  }
}
