import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ProgressReportScreen extends StatefulWidget {
  const ProgressReportScreen({super.key});

  @override
  State<ProgressReportScreen> createState() => _ProgressReportScreenState();
}

class _ProgressReportScreenState extends State<ProgressReportScreen> {
  Map<String, int> moodCount = {'😀': 0, '😊': 0, '😐': 0, '😔': 0, '😢': 0};
  bool isLoading = true;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadMoodData();
  }

  Future<void> _loadMoodData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      // ✅ Correct Firestore collection according to MoodDetectionScreen
      final snapshot = await FirebaseFirestore.instance
          .collection('mood_detection_data')
          .doc(user.uid)
          .collection('mood_entries')
          .orderBy('timestamp', descending: true)
          .limit(50)
          .get();

      Map<String, int> updatedMoodCount = {
        '😀': 0,
        '😊': 0,
        '😐': 0,
        '😔': 0,
        '😢': 0,
      };

      for (var doc in snapshot.docs) {
        final mood = doc['moodLabel']?.toString() ?? "";

        if (mood.contains('Happy')) {
          updatedMoodCount['😀'] = updatedMoodCount['😀']! + 1;
        } else if (mood.contains('Calm')) {
          updatedMoodCount['😊'] = updatedMoodCount['😊']! + 1;
        } else if (mood.contains('Neutral')) {
          updatedMoodCount['😐'] = updatedMoodCount['😐']! + 1;
        } else if (mood.contains('Sad')) {
          updatedMoodCount['😔'] = updatedMoodCount['😔']! + 1;
        } else if (mood.contains('Depressed')) {
          updatedMoodCount['😢'] = updatedMoodCount['😢']! + 1;
        }
      }

      setState(() {
        moodCount = updatedMoodCount;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("⚠️ Error loading mood data: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const pink = Color(0xFFE91E63);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F6),
      appBar: AppBar(
        title: const Text(
          "Progress Report",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: pink,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Your Weekly Mood Report 📊",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 30),

                  Expanded(
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY:
                            (moodCount.values.reduce((a, b) => a > b ? a : b) +
                                    2)
                                .toDouble(),
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.black,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                rod.toY.toInt().toString(),
                                const TextStyle(color: Colors.white),
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                const emojis = ['😀', '😊', '😐', '😔', '😢'];
                                return Text(
                                  emojis[value.toInt()],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        barGroups: [
                          for (int i = 0; i < moodCount.length; i++)
                            BarChartGroupData(
                              x: i,
                              barRods: [
                                BarChartRodData(
                                  toY: moodCount.values.elementAt(i).toDouble(),
                                  color: Colors.black,
                                  width: 22,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Text(
                    "Most frequent mood: ${_getMostFrequentMood()}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  String _getMostFrequentMood() {
    final sorted = moodCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.first.key;
  }
}
