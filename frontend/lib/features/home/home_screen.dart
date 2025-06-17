import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

// Importações das telas
import 'notifications_screen.dart';
//import '../user/screens/edit_profile_screen.dart';
import '../listHabits/screens/habits_list_screen.dart';
import '../register_category/screens/list_category_screen.dart';
import '../settings/screens/settings_screen.dart';

// Importações dos widgets
import 'widgets/top_priorities_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = '';
  int? _userId;
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('username') ?? 'Usuário';
      _userId = prefs.getInt('userId') ?? 0;
      _userEmail = prefs.getString('userEmail') ?? 'usuario@example.com';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121217),
      drawer: _buildAppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Olá, $_userName',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: math.max(20.0, MediaQuery.of(context).size.width * 0.05),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 32),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Estatísticas
              Row(
                children: [
                  Expanded(
                    child: _statCard('Sequência Diária', '3'),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _statCard('Hábitos Completos', '3'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _statCard('Pontuação Total', '246', width: double.infinity),
              const SizedBox(height: 20),

              // Hoje
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Hoje',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () {
                      Navigator.pushNamed(context, '/cadastrar_habito');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),

              if (_userId != null) TopPrioritiesWidget(userId: _userId!),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/listar_habitos');
                  },
                  child: const Text(
                    'Ver Mais',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Progresso Diário',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 5),
              const LinearProgressIndicator(
                value: 6 / 8,
                color: Colors.white,
                backgroundColor: Colors.grey,
              ),
              const SizedBox(height: 5),
              const Text(
                '6 de 8 hábitos completados',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para estatísticas
  Widget _statCard(String title, String value,
      {double? width, double height = 100}) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1F26),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Drawer lateral
  Widget _buildAppDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF1C1F26),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
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
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.blueAccent, size: 40),
                ),
                const SizedBox(height: 8),
                Text(
                  'Olá, $_userName!',
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  _userEmail,
                  style:
                      GoogleFonts.inter(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          _drawerItem(Icons.category, 'Categorias', () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListCategoryScreen()),
            );
          }),
          _drawerItem(Icons.check_box, 'Hábitos', () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HabitsListPage()),
            );
          }),
          _drawerItem(Icons.notifications, 'Notificações', () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationsScreen()),
            );
          }),
          _drawerItem(Icons.bar_chart, 'Relatórios', () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Tela de Relatórios em desenvolvimento.')),
            );
          }),
          _drawerItem(Icons.settings, 'Configurações', () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          }),
          const Divider(color: Colors.white24),
          _drawerItem(Icons.exit_to_app, 'Sair', () {
            Navigator.pop(context);
            _clearUserDataAndNavigateToLogin();
          }),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: GoogleFonts.inter(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
    );
  }

  Future<void> _clearUserDataAndNavigateToLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }
}
