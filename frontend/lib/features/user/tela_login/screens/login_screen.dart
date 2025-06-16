import 'package:flutter/material.dart';
import '../../../components/auth_header.dart';
import '../components/login_form.dart';
import '../../widgets/footer.dart';
import '../../../components/neon_background.dart';
import '../widgets/logo_dialog.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 600;

    return Scaffold(
      body: NeonBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: isSmallScreen ? 4.0 : 8.0,
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
                      child: const AuthHeader(title: "Acessar"),
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 16 : 24),
                  LoginForm(),
                  SizedBox(height: isSmallScreen ? 4 : 8),
                  const Footer(
                    routeName: '/cadastro_usuario',
                    mensagem: 'Não possui conta? ',
                    acao: 'Criar agora',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
