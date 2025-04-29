import 'package:flutter/material.dart';
import '../../components/custom_top_curve.dart';
import '../components/register_form.dart';

class RegisterUserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTopCurve(label: "Cadastrar"),
              SizedBox(height: 2),
              RegisterForm(),
              SizedBox(height: 12),
              _LoginRedirect(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginRedirect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: 'Já tem uma conta? ',
          style: TextStyle(color: Colors.white),
          children: [
            TextSpan(
              text: 'Entrar',
              style: TextStyle(
                color: Color(0xFF2196F3),
                fontWeight: FontWeight.bold,
              ),
              // Pode adicionar navegação aqui
            ),
          ],
        ),
      ),
    );
  }
}
