import 'package:flutter/material.dart';
import 'package:front/features/initial/screens/welcome_screen.dart';
import 'features/user/tela_login/screens/login_screen.dart';
import 'features/user/register_user/screens/user_screen.dart';
import 'features/habits/habit_screen/screens/habits_screens.dart';
import 'features/Habits/limit_screen/screens/limit_period.dart';
import 'features/home/tela_perfil.dart';
import 'features/user/register_category/screens/categorie_screen.dart';
import 'features/user/register_category/screens/list_category_screen.dart'; // Nova importação
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'features/habits/frequency_screen/screens/frequency_screen.dart';

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
        '/prazo': (context) => TelaPrazo(),
        '/cadastrar_frequencia': (context) => FrequencyScreen(),
        '/perfil': (context) => TelaPerfil(),
        '/cadastro_categoria': (context) => RegisterCategoryScreen(),
        '/listar_categorias': (context) => const ListCategoryScreen(),
      },
    );
  }
}
