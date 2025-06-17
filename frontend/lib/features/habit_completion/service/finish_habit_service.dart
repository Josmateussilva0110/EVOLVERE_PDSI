import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/Finish_habit_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FinishHabitService {

  static Future<String?> createFinishHabit(FinishHabitData habitData) async {
    final url = Uri.parse('${dotenv.env['API_URL']}/finished_habit');

    final body = {
      'habit_id': habitData.habitId,
      'difficulty': habitData.difficulty,
      'mood': habitData.mood,
      'reflection': habitData.reflection,
      'location': habitData.location,
      'hour': habitData.formattedHour
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
}
