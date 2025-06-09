class Habit {
  final int id;
  final String name;
  final String description;
  final String? categoryName;
  final Frequency frequency;
  final DateTime? startDate;
  final DateTime? endDate;
  final int priority;
  final List<DateTime>? reminders;
  final int status;

  Habit({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryName,
    required this.frequency,
    required this.startDate,
    required this.endDate,
    required this.priority,
    required this.reminders,
    required this.status
  });

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      categoryName: json['categoria'],
      frequency: Frequency.fromJson(json['frequency']),
      startDate: DateTime.tryParse(json['start_date'] ?? ''),
      endDate:
          json['end_date'] != null ? DateTime.tryParse(json['end_date']) : null,
      priority: json['priority'],
      reminders:
          json['reminders'] != null
              ? List<DateTime>.from(
                json['reminders'].map((e) => DateTime.parse(e)),
              )
              : null,
      status: json['status']
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
    parsedValue = value; 
  }

  return Frequency(value: parsedValue, option: json['option']);
}
}
