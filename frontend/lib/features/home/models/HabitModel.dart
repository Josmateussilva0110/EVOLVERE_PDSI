import 'dart:convert';

class Habit {
  final int id;
  final String name;
  final String description;
  final String categoryName;
  final Map<String, dynamic> frequency;
  final DateTime startDate;
  final DateTime? endDate;
  final int priority;
  final List<dynamic> reminders;
  final int status;

  Habit({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryName,
    required this.frequency,
    required this.startDate,
    this.endDate,
    required this.priority,
    required this.reminders,
    required this.status,
  });

  factory Habit.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> frequencyData;
    if (json['frequency'] is String) {
      try {
        frequencyData = jsonDecode(json['frequency']);
      } catch (e) {
        frequencyData = {};
      }
    } else {
      frequencyData = json['frequency'] ?? {};
    }

    return Habit(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      categoryName: json['categoria'] ?? '',
      frequency: frequencyData,
      startDate: DateTime.parse(json['start_date']),
      endDate:
          json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      priority: json['priority'],
      reminders: json['reminders'] ?? [],
      status: json['status'],
    );
  }
}
