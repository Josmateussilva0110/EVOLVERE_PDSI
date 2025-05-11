import 'package:flutter/material.dart';
import 'themes/themes.dart';
import 'widgets/widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Evolvere',
      theme: AppThemes.lightTheme,
      home: const WelcomeScreen(),
    );
  }
}
