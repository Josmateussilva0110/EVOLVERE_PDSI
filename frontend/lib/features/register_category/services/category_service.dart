import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import '../models/category.dart';

class CategoryService {
  static Future<List<Category>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/categories'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['categories'] != null) {
          return (data['categories'] as List)
              .map(
                (item) => Category.fromJson({
                  'id': item['id'].toString(),
                  'name': item['name'],
                  'description': item['description'],
                  'icon': item['icon'],
                  'color': item['color'],
                }),
              )
              .toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
