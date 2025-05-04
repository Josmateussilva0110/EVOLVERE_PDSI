import 'package:flutter/material.dart';

class NavigationDots extends StatelessWidget {
  final int currentIndex;
  final int totalDots;

  const NavigationDots({
    required this.currentIndex,
    required this.totalDots,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        totalDots,
        (index) => _buildDot(index == currentIndex),
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? const Color(0xFF2B6BED) : Colors.grey[600],
      ),
    );
  }
}