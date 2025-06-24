import 'package:flutter/material.dart';

class Category {
  final int id;
  final String name;
  final String description;
  final String color;
  final String icon;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.icon,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      color: json['color'] ?? '',
      icon: json['icon'] ?? '',
    );
  }

  // Método para converter a cor string para Color
  Color getColor() {
    try {
      // Remove o # se existir
      String cleanColor = color.replaceAll('#', '');

      // Se for um número inteiro (formato antigo)
      if (cleanColor.length <= 8 && int.tryParse(cleanColor) != null) {
        return Color(int.parse(cleanColor));
      }

      // Se for hexadecimal (formato novo)
      if (cleanColor.length == 6) {
        // Adiciona FF para alpha se não tiver
        cleanColor = 'FF$cleanColor';
      } else if (cleanColor.length == 8) {
        // Já tem alpha, está correto
      } else if (cleanColor.length == 9) {
        // Formato #FFF44336 - tem 9 caracteres incluindo F no início
        // Remove o F extra no início
        cleanColor = cleanColor.substring(1);
      } else {
        // Formato inválido, retorna cor padrão
        return Colors.grey;
      }

      // Converte para int usando radix 16
      int colorInt = int.parse(cleanColor, radix: 16);
      return Color(colorInt);
    } catch (e) {
      // Retorna uma cor padrão se houver erro
      return Colors.grey;
    }
  }
}
