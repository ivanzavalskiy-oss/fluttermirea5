import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../widgets/habit_card.dart';
import 'edit_list_screen.dart';
import 'habit_detail_screen.dart';

class HabitListScreen extends StatefulWidget {
  final bool embedInPageView;
  const HabitListScreen({super.key, this.embedInPageView = false});

  @override
  State<HabitListScreen> createState() => _HabitListScreenState();
}

class _HabitListScreenState extends State<HabitListScreen> {
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

  Future<void> _save() async => Habit.save(_habits);

  Future<void> _addHabit() async {
    final newHabit = await Navigator.push<Habit>(
      context,
      MaterialPageRoute(builder: (_) => const EditHabitScreen()),
    );
    if (newHabit != null) {
      setState(() => _habits.add(newHabit));
      await _save();
    }
  }

  Future<void> _openEdit(Habit h) async {
    final edited = await Navigator.push<Habit>(
      context,
      MaterialPageRoute(builder: (_) => EditHabitScreen(habit: h)),
    );
    if (edited != null) {
      final idx = _habits.indexWhere((e) => e.id == edited.id);
      if (idx >= 0) {
        setState(() => _habits[idx] = edited);
        await _save();
      }
    }
  }

  Future<void> _delete(Habit h) async {
    setState(() => _habits.removeWhere((e) => e.id == h.id));
    await _save();
  }

  void _openDetails(Habit h) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HabitDetailScreen(
          habit: h,
          onUpdated: (updated) async {
            final idx = _habits.indexWhere((e) => e.id == updated.id);
            if (idx >= 0) {
              setState(() => _habits[idx] = updated);
              await _save();
            }
          },
        ),
      ),
    );
  }

  void _openDetailsNamed(Habit h) {
    Navigator.pushNamed(context, '/detail', arguments: h);
  }

  void _showNavigationChoiceDialog(Habit h) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Как открыть экран?"),
          content: const Text("Выберите тип навигации:"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _openDetails(h);
              },
              child: const Text("Обычный переход"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _openDetailsNamed(h);
              },
              child: const Text("Named Route"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.embedInPageView ? null : AppBar(title: const Text('Мои привычки')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addHabit,
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _habits.isEmpty
          ? const Center(child: Text('Нет привычек. Добавьте новую!'))
          : ListView.builder(
        itemCount: _habits.length,
        itemBuilder: (_, i) {
          final h = _habits[i];
          return HabitCard(
            habit: h,
            onTap: () => _showNavigationChoiceDialog(h),
            onDelete: () => _delete(h),
            onEdit: () => _openEdit(h),
          );
        },
      ),
    );
  }
}