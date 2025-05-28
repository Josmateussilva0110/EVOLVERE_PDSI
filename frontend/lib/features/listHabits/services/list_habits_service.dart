import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/HabitModel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HabitService {
  static Future<List<Habit>> fetchHabits() async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/habits/not_archived'),
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List<dynamic> habitsList = decoded['habits'];

      return habitsList.map((json) => Habit.fromJson(json)).toList();
    } else {
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
}
