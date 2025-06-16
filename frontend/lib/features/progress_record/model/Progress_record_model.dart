class ProgressRecordData {
  int? habitId;
  String? name;
  int? type;
  int? parameter;

  ProgressRecordData({
    this.habitId,
    this.name,
    this.type,
    this.parameter,
  });

  ProgressRecordData copyWith({
    int? habitId,
    int? type,
    String? name,
    int? parameter,
  }) {
    return ProgressRecordData(
      habitId: habitId ?? this.habitId,
      name: name ?? this.name,
      type: type ?? this.type,
      parameter: parameter ?? this.parameter
    );
  }

  @override
  String toString() {
    return '''
    ProgressRecordData(
      habitId: $habitId,
      name: $name,
      type: $type,
      parameter: $parameter
    )
    ''';
  }


  /// Converte para JSON, útil para envio via HTTP POST
  Map<String, dynamic> toJson() {
    return {
      'habit_id': habitId,
      'name': name,
      'type': type,
      'parameter': parameter
    };
  }
}
