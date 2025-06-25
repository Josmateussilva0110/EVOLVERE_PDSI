import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import '../models/category.dart';

class CategoryService {
  static Future<List<Category>> getCategories(int user_id) async {
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/categories/$user_id'),
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

  static Future<List<Category>> getArchivedCategories(int user_id) async {
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/categories/archived/$user_id'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['categories'] as List)
            .map((category) => Category.fromJson(category))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
  static Future<bool> restoreCategory(String id) async {
  try {
    final response = await http.patch(
      Uri.parse('${dotenv.env['API_URL']}/category/$id/unarchive'),
    );
    return response.statusCode == 200;
  } catch (e) {
    return false;
  }
}

static Future<bool> deleteCategory(String id) async {
  try {
    final response = await http.delete(
      Uri.parse('${dotenv.env['API_URL']}/category/$id'),
    );
    return response.statusCode == 200;
  } catch (e) {
    return false;
  }
}

}
