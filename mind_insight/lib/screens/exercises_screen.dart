import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/exercise_service.dart';

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({super.key});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  String searchQuery = "";
  final ExerciseService _exerciseService = ExerciseService();

  Future<void> _launchVideo(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open video link")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color pink = Color(0xFFE91E63);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F6),
      appBar: AppBar(
        title: const Text('Exercises & Yoga'),
        backgroundColor: pink,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: pink),
                hintText: "Search exercises or yoga...",
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _exerciseService.getExercisesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: pink),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error loading exercises: ${snapshot.error}'),
                  );
                }

                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return const Center(
                    child: Text('No exercises found. Add some in Firestore!'),
                  );
                }

                // Filter results based on search query
                final filteredDocs = docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>? ?? {};
                  final name = (data['Name'] ?? '').toString().toLowerCase();
                  final category = (data['Category'] ?? '')
                      .toString()
                      .toLowerCase();
                  final description = (data['Description'] ?? '')
                      .toString()
                      .toLowerCase();
                  return name.contains(searchQuery) ||
                      category.contains(searchQuery) ||
                      description.contains(searchQuery);
                }).toList();

                if (filteredDocs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No matching exercises found.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final data =
                        filteredDocs[index].data() as Map<String, dynamic>? ??
                        {};
                    final name = data['Name'] ?? 'Untitled Exercise';
                    final category = data['Category'] ?? 'Unknown';
                    final description =
                        data['Description'] ?? 'No description available.';
                    final benefits = data['Benefits'] ?? 'Not specified';
                    final duration = data['Duration'] ?? 'N/A';
                    final imageUrl = data['ImgUrl'] ?? '';
                    final instructions =
                        data['Instructions'] ?? 'No instructions available.';
                    final videoUrl = data['VideoUrl'] ?? '';

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: ListTile(
                        leading: imageUrl.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  imageUrl,
                                  width: 55,
                                  height: 55,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.self_improvement,
                                    color: pink,
                                    size: 40,
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.self_improvement,
                                color: pink,
                                size: 40,
                              ),
                        title: Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          '$category\n🕒 $duration',
                          style: const TextStyle(color: Colors.black87),
                        ),
                        trailing: const Icon(
                          Icons.keyboard_arrow_right,
                          color: pink,
                        ),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder: (context) => Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        name,
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    if (imageUrl.isNotEmpty)
                                      Center(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Image.network(
                                            imageUrl,
                                            height: 180,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                const Icon(
                                                  Icons.self_improvement,
                                                  color: pink,
                                                  size: 80,
                                                ),
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 15),
                                    Text(
                                      '🏷 Category: $category',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '🧠 Benefits:\n$benefits',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '📖 Description:\n$description',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '🕒 Duration: $duration',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    const Text(
                                      '🧘 Instructions:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      instructions,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    if (videoUrl.isNotEmpty)
                                      Center(
                                        child: ElevatedButton.icon(
                                          onPressed: () =>
                                              _launchVideo(videoUrl),
                                          icon: const Icon(Icons.play_arrow),
                                          label: const Text(
                                            "Watch Instruction Video",
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: pink,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
