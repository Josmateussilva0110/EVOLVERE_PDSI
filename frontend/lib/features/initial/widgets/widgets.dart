import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../components/welcome_neon_background.dart';
import '../../user/tela_login/widgets/logo_dialog.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeLogo, _fadeTitle, _fadeSubtitle, _fadeButtons;
  int _motivationIndex = 0;
  final List<String> _motivations = [
    'Você é capaz de mudar sua rotina!',
    'Pequenos passos, grandes conquistas.',
    'A evolução começa hoje.',
    'Persistência é o segredo.',
    'Construa hábitos, construa seu futuro.',
  ];
  bool _colorMode = false;
  double _parallax = 0.0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );
    _fadeLogo = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );
    _fadeTitle = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Interval(0.2, 0.6, curve: Curves.easeOut),
      ),
    );
    _fadeSubtitle = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Interval(0.4, 0.7, curve: Curves.easeOut),
      ),
    );
    _fadeButtons = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );
    _animController.forward();
    Timer.periodic(Duration(seconds: 5), (_) {
      if (mounted)
        setState(
          () => _motivationIndex = (_motivationIndex + 1) % _motivations.length,
        );
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleLogoPress() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => const LogoDialog(),
    );
  }

  void _handleLogoLongPress() {
    HapticFeedback.mediumImpact();
    setState(() {
      _colorMode = !_colorMode;
    });

    // Mostrar feedback visual temporário
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _colorMode ? 'Modo Colorido ativado' : 'Modo Minimalista ativado',
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 1),
        backgroundColor: _colorMode ? Colors.blue : Colors.grey,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      backgroundColor: Colors.black,
      body: NotificationListener<ScrollNotification>(
        onNotification: (scroll) {
          setState(() {
            _parallax = (scroll.metrics.pixels / 100).clamp(-1.0, 1.0);
          });
          return false;
        },
        child: Stack(
          children: [
            WelcomeNeonBackground(colorMode: _colorMode, parallax: _parallax),
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      FadeTransition(
                        opacity: _fadeLogo,
                        child: GestureDetector(
                          onTap: _handleLogoPress,
                          onLongPress: _handleLogoLongPress,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Image.asset(
                              'assets/images/new_initial/image 5.png',
                              height: size.height * 0.20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      FadeTransition(
                        opacity: _fadeTitle,
                        child: Text(
                          'Bem-vindo(a)!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize:
                                math.max(24.0, size.width * 0.07) * textScale,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            shadows: [
                              Shadow(
                                color: Colors.white.withOpacity(0.35),
                                blurRadius: 16,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 12),
                      FadeTransition(
                        opacity: _fadeSubtitle,
                        child: Column(
                          children: [
                            Text(
                              'Construa hábitos reais. Um dia de cada vez.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize:
                                    math.max(14.0, size.width * 0.04) *
                                    textScale,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            AnimatedSwitcher(
                              duration: Duration(milliseconds: 600),
                              child: Text(
                                _motivations[_motivationIndex],
                                key: ValueKey(_motivationIndex),
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize:
                                      math.max(13.0, size.width * 0.035) *
                                      textScale,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      FadeTransition(
                        opacity: _fadeButtons,
                        child: Column(
                          children: [
                            _buildButton(context, 'Entrar', () {
                              HapticFeedback.lightImpact();
                              _handleNavigation('/login');
                            }, true),
                            const SizedBox(height: 16),
                            _buildButton(context, 'Criar Conta', () {
                              HapticFeedback.lightImpact();
                              _handleNavigation('/cadastro_usuario');
                            }, false),
                            const SizedBox(height: 24),
                            // Dica para o usuário sobre a funcionalidade
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                '💡 Clique e segure na logo para alternar o tema',
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize:
                                      math.max(11.0, size.width * 0.03) *
                                      textScale,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  '2025 © EVOLVERE',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12 * textScale,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNavigation(String route) {
    Navigator.pushNamed(context, route);
  }

  Widget _buildButton(
    BuildContext context,
    String text,
    VoidCallback onPressed,
    bool isPrimary,
  ) {
    final size = MediaQuery.of(context).size;
    final buttonHeight = math.max(48.0, size.height * 0.055);
    final fontSize = math.max(15.0, size.width * 0.038);

    return Container(
      width: double.infinity,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? Colors.white : Colors.transparent,
          foregroundColor: isPrimary ? Colors.black : Colors.white,
          elevation: 6,
          shadowColor: Colors.white.withOpacity(0.18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color:
                  isPrimary
                      ? Colors.transparent
                      : Colors.white.withOpacity(0.8),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
