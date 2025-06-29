class ProgressRecordData {
  int? habitId;
  String? name;
  int? type;
  int? parameter;
  int? id;
  String? type_description;
  int? status;

  ProgressRecordData({
    this.habitId,
    this.name,
    this.type,
    this.parameter,
    this.id,
    this.type_description,
    this.status,
  });

  ProgressRecordData copyWith({
    int? habitId,
    int? type,
    String? name,
    int? parameter,
    int? id,
    String? type_description,
    int? status,
  }) {
    return ProgressRecordData(
      habitId: habitId ?? this.habitId,
      name: name ?? this.name,
      type: type ?? this.type,
      parameter: parameter ?? this.parameter,
      id: id ?? this.id,
      type_description: type_description ?? this.type_description,
      status: status ?? this.status,
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
      type_description: $type_description,
      status: $status
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
      'type_description': type_description,
      'status': status,
    };
  }

  factory ProgressRecordData.fromJson(Map<String, dynamic> json) {
    return ProgressRecordData(
      habitId: json['habit_id'],
      name: json['name'],
      type: json['type'],
      parameter: json['parameter'],
      id: json['id'],
      type_description: json['type_description'],
      status: json['status'],
    );
  }
}
