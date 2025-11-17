import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  TimeOfDay? _sleepStart;
  TimeOfDay? _sleepEnd;
  double _sleepHours = 0;
  final double _goalHours = 8; // 💤 Daily goal
  bool _saving = false;

  final _firestore = FirebaseFirestore.instance;

  // ⏱️ Pick sleep start time
  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _sleepStart = picked);
    }
  }

  // ⏱️ Pick sleep end time
  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && _sleepStart != null) {
      setState(() {
        _sleepEnd = picked;
        _calculateSleepDuration();
      });
    }
  }

  // 🧮 Calculate total hours slept
  void _calculateSleepDuration() {
    if (_sleepStart == null || _sleepEnd == null) return;

    final now = DateTime.now();
    DateTime start = DateTime(
      now.year,
      now.month,
      now.day,
      _sleepStart!.hour,
      _sleepStart!.minute,
    );
    DateTime end = DateTime(
      now.year,
      now.month,
      now.day,
      _sleepEnd!.hour,
      _sleepEnd!.minute,
    );

    // If user slept past midnight
    if (end.isBefore(start)) {
      end = end.add(const Duration(days: 1));
    }

    final diff = end.difference(start).inMinutes / 60;
    setState(() => _sleepHours = double.parse(diff.toStringAsFixed(1)));
  }

  // ☁️ Save to Firebase
  Future<void> _saveSleepData() async {
    if (_sleepStart == null || _sleepEnd == null) return;
    setState(() => _saving = true);

    try {
      final date = DateFormat('yyyy-MM-dd').format(DateTime.now());

      await _firestore.collection('sleep_records').doc(date).set({
        'date': date,
        'start': _sleepStart!.format(context),
        'end': _sleepEnd!.format(context),
        'hours': _sleepHours,
        'goal': _goalHours,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sleep record saved successfully! 💫')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_sleepHours / _goalHours).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F6),
      appBar: AppBar(
        title: const Text(
          "Sleep Tracker",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xFFE91E63),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🌀 Circular Progress
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 180,
                  width: 180,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    backgroundColor: Colors.pink.shade100,
                    color: const Color(0xFFE91E63),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${(progress * 100).toInt()}%",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE91E63),
                      ),
                    ),
                    Text(
                      "of goal",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),

            Text(
              "Slept: ${_sleepHours.toStringAsFixed(1)} hrs / Goal: $_goalHours hrs",
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
            const SizedBox(height: 20),

            _sleepStart != null
                ? Text(
                    "Start: ${_sleepStart!.format(context)}",
                    style: const TextStyle(fontSize: 16),
                  )
                : const Text(
                    "Select sleep start time",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),

            _sleepEnd != null
                ? Text(
                    "End: ${_sleepEnd!.format(context)}",
                    style: const TextStyle(fontSize: 16),
                  )
                : const SizedBox(),

            const SizedBox(height: 30),

            // 🌙 Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickStartTime,
                  icon: const Icon(Icons.nightlight_round, color: Colors.white),
                  label: const Text("Start Sleep"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E63),
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _pickEndTime,
                  icon: const Icon(Icons.wb_sunny, color: Colors.white),
                  label: const Text("End Sleep"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade300,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: _saving ? null : _saveSleepData,
              icon: const Icon(Icons.cloud_upload),
              label: _saving
                  ? const Text("Saving...")
                  : const Text("Save Record"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E63),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
