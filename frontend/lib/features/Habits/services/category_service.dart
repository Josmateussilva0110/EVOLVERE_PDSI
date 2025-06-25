import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';

class CategoryService {
  static Future<List<Map<String, dynamic>>> fetchCategories(int user_id) async {
    List<Map<String, dynamic>> loadedCategories = [];

    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/categories/$user_id'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = json.decode(response.body);
        final List<dynamic> data = jsonBody['categories'];

        loadedCategories =
            data
                .map<Map<String, dynamic>>(
                  (item) => {
                    'icon':
                        item['icon'] != null
                            ? '${dotenv.env['API_URL']}${item['icon']}'
                            : '',
                    'label': item['name'] ?? 'Sem nome',
                    'category': item['id']?.toString() ?? '',
                    'description': item['description'] ?? '',
                    'color': _parseColor(item['color']),
                  },
                )
                .toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }

    return loadedCategories;
  }

  static Color? _parseColor(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) return null;
    try {
      final hex = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return null;
    }
  }
}
