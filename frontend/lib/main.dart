import 'package:flutter/material.dart';
import 'package:front/features/initial/screens/welcome_screen.dart';
import 'features/user/tela_login/screens/login_screen.dart';
import 'features/user/register_user/screens/user_screen.dart';
import 'features/habits/habit_screen/screens/habits_screens.dart';
import 'features/habits/Tela_Frequencia/Tela_Frequencia.dart';
import 'features/habits/Tela_Prazo/tela_Prazo.dart';
import 'features/home/tela_perfil.dart';
import 'features/user/register_category/screens/categorie_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
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
        '/habitos': (context) => HabitScreen(),
        '/frequencia': (context) => TelaFrequencia(),
        '/prazo': (context) => TelaPrazo(),
        '/perfil': (context) => TelaPerfil(),
        '/cadastro_categoria': (context) => RegisterCategoryScreen(),
      },
    );
  }
}
