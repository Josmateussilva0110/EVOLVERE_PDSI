import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../user/screens/edit_profile_screen.dart';
import 'services/home_service.dart';

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


  int _completedTodayCount = 0;
  bool _loadingCompletedToday = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCompletedTodayCount();
    });
  }

  Future<void> _loadCompletedTodayCount() async {
    if (_userId == null) {
      print('UserId nulo, não vai buscar contagem');
      return;
    }
    setState(() {
      _loadingCompletedToday = true;
    });
    try {
      final count = await HomeService.fetchCompletedTodayCount(_userId!);
      print('Contagem recebida: $count');
      setState(() {
        _completedTodayCount = count;
      });
    } catch (e) {
      setState(() {
        _completedTodayCount = 0;
      });
    } finally {
      setState(() {
        _loadingCompletedToday = false;
      });
    }
  }

  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('loggedInUserId');
    setState(() {
      _userName = prefs.getString('username') ?? 'Usuário';
      _userId = userId;
      _userEmail = prefs.getString('email') ?? 'usuario@example.com';
    });
    if (userId != null) {
      _loadCompletedTodayCount();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color(0xFF121217),
        drawer: _buildAppDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Olá, $_userName',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: math.max(
                20.0,
                MediaQuery.of(context).size.width * 0.05,
              ),
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: Builder(
            builder:
                (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white, size: 32),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Estatísticas
                      Row(
                        children: [
                          Expanded(child: _statCard('Sequência Diária', '3')),
                          const SizedBox(width: 15),
                          Expanded(
                            child:
                                _loadingCompletedToday
                                    ? _statCard('Completados Hoje', '...')
                                    : _statCard(
                                      'Completados Hoje',
                                      _completedTodayCount.toString(),
                                    ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _statCard(
                        'Pontuação Total',
                        '246',
                        width: double.infinity,
                      ),
                      const SizedBox(height: 20),

                      // Progresso Diário (MOVIDO PARA CIMA)
                      const Text(
                        'Progresso',
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
                      const SizedBox(height: 20),

                      // Hoje
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Hábitos',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
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

                      if (_userId != null)
                        TopPrioritiesWidget(userId: _userId!),
                      SizedBox(height: 10),
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
                    ],
                  ),
                ),
              ),
              // NOVO: Box de navegação inferior
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  top: 0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF1C1F26),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Notificações à esquerda
                      _FancyIconButton(
                        icon: Icons.notifications,
                        color: Colors.white,
                        highlightColor: Colors.blueAccent,
                        size: 32,
                        onTap: () {
                          Navigator.pushNamed(context, '/notificacoes');
                        },
                      ),
                      // Relatórios centralizado
                      Expanded(
                        child: Center(
                          child: _FancyIconButton(
                            icon: Icons.bar_chart,
                            color: Colors.white,
                            highlightColor: Colors.amber,
                            size: 36,
                            onTap: () {
                              Navigator.pushNamed(context, '/relatorios');
                            },
                          ),
                        ),
                      ),
                      // Conta à direita
                      _FancyIconButton(
                        icon: Icons.person,
                        color: Colors.white,
                        highlightColor: Colors.purpleAccent,
                        size: 32,
                        onTap: () {
                          if (_userId != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => EditProfileScreen(
                                      userId: _userId!,
                                      userEmail: _userEmail,
                                    ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Erro: Usuário não carregado.'),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para estatísticas
  Widget _statCard(
    String title,
    String value, {
    double? width,
    double height = 100,
  }) {
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
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _userEmail,
                  style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          _drawerItem(Icons.category, 'Categorias', () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/listar_categorias');
          }),
          _drawerItem(Icons.check_box, 'Hábitos', () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/listar_habitos');
          }),
          _drawerItem(Icons.settings, 'Configurações', () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/configuracoes');
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
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
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

// Substituir _ZoomIconButton por _FancyIconButton, que faz zoom e mostra círculo colorido animado ao clicar
class _FancyIconButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final Color highlightColor;
  final double size;
  final VoidCallback onTap;

  const _FancyIconButton({
    required this.icon,
    required this.color,
    required this.highlightColor,
    required this.size,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  State<_FancyIconButton> createState() => _FancyIconButtonState();
}

class _FancyIconButtonState extends State<_FancyIconButton>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;
  late AnimationController _controller;
  late Animation<double> _circleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 350),
    );
    _circleAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _pressed = true;
    });
    _controller.forward(from: 0);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _pressed = false;
    });
    _controller.reverse();
  }

  void _onTapCancel() {
    setState(() {
      _pressed = false;
    });
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _pressed ? 1.18 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _circleAnim,
              builder: (context, child) {
                return Opacity(
                  opacity: _circleAnim.value * 0.5,
                  child: Container(
                    width: widget.size * (1.2 + _circleAnim.value * 0.7),
                    height: widget.size * (1.2 + _circleAnim.value * 0.7),
                    decoration: BoxDecoration(
                      color: widget.highlightColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
            Icon(widget.icon, color: widget.color, size: widget.size),
          ],
        ),
      ),
    );
  }
}
