import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../model/Progress_record_model.dart';

class ProgressRecordService {
  static Future<String?> createProgressHabit(
    ProgressRecordData habitData,
  ) async {
    final url = Uri.parse('${dotenv.env['API_URL']}/habit_progress');

    final body = {
      'habit_id': habitData.habitId,
      'name': habitData.name,
      'type': habitData.type,
      'parameter': habitData.parameter,
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

  static Future<List<ProgressRecordData>> fetchProgressHabit(
    int habit_id,
  ) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/habits/progress/all/$habit_id'),
    );

    print('RESPONSE: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      print('DECODED: ${decoded}');
      final List<dynamic> progress_list = decoded['habit_progress'];
      print('PROGRESS LIST: $progress_list');

      return progress_list
          .map((json) => ProgressRecordData.fromJson(json))
          .toList();
    } else {
      return [];
    }
  }

  static Future<bool> deleteProgress(int id) async {
    final response = await http.delete(
      Uri.parse('${dotenv.env['API_URL']}/habit/progress/$id'),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> completeProgress(int id) async {
    final response = await http.post(
      Uri.parse('${dotenv.env['API_URL']}/habit/progress/complete/$id'),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> cancelProgress(int id) async {
    final response = await http.post(
      Uri.parse('${dotenv.env['API_URL']}/habit/progress/cancel/$id'),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<String?> editProgressHabit(
    ProgressRecordData habitData,
  ) async {
    final url = Uri.parse('${dotenv.env['API_URL']}/habit/progress/edit/${habitData.id}');

    final body = {
      'name': habitData.name,
      'type': habitData.type,
      'parameter': habitData.parameter,
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
