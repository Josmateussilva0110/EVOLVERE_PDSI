import 'package:flutter/material.dart';
import './features/user/create_user_screen.dart';
//import './features/user/create_categorie_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Usuário',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: RegisterUserScreen(),
    );
  }
}
