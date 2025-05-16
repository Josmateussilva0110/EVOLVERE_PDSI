import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/initial/widgets/widgets.dart';
import 'features/user/tela_login/screens/login_screen.dart';
import 'features/user/register_user/screens/user_screen.dart';
import 'features/Habits/habit_screen/screens/habits_screens.dart';
import 'features/Habits/limit_screen/screens/limit_period.dart';
import 'features/home/tela_perfil.dart';
import 'features/register_category/screens/categorie_screen.dart';
import 'features/register_category/screens/list_category_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'features/Habits/frequency_screen/screens/frequency_screen.dart';
import 'features/home/home_screen.dart';
import 'features/listHabits/pages/habits_list_page.dart';
import 'features/register_category/screens/edit_category_screen.dart';
import 'features/Habits/model/HabitData.dart';


void main() async {
  await dotenv.load(fileName: ".env");

  runApp(
    ChangeNotifierProvider(
      create: (_) => HabitData(),
      child: const MyApp(),
    ),
  );
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
      // Você pode manter o routes para as rotas simples
      routes: {
        '/': (context) => WelcomeScreen(),
        '/inicio': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/cadastro_usuario': (context) => RegisterUserScreen(),
        '/perfil': (context) => TelaPerfil(),
        '/cadastro_categoria': (context) => RegisterCategoryScreen(),
        '/listar_categorias': (context) => ListCategoryScreen(),
        '/listar_habitos': (context) => HabitsListPage(),
        '/editar_categoria': (context) => EditCategoryScreen(),
      },

      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/cadastrar_habito':
            final args = settings.arguments;
            if (args is HabitData) {
              return MaterialPageRoute(
                builder: (_) => HabitScreen(habitData: args),
              );
            }
            return MaterialPageRoute(
              builder: (_) => HabitScreen(habitData: HabitData()),
            );

          case '/cadastrar_frequencia':
            final args = settings.arguments;
            if (args is HabitData) {
              return MaterialPageRoute(
                builder: (_) => FrequencyScreen(habitData: args),
              );
            }
            return MaterialPageRoute(
              builder: (_) => FrequencyScreen(habitData: HabitData()),
            );

          case '/prazo':
            final args = settings.arguments;
            if (args is HabitData) {
              return MaterialPageRoute(
                builder: (_) => TermScreen(habitData: args),
              );
            }
            return MaterialPageRoute(
              builder: (_) => TermScreen(habitData: HabitData()),
            );

          default:
            return null;
        }
      },
    );
  }
}
