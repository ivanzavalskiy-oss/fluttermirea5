import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/habit.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const HabitCard({
    super.key,
    required this.habit,
    required this.onTap,
    required this.onDelete,
    required this.onEdit,
  });

  String _todayIso() {
    final d = DateTime.now();
    return "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
  }

  String _subtitle() {
    final today = _todayIso();
    return habit.isCompleted(today) ? "Выполнено сегодня" : "Не выполнено";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: habit.iconUrl.isNotEmpty
            ? CachedNetworkImage(
          imageUrl: habit.iconUrl,
          placeholder: (_, __) => const SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          errorWidget: (_, __, ___) => const Icon(Icons.image_not_supported),
          width: 48,
          height: 48,
        )
            : const Icon(Icons.task_alt, size: 40),
        title: Text(habit.title),
        subtitle: Text(_subtitle()),
        onTap: onTap,
        trailing: PopupMenuButton(
          onSelected: (value) {
            if (value == 'edit') onEdit();
            if (value == 'delete') onDelete();
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'edit', child: Text("Изменить")),
            PopupMenuItem(value: 'delete', child: Text("Удалить")),
          ],
        ),
      ),
    );
  }
}
