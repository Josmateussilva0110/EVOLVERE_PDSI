import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../model/CategoryModel.dart';

class CategoryService {
  static Future<List<Category>> fetchNotArchivedCategories() async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/categories/not_archived'),
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List<dynamic> categoryList = decoded['categories'];
      print('categories: ${categoryList}');

      return categoryList.map((json) => Category.fromJson(json)).toList();
    } else {
      return [];
    }
  }
}
