import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/HabitModel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HabitService {
  static Future<List<Habit>> fetchHabits() async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/habits'),
    );

    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List<dynamic> habitsList = decoded['habits'];

      print('Lista de hábitos recebida:');
      for (var habit in habitsList) {
        print(habit);
      }

      return habitsList.map((json) => Habit.fromJson(json)).toList();
    } else {
      return [];
    }
  }
}
