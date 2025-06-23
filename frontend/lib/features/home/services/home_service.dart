import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/HabitModel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomeService {
  static Future<List<Habit>> fetchTopPriorities(int userId) async {
    try {
      final String? apiUrl = dotenv.env['API_URL'];
      if (apiUrl == null) {
        print('API_URL não configurado no .env');
        throw Exception('API_URL não configurado no .env');
      }

      print('Buscando hábitos prioritários para o usuário $userId');
      print('URL: $apiUrl/habits/top_priorities/$userId');

      final response = await http.get(
        Uri.parse('$apiUrl/habits/top_priorities/$userId'),
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> habitsJson = data['habits'];
        return habitsJson.map((json) => Habit.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        print('Nenhum hábito encontrado');
        return []; // Retorna lista vazia se não encontrar hábitos
      } else {
        final errorData = json.decode(response.body);
        print('Erro na resposta: ${errorData['err']}');
        throw Exception(
          errorData['err'] ?? 'Falha ao carregar hábitos prioritários',
        );
      }
    } catch (e) {
      print('Erro ao buscar hábitos prioritários: $e');
      throw Exception('Erro ao conectar com o servidor: $e');
    }
  }

  static Future<int> fetchCompletedTodayCount(int userId) async {
    try {
      final String? apiUrl = dotenv.env['API_URL'];
      if (apiUrl == null) {
        print('API_URL não configurado no .env');
        throw Exception('API_URL não configurado no .env');
      }

      print(
        'Buscando contagem de hábitos concluídos hoje para o usuário $userId',
      );
      print('URL: $apiUrl/habits/completed_today/$userId');

      final response = await http.get(
        Uri.parse('$apiUrl/habits/completed_today/$userId'),
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['count'] ?? 0;
      } else {
        print('Erro ao buscar contagem de hábitos concluídos hoje');
        return 0;
      }
    } catch (e) {
      print('Erro ao buscar contagem de hábitos concluídos hoje: $e');
      return 0;
    }
  }

  static Future<Map<String, int>> fetchHabitsSummary(int userId) async {
    try {
      final String? apiUrl = dotenv.env['API_URL'];
      if (apiUrl == null) {
        print('API_URL não configurado no .env');
        throw Exception('API_URL não configurado no .env');
      }

      print('Buscando resumo de hábitos para o usuário $userId');
      print('URL: $apiUrl/habits/total/$userId');

      final response = await http.get(
        Uri.parse('$apiUrl/habits/total/$userId'),
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return {
          'total': data['total'] ?? 0,
          'completed': data['completed'] ?? 0,
        };
      } else {
        print('Erro ao buscar resumo de hábitos');
        return {'total': 0, 'completed': 0};
      }
    } catch (e) {
      print('Erro ao buscar resumo de hábitos: $e');
      return {'total': 0, 'completed': 0};
    }
  }

  static Future<int> fetchActiveHabitsCount(int userId) async {
    final String? apiURL = dotenv.env['API_URL'];
    if (apiURL == null) {
      throw Exception('API_URL not set');
    }
    final response = await http.get(Uri.parse('$apiURL/habits/active/$userId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['active'] ?? 0;
    } else {
      print('Failed to load active habits count: ${response.body}');
      throw Exception('Failed to load active habits count');
    }
  }
}
