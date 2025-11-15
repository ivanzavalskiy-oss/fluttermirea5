import 'package:flutter/material.dart';
import '../models/habit.dart';

class StatsScreen extends StatefulWidget {
  final bool embedMode;
  const StatsScreen({super.key, this.embedMode = false});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  List<Habit> _habits = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await Habit.load();
    setState(() {
      _habits = data;
      _loading = false;
    });
  }

  int _totalCompletions() => _habits.fold(0, (s, h) => s + h.completionsIso.length);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.embedMode ? null : AppBar(title: const Text('Статистика')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Всего привычек: ${_habits.length}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Всего выполнений: ${_totalCompletions()}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            const Text('Серии (топ 5):', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: _habits
                    .map((h) => ListTile(
                  title: Text(h.title),
                  subtitle: Text('Выполнений: ${h.completionsIso.length}'),
                ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
