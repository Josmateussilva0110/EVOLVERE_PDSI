class ProgressRecordData {
  int? habitId;
  String? name;
  int? type;
  int? parameter;
  int? id;
  String? type_description;

  ProgressRecordData({
    this.habitId,
    this.name,
    this.type,
    this.parameter,
    this.id,
    this.type_description
  });

  ProgressRecordData copyWith({
    int? habitId,
    int? type,
    String? name,
    int? parameter,
    int? id,
    String? type_description
  }) {
    return ProgressRecordData(
      habitId: habitId ?? this.habitId,
      name: name ?? this.name,
      type: type ?? this.type,
      parameter: parameter ?? this.parameter,
      id: id ?? this.id,
      type_description: type_description ?? this.type_description
    );
  }

  @override
  String toString() {
    return '''
    ProgressRecordData(
      habitId: $habitId,
      name: $name,
      type: $type,
      parameter: $parameter,
      id: $id,
      type_description: $type_description
    )
    ''';
  }


  /// Converte para JSON, útil para envio via HTTP POST
  Map<String, dynamic> toJson() {
    return {
      'habit_id': habitId,
      'name': name,
      'type': type,
      'parameter': parameter,
      'id': id,
      'type_description': type_description
    };
  }

  factory ProgressRecordData.fromJson(Map<String, dynamic> json) {
    return ProgressRecordData(
      habitId: json['habit_id'],
      name: json['name'],
      type: json['type'],
      parameter: json['parameter'],
      id: json['id'],
      type_description: json['type_description']
    );
  }
}
