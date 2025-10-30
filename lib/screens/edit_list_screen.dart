import 'package:flutter/material.dart';
import '../models/habit.dart';
import 'package:uuid/uuid.dart';

class EditHabitScreen extends StatefulWidget {
  final Habit? habit;
  const EditHabitScreen({super.key, this.habit});

  @override
  State<EditHabitScreen> createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends State<EditHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _title;
  late TextEditingController _desc;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.habit?.title ?? '');
    _desc = TextEditingController(text: widget.habit?.description ?? '');
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final id = widget.habit?.id ?? const Uuid().v4();
    final newHabit = Habit(
      id: id,
      title: _title.text,
      description: _desc.text,
      completionsIso: widget.habit?.completionsIso ?? [],
    );
    Navigator.pop(context, newHabit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit == null ? 'Новая привычка' : 'Редактировать привычку'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(labelText: 'Название привычки'),
                validator: (v) => v == null || v.isEmpty ? 'Введите название' : null,
              ),
              TextFormField(
                controller: _desc,
                decoration: const InputDecoration(labelText: 'Описание (необязательно)'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _save,
                child: const Text('Сохранить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}