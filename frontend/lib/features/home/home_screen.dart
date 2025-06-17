import 'package:flutter/material.dart';
import 'notifications_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/habit_tile_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

// Importar a tela de perfil
import '../user/screens/edit_profile_screen.dart';
import '../listHabits/screens/habits_list_screen.dart'; // Importar tela de lista de hábitos (caminho corrigido)
import '../register_category/screens/list_category_screen.dart'; // Importar tela de lista de categorias (caminho corrigido)
import '../settings/screens/settings_screen.dart'; // Importar a nova tela de configurações
import 'widgets/top_priorities_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // bool _showDrawer = false; // Removido: A navegação será direta para a tela de perfil
  String _userName = '';
  int _userId = 0; // Adicionar para armazenar o ID do usuário
  String _userEmail = ''; // Adicionar para armazenar o email do usuário

  // Dados simulados para as métricas da home
  int _dailyStreak = 3;
  int _completedHabitsToday = 3;
  int _totalScore = 246;
  double _dailyProgressValue = 6 / 8;
  int _completedHabitsCount = 6;
  int _totalHabitsCount = 8;


  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('username') ?? 'Usuário';
      // Assumindo que userId e userEmail também estão em SharedPreferences
      _userId = prefs.getInt('userId') ?? 0; // Recupere o userId real
      _userEmail =
          prefs.getString('userEmail') ??
          'usuario@example.com'; // Recupere o userEmail real

      // Dados simulados para demonstração. Substituir com dados reais da API.
      _dailyStreak = prefs.getInt('dailyStreak') ?? 3;
      _completedHabitsToday = prefs.getInt('completedHabitsToday') ?? 3;
      _totalScore = prefs.getInt('totalScore') ?? 246;
      _completedHabitsCount = prefs.getInt('completedHabitsCount') ?? 6;
      _totalHabitsCount = prefs.getInt('totalHabitsCount') ?? 8;
      _dailyProgressValue = _completedHabitsCount / _totalHabitsCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Olá, $_userName',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.account_circle, color: Colors.white),
                          onPressed: _toggleDrawer,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _statCard(
                            'Sequência Diária',
                            '3',
                            height: 100,
                            topPadding: 21,
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: _statCard(
                            'Hábitos Completados',
                            '3',
                            height: 100,
                            topPadding: 21,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    _statCard('Pontuação Total', '246', width: double.infinity),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Hoje',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add, color: Colors.white),
                          onPressed: () {
                            Navigator.pushNamed(context, '/cadastrar_habito');
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    if (_userId != null) TopPrioritiesWidget(userId: _userId!),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/listar_habitos');
                        },
                        child: Text(
                          'Ver Mais',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Progresso Diário',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 5),
                    LinearProgressIndicator(
                      value: 6 / 8,
                      color: Colors.white,
                      backgroundColor: Colors.grey,
                    ),
                    SizedBox(height: 5),
                    Text(
                      '6 de 8 hábitos completados',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_showDrawer)
            GestureDetector(
              onTap: _toggleDrawer,
              child: Container(
                color: Colors.black54,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 280,
                    margin: EdgeInsets.only(top: 80, right: 10),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.account_circle, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              '$_userName',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Divider(color: Colors.white24),
                        _drawerItem(Icons.person, 'Conta', () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/perfil',
                            ModalRoute.withName('/inicio'),
                          );
                        }),
                        _drawerItem(Icons.category, 'Categorias', () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/listar_categorias',
                            ModalRoute.withName('/inicio'),
                          );
                        }),
                        _drawerItem(Icons.check_box, 'Hábitos', () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/listar_habitos',
                            ModalRoute.withName('/inicio'),
                          );
                        }),
                        _drawerItem(Icons.settings, 'Configurações', () {
                          //tela não criada
                        }),
                        _drawerItem(Icons.person, 'Sair', () {
                          Navigator.pushNamed(context, '/');
                        }),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget para construir o Drawer lateral
  Widget _buildAppDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF1C1F26), // Cor de fundo do drawer
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blueAccent.shade700,
                  Colors.deepPurpleAccent.shade700,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.blueAccent, size: 40),
                ),
                SizedBox(height: 8),
                Text(
                  'Olá, $_userName!',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _userEmail, // Exibir o email do usuário
                  style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          _drawerItem(Icons.person, 'Conta', () {
            Navigator.pop(context); // Fechar o drawer
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => EditProfileScreen(
                      userId: _userId,
                      userEmail: _userEmail,
                    ),
              ),
            );
          }),
          _drawerItem(Icons.category, 'Categorias', () {
            Navigator.pop(context); // Fechar o drawer
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListCategoryScreen()),
            );
          }),
          _drawerItem(Icons.check_box, 'Hábitos', () {
            Navigator.pop(context); // Fechar o drawer
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HabitsListPage()),
            );
          }),
          _drawerItem(Icons.notifications, 'Notificações', () {
            Navigator.pop(context); // Fechar o drawer
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationsScreen()),
            );
          }),
          _drawerItem(Icons.bar_chart, 'Relatórios', () {
            Navigator.pop(context); // Fechar o drawer
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Tela de Relatórios em desenvolvimento.')),
            );
          }),
          _drawerItem(Icons.settings, 'Configurações', () {
            Navigator.pop(context); // Fechar o drawer
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ); // Navegar para a tela de Configurações
          }),
          Divider(color: Colors.white24, height: 1),
          _drawerItem(Icons.exit_to_app, 'Sair', () {
            Navigator.pop(context); // Fechar o drawer
            _clearUserDataAndNavigateToLogin();
          }),
        ],
      ),
    );
  }

  // Widget auxiliar para os itens do menu no drawer
  Widget _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 24),
      title: Text(
        title,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  // Novo método para limpar dados e navegar para o login
  Future<void> _clearUserDataAndNavigateToLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Limpa todos os dados salvos
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (route) => false,
    ); // Navega para a rota raiz e remove todas as anteriores
  }

  // Novo widget auxiliar para os cartões de estatísticas
  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color, {
    int flex = 1,
  }) {
    return Card(
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5, // Adicionar um pouco de elevação
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 35), // Ícone maior e colorido
              const SizedBox(height: 15),
              Text(
                value,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                title,
                style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
