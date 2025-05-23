class HabitData {
  String habitName;
  String description;
  int? selectedCategory; 
  Map<String, dynamic> frequencyData;
  DateTime? startDate;
  DateTime? endDate;
  List<DateTime> reminders;
  int? priority; // 1 = alta, 2 = normal, 3 = baixa

  HabitData({
    this.habitName = '',
    this.description = '',
    this.selectedCategory, 
    Map<String, dynamic>? frequencyData,
    this.startDate,
    this.endDate,
    List<DateTime>? reminders,
    this.priority = 2,
  })  : frequencyData = frequencyData ?? {'option': 'todos_os_dias', 'value': null},
        reminders = reminders ?? [];

  HabitData copyWith({
    String? habitName,
    String? description,
    int? selectedCategory, 
    Map<String, dynamic>? frequencyData,
    DateTime? startDate,
    DateTime? endDate,
    List<DateTime>? reminders,
    int? priority,
  }) {
    return HabitData(
      habitName: habitName ?? this.habitName,
      description: description ?? this.description,
      selectedCategory: selectedCategory ?? this.selectedCategory, 
      frequencyData: frequencyData ?? this.frequencyData,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      reminders: reminders ?? this.reminders,
      priority: priority ?? this.priority,
    );
  }
}

