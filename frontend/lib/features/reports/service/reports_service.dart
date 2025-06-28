import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HabitService {

  Future<List<Map<String, dynamic>>> fetchPizzaGraph() async {
    try {
      final url = Uri.parse('${dotenv.env['API_URL']}/habit/graph/pizza');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> result = data['result'];
        return result.cast<Map<String, dynamic>>();
      } else if (response.statusCode == 404) {
        // nenhum dado encontrado
        return [];
      } else {
        throw Exception('Erro ao buscar gráfico: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro no fetchPizzaGraph: $e');
      return [];
    }
  }
}
