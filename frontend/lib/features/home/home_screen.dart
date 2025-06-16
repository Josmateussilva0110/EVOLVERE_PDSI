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
  String _userEmail = ''; // Adicionar para armazenar o email do usuário

  // Dados simulados para as métricas da home
  int _dailyStreak = 3;
  int _completedHabitsToday = 3;
  int _totalScore = 246;
  double _dailyProgressValue = 6 / 8;
  int _completedHabitsCount = 6;
  int _totalHabitsCount = 8;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Chamar a função para carregar os dados do usuário
  }

  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('username') ?? 'Usuário';
      _userEmail =
          prefs.getString('userEmail') ??
          'usuario@example.com'; // Recupere o userEmail real
      _userId = prefs.getInt('loggedInUserId');
    });
  }


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
      backgroundColor: const Color(0xFF121217),
      // Adicionando o Drawer ao Scaffold
      drawer: _buildAppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Olá, $_userName',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: math.max(
              20.0, // Aumentar tamanho da fonte para o nome
              MediaQuery.of(context).size.width * 0.05,
            ),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu, // Ícone de menu para abrir o drawer
                color: Colors.white,
                size: 32,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Abrir o drawer
              },
            );
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 25,
                ), // Manter o espaçamento se necessário após o AppBar
                GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    _buildStatCard(
                      'Sequência Diária',
                      _dailyStreak.toString(),
                      Icons.calendar_today,
                      Colors.blueAccent,
                    ),
                    _buildStatCard(
                      'Hábitos Completados',
                      _completedHabitsToday.toString(),
                      Icons.check_circle,
                      Colors.greenAccent,
                    ),
                    _buildStatCard(
                      'Pontuação Total',
                      _totalScore.toString(),
                      Icons.star,
                      Colors.amberAccent,
                      flex: 2,
                    ), // Ocupa 2 colunas
                  ],
                ),
                const SizedBox(height: 25), // Mais espaço após as estatísticas
                Text(
                  'Progresso Diário',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: math.max(
                      16.0,
                      MediaQuery.of(context).size.width * 0.045,
                    ),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: _dailyProgressValue,
                  color: Colors.deepPurpleAccent,
                  backgroundColor: Colors.white12,
                  borderRadius: BorderRadius.circular(8),
                  minHeight: 12,
                ),
                const SizedBox(height: 8),
                Text(
                  '$_completedHabitsCount de $_totalHabitsCount hábitos completados',
                  style: GoogleFonts.inter(
                    color: Colors.white70,
                    fontSize: math.max(
                      12.0,
                      MediaQuery.of(context).size.width * 0.035,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ), // Mais espaço antes dos hábitos de hoje
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hoje',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: math.max(
                          18.0,
                          MediaQuery.of(context).size.width * 0.05,
                        ),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/cadastrar_habito');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                // Exemplo de Hábitos (substituir por dados reais da API)
                HabitTile(
                  title: 'Exercício Matinal',
                  icon: Icons.directions_run,
                  iconColor: Colors.redAccent,
                  onTap: () {},
                  fontSize: math.max(
                    14.0,
                    MediaQuery.of(context).size.width * 0.04,
                  ),
                ),
                HabitTile(
                  title: 'Ler 30 Minutos',
                  icon: Icons.menu_book,
                  iconColor: Colors.lightBlueAccent,
                  onTap: () {},
                  fontSize: math.max(
                    14.0,
                    MediaQuery.of(context).size.width * 0.04,
                  ),
                ),
                HabitTile(
                  title: 'Meditar',
                  icon: Icons.favorite,
                  iconColor: Colors.amberAccent,
                  onTap: () {},
                  fontSize: math.max(
                    14.0,
                    MediaQuery.of(context).size.width * 0.04,
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

  // Removido: _drawerItem não é mais usado
  // Widget _drawerItem(IconData icon, String title, VoidCallback onTap) {
  //   return ListTile(
  //     leading: Icon(
  //       icon,
  //       color: Colors.white,
  //       size: math.max(18.0, MediaQuery.of(context).size.width * 0.04),
  //     ),
  //     title: Text(
  //       title,
  //       style: GoogleFonts.inter(
  //         color: Colors.white,
  //         fontSize: math.max(12.0, MediaQuery.of(context).size.width * 0.035),
  //         fontWeight: FontWeight.w500,
  //       ),
  //     ),
  //     onTap: onTap,
  //   );
  // }
}
