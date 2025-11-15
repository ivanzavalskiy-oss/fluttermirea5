import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Habit {
  String id;
  String title;
  String description;
  String iconUrl;
  bool daily;
  List<String> completionsIso;

  Habit({
    required this.id,
    required this.title,
    this.description = '',
    this.iconUrl = '',
    this.daily = true,
    List<String>? completionsIso,
  }) : completionsIso = completionsIso ?? [];


  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'iconUrl': iconUrl,
    'daily': daily,
    'completionsIso': completionsIso,
  };


  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
    id: json['id'],
    title: json['title'],
    description: json['description'] ?? '',
    iconUrl: json['iconUrl'] ?? '',
    daily: json['daily'] ?? true,
    completionsIso: List<String>.from(json['completionsIso'] ?? []),
  );


  void toggleCompletion(String isoDay) {
    if (completionsIso.contains(isoDay)) {
      completionsIso.remove(isoDay);
    } else {
      completionsIso.add(isoDay);
    }
  }

  bool isCompleted(String isoDay) => completionsIso.contains(isoDay);


  static const String _storageKey = 'habits_data_v1';

  static Future<List<Habit>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_storageKey);
    if (data == null) return [];

    final list = jsonDecode(data) as List;
    return list.map((e) => Habit.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  static Future<void> save(List<Habit> habits) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(habits.map((h) => h.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }
}
