class Habit {
  final int id;
  final String name;
  final String description;
  final int? categoryId;
  final Frequency frequency;
  final DateTime? startDate;
  final DateTime? endDate;
  final int priority;
  final List<DateTime>? reminders;
  final DateTime createdAt;
  final DateTime updatedAt;

  Habit({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.frequency,
    required this.startDate,
    required this.endDate,
    required this.priority,
    required this.reminders,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      categoryId: json['category_id'],
      frequency: Frequency.fromJson(json['frequency']),
      startDate: DateTime.tryParse(json['start_date'] ?? ''),
      endDate: json['end_date'] != null ? DateTime.tryParse(json['end_date']) : null,
      priority: json['priority'],
      reminders: json['reminders'] != null
          ? List<DateTime>.from(json['reminders'].map((e) => DateTime.parse(e)))
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class Frequency {
  final dynamic value;
  final String option;

  Frequency({required this.value, required this.option});

  factory Frequency.fromJson(Map<String, dynamic> json) {
    final value = json['value'];
    dynamic parsedValue;

    if (value is List) {
      parsedValue = value;
    } else if (value is Map) {
      parsedValue = Map<String, dynamic>.from(value);
    } else {
      parsedValue = null;
    }

    return Frequency(
      value: parsedValue,
      option: json['option'],
    );
  }
}
