import 'package:flutter/material.dart';
import 'package:front/features/initial/screens/welcome_screen.dart';
//import 'package:front/features/user/register_user/screens/user_screen.dart';
//import 'features/user/tela_login/themes/app_theme.dart';
import 'features/user/tela_login/screens/login_screen.dart';
import 'features/user/register_user/screens/user_screen.dart';
//import 'features/user/register_category/screens/categorie_screen.dart';
import 'features/Habits/Screens/Tela_Habitos/tela_habitos.dart'; // Adicione esta linha
import 'features/Habits/Screens/Tela_Frequencia/Tela_Frequencia.dart'; // Adicione esta linha
import 'features/Habits/Screens//Tela_Prazo/tela_Prazo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App com Rotas',
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/login': (context) => LoginScreen(),
        '/cadastro_usuario': (context) => RegisterUserScreen(),
        '/habitos': (context) => TelaHabitos(),
        '/frequencia': (context) => TelaFrequencia(),
        '/prazo': (context) => TelaPrazo(),
      },
    );
  }
}
