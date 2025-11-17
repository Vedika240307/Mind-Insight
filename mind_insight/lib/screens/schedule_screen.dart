import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart'; // ✅ for formatting Month & Year

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final TextEditingController taskController = TextEditingController();

  // Store tasks per date
  final Map<DateTime, List<String>> _tasks = {};

  void _addTask() {
    if (_selectedDay == null) return;
    final task = taskController.text.trim();
    if (task.isEmpty) return;

    setState(() {
      _tasks[_selectedDay!] = (_tasks[_selectedDay!] ?? [])..add(task);
      taskController.clear();
    });
  }

  List<String> _getTasksForDay(DateTime day) {
    return _tasks[day] ?? [];
  }

  // 📅 Function to show month & year picker (2000–2999)
  Future<void> _pickYearMonth() async {
    DateTime initialDate = _focusedDay;
    DateTime firstDate = DateTime(2000); // 👈 Start year
    DateTime lastDate = DateTime(2999); // 👈 End year

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: "Select Year & Month",
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    if (picked != null) {
      setState(() {
        _focusedDay = DateTime(picked.year, picked.month, 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String monthYear = DateFormat.yMMMM().format(_focusedDay);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEB81BB),
        title: const Text(
          'Schedule',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🗓 Month-Year Row + Picker Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  monthYear,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEB81BB),
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: _pickYearMonth,
                  child: const Icon(
                    Icons.arrow_drop_down,
                    color: Color(0xFFEB81BB),
                    size: 32,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // 📅 Calendar (Year range extended)
            TableCalendar(
              firstDay: DateTime.utc(2000, 1, 1), // 👈 Start from 2000
              lastDay: DateTime.utc(2999, 12, 31), // 👈 Up to 2999
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Color(0xFFEB81BB),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Color(0xFFEB81BB),
                  shape: BoxShape.circle,
                ),
              ),
              headerVisible: false,
            ),

            const SizedBox(height: 10),

            // ✏️ Task Input
            TextField(
              controller: taskController,
              decoration: const InputDecoration(
                labelText: 'Add a task for selected date',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _addTask(),
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: _addTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEB81BB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Add Task'),
            ),

            const SizedBox(height: 20),

            // 📋 Task List
            Expanded(
              child: _selectedDay == null
                  ? const Center(child: Text('Select a date to see tasks'))
                  : _getTasksForDay(_selectedDay!).isEmpty
                  ? const Center(child: Text('No tasks for this date'))
                  : ListView.builder(
                      itemCount: _getTasksForDay(_selectedDay!).length,
                      itemBuilder: (context, index) {
                        final task = _getTasksForDay(_selectedDay!)[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: const Icon(
                              Icons.check_circle_outline,
                              color: Color(0xFFEB81BB),
                            ),
                            title: Text(task),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
