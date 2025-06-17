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
}
