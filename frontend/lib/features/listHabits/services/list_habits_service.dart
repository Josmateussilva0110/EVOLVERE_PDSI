import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/HabitModel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HabitService {
  static Future<List<Habit>> fetchHabits(int userId) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/habits/not_archived/$userId'),
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List<dynamic> habitsList = decoded['habits'];

      return habitsList.map((json) => Habit.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  static Future<List<Habit>> fetchAllHabits(int userId) async {
    try {
      // Buscar hábitos ativos e arquivados separadamente
      final activeHabits = await fetchHabits(userId);
      final archivedHabits = await fetchHabitsArchived(userId);

      // Combinar as duas listas
      final allHabits = [...activeHabits, ...archivedHabits];

      return allHabits;
    } catch (e) {
      print('Erro ao buscar todos os hábitos: $e');
      return [];
    }
  }

  static Future<bool> deleteHabit(int habitId) async {
    final response = await http.delete(
      Uri.parse('${dotenv.env['API_URL']}/habit/$habitId'),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> archiveHabit(int habitId) async {
    final response = await http.post(
      Uri.parse('${dotenv.env['API_URL']}/habit/archive/$habitId'),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> activeHabit(int habitId) async {
    final response = await http.post(
      Uri.parse('${dotenv.env['API_URL']}/habit/active/$habitId'),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<List<Habit>> fetchHabitsArchived(int userId) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/habits/archived/$userId'),
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List<dynamic> habitsList = decoded['habits'];

      return habitsList.map((json) => Habit.fromJson(json)).toList();
    } else {
      return [];
    }
  }
}
