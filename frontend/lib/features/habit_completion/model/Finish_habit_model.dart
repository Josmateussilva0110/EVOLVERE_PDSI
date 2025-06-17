import 'package:flutter/material.dart';

class FinishHabitData {
  int? habitId;
  int? difficulty;
  int? mood;
  String reflection;
  String location;
  TimeOfDay? hour;

  FinishHabitData({
    this.habitId,
    this.difficulty,
    this.mood,
    this.reflection = '',
    this.location = '',
    this.hour,
  });

  FinishHabitData copyWith({
    int? habitId,
    int? difficulty,
    int? mood,
    String? reflection,
    String? location,
    TimeOfDay? hour,
  }) {
    return FinishHabitData(
      habitId: habitId ?? this.habitId,
      difficulty: difficulty ?? this.difficulty,
      mood: mood ?? this.mood,
      reflection: reflection ?? this.reflection,
      location: location ?? this.location,
      hour: hour ?? this.hour,
    );
  }

  @override
  String toString() {
    return '''
    FinishHabitData(
      habitId: $habitId,
      difficulty: $difficulty,
      mood: $mood,
      reflection: $reflection,
      location: $location,
      hour: ${formattedHour}
    )
    ''';
  }


  /// Converte o TimeOfDay para string no formato HH:mm
  String get formattedHour {
    if (hour == null) return '';
    final hourStr = hour!.hour.toString().padLeft(2, '0');
    final minuteStr = hour!.minute.toString().padLeft(2, '0');
    return '$hourStr:$minuteStr';
  }

  /// Converte para JSON, útil para envio via HTTP POST
  Map<String, dynamic> toJson() {
    return {
      'habit_id': habitId,
      'difficulty': difficulty,
      'mood': mood,
      'reflection': reflection,
      'location': location,
      'hour': formattedHour,
    };
  }
}
