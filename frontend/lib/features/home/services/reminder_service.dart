import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ReminderService {
  // Processar lembretes manualmente
  static Future<Map<String, dynamic>?> processReminders() async {
    try {
      final String? apiURL = dotenv.env['API_URL'];
      if (apiURL == null) return null;

      final response = await http.post(
        Uri.parse('$apiURL/reminders/process'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Erro ao processar lembretes: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Erro de conexão ao processar lembretes: $e');
      return null;
    }
  }
}
