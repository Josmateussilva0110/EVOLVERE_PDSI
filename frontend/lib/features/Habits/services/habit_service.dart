import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/HabitData.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HabitService {
  // converter DateTime em string dentro do frequencyData
  static Map<String, dynamic> serializeFrequency(
    Map<String, dynamic> frequencyData,
  ) {
    if (frequencyData['option'] == 'dias_especificos_ano' &&
        frequencyData['value'] != null) {
      final List<dynamic> dates = frequencyData['value'];
      return {
        'option': frequencyData['option'],
        'value':
            dates.map((d) {
              if (d is DateTime) return d.toIso8601String();
              return d;
            }).toList(),
      };
    }
    return frequencyData;
  }

  static Future<String?> createHabit(HabitData habitData) async {
    final url = Uri.parse('${dotenv.env['API_URL']}/habit');

    final body = {
      'name': habitData.habitName,
      'description': habitData.description,
      'frequency': serializeFrequency(habitData.frequencyData),
      'start_date': habitData.startDate?.toIso8601String(),
      'end_date': habitData.endDate?.toIso8601String(),
      'reminders': habitData.reminders.map((r) => r.toIso8601String()).toList(),
      'priority': habitData.priority,
      if (habitData.selectedCategory != null)
        'category_id': habitData.selectedCategory,
      'user_id': habitData.userId
    };
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return null; // sucesso
      } else {
        final json = jsonDecode(response.body);
        return json['err'] ?? 'Erro desconhecido';
      }
    } catch (e) {
      return 'Erro de conexão: $e';
    }
  }

  static Future<String?> editHabit(HabitData habitData) async {
    final url = Uri.parse('${dotenv.env['API_URL']}/habit/${habitData.habitId}',);

    final body = {
      'habitId': habitData.habitId,
      'name': habitData.habitName,
      'description': habitData.description,
      'frequency': serializeFrequency(habitData.frequencyData),
      'start_date': habitData.startDate?.toIso8601String(),
      'end_date': habitData.endDate?.toIso8601String(),
      'reminders': habitData.reminders.map((r) => r.toIso8601String()).toList(),
      'priority': habitData.priority,
      'category_id': habitData.selectedCategory,
      'user_id': habitData.userId
    };
    try {
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return null; // sucesso
      } else {
        final json = jsonDecode(response.body);
        return json['err'] ?? 'Erro desconhecido';
      }
    } catch (e) {
      return 'Erro de conexão: $e';
    }
  }
}
