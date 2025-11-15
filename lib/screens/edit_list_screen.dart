import 'package:flutter/material.dart';
import '../models/habit.dart';
import 'package:uuid/uuid.dart';

class EditHabitScreen extends StatefulWidget {
  final Habit? habit;
  final bool embedMode;
  const EditHabitScreen({super.key, this.habit, this.embedMode = false});

  @override
  State<EditHabitScreen> createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends State<EditHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _title;
  late TextEditingController _desc;
  String _selectedIcon = '';

  final _availableIcons = [
    'https://cdn-icons-png.flaticon.com/512/4150/4150897.png', // вода
    'https://cdn-icons-png.flaticon.com/512/4150/4150922.png', // сон
    'https://cdn-icons-png.flaticon.com/512/1694/1694611.png', // чистые руки
    'https://cdn-icons-png.flaticon.com/512/3075/3075977.png', // еда
    'https://cdn-icons-png.flaticon.com/512/3448/3448724.png', // спорт
  ];

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.habit?.title ?? '');
    _desc = TextEditingController(text: widget.habit?.description ?? '');
    _selectedIcon = widget.habit?.iconUrl ?? '';
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final id = widget.habit?.id ?? const Uuid().v4();
    final newHabit = Habit(
      id: id,
      title: _title.text,
      description: _desc.text,
      iconUrl: _selectedIcon,
      completionsIso: widget.habit?.completionsIso ?? [],
    );
    Navigator.pop(context, newHabit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.embedMode ? null : AppBar(title: Text(widget.habit == null ? 'Новая привычка' : 'Редактировать привычку')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
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
              const Text('Выберите иконку:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                children: _availableIcons.map((url) {
                  final selected = url == _selectedIcon;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIcon = url),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selected ? Colors.indigo : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.network(url, width: 60, height: 60),
                    ),
                  );
                }).toList(),
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
