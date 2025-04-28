import 'package:flutter/material.dart';

class ThemeToggleButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ThemeToggleButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Icon(
            isDark ? Icons.wb_sunny : Icons.nightlight_round,
            color: isDark ? Colors.yellow[600] : Colors.indigo[900],
            size: 26,
          ),
        ),
      ),
    );
  }
}
