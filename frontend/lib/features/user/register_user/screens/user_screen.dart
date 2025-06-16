import 'package:flutter/material.dart';
import '../../../components/auth_header.dart';
import '../components/register_form.dart';
import '../../widgets/footer.dart';
import '../../../components/neon_background.dart';

class RegisterUserScreen extends StatelessWidget {
  const RegisterUserScreen({super.key});

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
                vertical: isSmallScreen ? 16.0 : 24.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AuthHeader(title: "Cadastrar"),
                  SizedBox(height: isSmallScreen ? 32 : 48),
                  RegisterForm(),
                  SizedBox(height: isSmallScreen ? 16 : 24),
                  const Footer(
                    routeName: '/login',
                    mensagem: 'Já tem conta?',
                    acao: 'Entrar',
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
