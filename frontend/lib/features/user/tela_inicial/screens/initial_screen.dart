import 'package:flutter/material.dart';
import '../../../components/neon_background.dart';
import '../../tela_login/widgets/logo_dialog.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 600;

    return Scaffold(
      body: NeonBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: size.height,
              padding: EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: isSmallScreen ? 16.0 : 24.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierColor: Colors.black.withOpacity(0.7),
                        builder: (context) => const LogoDialog(),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: isSmallScreen ? 120 : 150,
                      ),
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 32 : 48),
                  _buildButton(
                    context,
                    'Acessar',
                    () => Navigator.pushNamed(context, '/login'),
                    isSmallScreen,
                  ),
                  SizedBox(height: isSmallScreen ? 16 : 24),
                  _buildButton(
                    context,
                    'Criar Conta',
                    () => Navigator.pushNamed(context, '/cadastro_usuario'),
                    isSmallScreen,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    String text,
    VoidCallback onPressed,
    bool isSmallScreen,
  ) {
    return SizedBox(
      width: double.infinity,
      height: isSmallScreen ? 45 : 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: isSmallScreen ? 16 : 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
