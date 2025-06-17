import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../components/welcome_neon_background.dart';
import '../../user/tela_login/widgets/logo_dialog.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handleLogoPress() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => const LogoDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          WelcomeNeonBackground(),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: _handleLogoPress,
                      child: Image.asset(
                        'assets/images/new_initial/image 5.png',
                        height: size.height * 0.20,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Bem-vindo(a)!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: math.max(24.0, size.width * 0.07),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Construa hábitos reais. Um dia de cada vez.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: math.max(14.0, size.width * 0.04),
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    _buildButton(context, 'Entrar', () {
                      _handleNavigation('/login');
                    }, true),
                    const SizedBox(height: 16),
                    _buildButton(context, 'Criar Conta', () {
                      _handleNavigation('/cadastro_usuario');
                    }, false),
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
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
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
          elevation: 0,
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
