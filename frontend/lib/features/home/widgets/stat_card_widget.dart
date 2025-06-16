import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final double? width;
  final double topPadding;
  final double? titleFontSize;
  final double? valueFontSize;

  const StatCard({
    Key? key,
    required this.title,
    required this.value,
    this.width,
    this.topPadding = 16.0,
    this.titleFontSize,
    this.valueFontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.only(
        top: topPadding,
        left: 16.0,
        right: 16.0,
        bottom: 16.0,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // Um tom escuro
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white70,
              fontSize: titleFontSize ?? 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: valueFontSize ?? 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
