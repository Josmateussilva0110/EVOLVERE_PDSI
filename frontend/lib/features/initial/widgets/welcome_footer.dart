import 'package:flutter/material.dart';

class WelcomeFooter extends StatelessWidget {
  const WelcomeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(12.0),
      child: Text(
        '2025 © EVOLVERE 1.0',
        style: TextStyle(color: Colors.white38, fontSize: 12),
      ),
    );
  }
}
