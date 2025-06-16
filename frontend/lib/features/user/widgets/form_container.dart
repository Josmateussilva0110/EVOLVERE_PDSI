import 'package:flutter/material.dart';

class FormContainer extends StatelessWidget {
  final Widget child;

  const FormContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x0A00FFFF), blurRadius: 10, spreadRadius: 2),
        ],
      ),
      child: child,
    );
  }
}
