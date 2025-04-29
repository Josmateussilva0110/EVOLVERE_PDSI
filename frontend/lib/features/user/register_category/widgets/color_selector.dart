import 'package:flutter/material.dart';

class ColorSelector extends StatelessWidget {
  final List<Color> colors;
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  const ColorSelector({
    super.key,
    required this.colors,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Cor tema",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: colors.map((cor) {
            bool selecionada = cor == selectedColor;
            return GestureDetector(
              onTap: () => onColorSelected(cor),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: cor,
                  shape: BoxShape.circle,
                  border: selecionada
                      ? Border.all(
                          color: Color(0xFF2196F3),
                          width: 3,
                        )
                      : null,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
