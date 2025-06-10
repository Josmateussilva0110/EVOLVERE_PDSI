class HabitData {
  int? habitId;
  int? userId;
  String habitName;
  String description;
  int? selectedCategory;
  Map<String, dynamic> frequencyData;
  DateTime? startDate;
  DateTime? endDate;
  List<DateTime> reminders;
  int? priority; // 1 = alta, 2 = normal, 3 = baixa

  HabitData({
    this.habitId,
    this.userId,
    this.habitName = '',
    this.description = '',
    this.selectedCategory,
    Map<String, dynamic>? frequencyData,
    this.startDate,
    this.endDate,
    List<DateTime>? reminders,
    this.priority = 2,
  }) : frequencyData =
           frequencyData ?? {'option': 'todos_os_dias', 'value': null},
       reminders = reminders ?? [];

  HabitData copyWith({
    int? habitId,
    int? userId,
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
      habitId: habitId ?? this.habitId,
      userId: userId ?? this.userId,
      habitName: habitName ?? this.habitName,
      description: description ?? this.description,
      selectedCategory: selectedCategory,
      frequencyData: frequencyData ?? this.frequencyData,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      reminders: reminders ?? this.reminders,
      priority: priority ?? this.priority,
    );
  }

  @override
  String toString() {
    return '''
  HabitData(
    habitId: $habitId,
    userId: $userId,
    habitName: $habitName,
    description: $description,
    selectedCategory: $selectedCategory,
    frequencyData: $frequencyData,
    startDate: $startDate,
    endDate: $endDate,
    reminders: ${reminders.map((d) => d.toIso8601String()).toList()},
    priority: $priority
  )
  ''';
  }
}
