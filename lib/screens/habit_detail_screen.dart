import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
          children: [
            if (_habit.iconUrl.isNotEmpty)
              CachedNetworkImage(
                imageUrl: _habit.iconUrl,
                height: 120,
                width: 120,
                placeholder: (_, __) => const CircularProgressIndicator(),
                errorWidget: (_, __, ___) => const Icon(Icons.image_not_supported, size: 80),
              ),
            const SizedBox(height: 16),
            Text(_habit.description.isNotEmpty ? _habit.description : 'Без описания', textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _toggleToday,
              icon: Icon(completed ? Icons.check : Icons.radio_button_unchecked),
              label: Text(completed ? 'Отменить выполнение' : 'Отметить выполненной'),
            ),
            const SizedBox(height: 20),
            const Align(alignment: Alignment.centerLeft, child: Text('История выполнений:', style: TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(children: _habit.completionsIso.map((d) => CompletionTile(date: d)).toList()),
            ),
          ],
        ),
      ),
    );
  }
}
