import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/CategoryModel.dart';

class CategoryService {
  static Future<List<Category>> fetchNotArchivedCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('loggedInUserId');

      if (userId == null) {
        return [];
      }

      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/categories/not_archived/$userId'),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List<dynamic> categoryList = decoded['categories'];
        return categoryList.map((json) => Category.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<int?> fetchCategoryIdByName(String name) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/category/get_id/$name'),
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return decoded['category_id'];
    } else {
      return null;
    }
  }
}
