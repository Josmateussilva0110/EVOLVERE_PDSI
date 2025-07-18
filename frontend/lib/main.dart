import 'package:flutter/material.dart';
import 'features/initial/widgets/widgets.dart';
import 'features/user/tela_login/screens/login_screen.dart';
import 'features/user/register_user/screens/user_screen.dart';
import 'features/user/tela_login/screens/forgot_password_screen.dart';
import 'features/Habits/habit_screen/screens/habits_screens.dart';
import 'features/Habits/limit_screen/screens/limit_period.dart';
import 'features/home/profile_screen.dart';
import 'features/register_category/screens/categorie_screen.dart';
import 'features/register_category/screens/list_category_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'features/Habits/frequency_screen/screens/frequency_screen.dart';
import 'features/home/home_screen.dart';
import 'features/listHabits/screens/habits_list_screen.dart';
import 'features/register_category/screens/edit_category_screen.dart';
import 'features/Habits/model/HabitData.dart';
import 'features/explanation/screens/explanation_screen.dart';
import 'features/home/notifications_screen.dart';
import 'features/settings/screens/settings_screen.dart';
import 'features/reports/screens/graph_screen.dart';

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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App com Rotas',
      initialRoute: '/',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          color: Colors.black,
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleSmall: TextStyle(color: Colors.white),
        ),
      ),
      routes: {
        '/': (context) => WelcomeScreen(),
        '/inicio': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/cadastro_usuario': (context) => RegisterUserScreen(),
        '/esqueci_senha': (context) => ForgotPasswordScreen(),
        '/perfil': (context) => TelaPerfil(),
        '/cadastro_categoria': (context) => RegisterCategoryScreen(),
        '/listar_categorias': (context) => ListCategoryScreen(),
        '/listar_habitos': (context) => HabitsListPage(),
        '/editar_categoria': (context) => EditCategoryScreen(),
        '/explanation_screen': (context) => ExplanationScreen(),
        '/notificacoes': (context) => NotificationsScreen(),
        '/configuracoes': (context) => SettingsScreen(),
        '/relatorios': (context) => ChartsScreen(),
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
            return MaterialPageRoute(
              builder:
                  (_) => const Scaffold(
                    body: Center(child: Text('Rota não encontrada')),
                  ),
            );
        }
      },
    );
  }
}
