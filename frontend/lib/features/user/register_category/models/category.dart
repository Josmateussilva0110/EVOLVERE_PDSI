import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final String description;
  final String iconUrl;
  final Color color;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.color,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    String colorHex = json['color'] ?? '#FF000000';

    // Garante que a string tenha o formato correto para conversão
    if (!colorHex.startsWith('#')) colorHex = '#$colorHex';
    if (colorHex.length == 7) colorHex = '${colorHex}FF';

    return Category(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      iconUrl: json['icon'] ?? '',
      color: Color(int.parse(colorHex.replaceAll('#', '0xFF'))),
    );
  }
}
