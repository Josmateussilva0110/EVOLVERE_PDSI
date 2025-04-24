import 'package:flutter/material.dart';
import 'home_menu.dart'; // Tela inicial com botões

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Usuário',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeMenu(),
    );
  }
}
