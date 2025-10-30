import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../widgets/completion_title.dart';

class HabitDetailScreen extends StatefulWidget {
  final Habit habit;
  final Function(Habit) onUpdated;

  const HabitDetailScreen({super.key, required this.habit, required this.onUpdated});

  @override
  State<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  late Habit _habit;

  @override
  void initState() {
    super.initState();
    _habit = widget.habit;
  }

  void _toggleToday() {
    final today = _todayIso();
    setState(() => _habit.toggleCompletion(today));
    widget.onUpdated(_habit);
  }

  String _todayIso() {
    final d = DateTime.now();
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final today = _todayIso();
    final completed = _habit.isCompleted(today);

    return Scaffold(
      appBar: AppBar(title: Text(_habit.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_habit.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _toggleToday,
              icon: Icon(completed ? Icons.check : Icons.circle_outlined),
              label: Text(completed ? 'Отменить выполнение' : 'Отметить выполненной'),
            ),
            const SizedBox(height: 20),
            const Text('История выполнений:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: _habit.completionsIso
                    .map((date) => CompletionTile(date: date))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}