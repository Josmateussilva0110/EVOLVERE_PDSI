class HabitData {
  String habitName;
  String description;
  String selectedCategory;
  Map<String, dynamic> frequencyData;
  bool dataAlvoEnabled;
  String priority;

  HabitData({
    this.habitName = '',
    this.description = '',
    this.selectedCategory = '',
    Map<String, dynamic>? frequencyData,
    this.dataAlvoEnabled = false,
    this.priority = 'Normal',
  }) : frequencyData = frequencyData ?? {'tipo': 'todos_os_dias', 'valores': null};

  HabitData copyWith({
    String? habitName,
    String? description,
    String? selectedCategory,
    Map<String, dynamic>? frequencyData,
    bool? dataAlvoEnabled,
    String? priority,
  }) {
    return HabitData(
       habitName: habitName ?? this.habitName,
      description: description ?? this.description,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      frequencyData: frequencyData ?? this.frequencyData,
      dataAlvoEnabled: dataAlvoEnabled ?? this.dataAlvoEnabled,
      priority: priority ?? this.priority,
      
    );
  }
}
