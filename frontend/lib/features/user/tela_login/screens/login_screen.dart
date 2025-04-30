import 'package:flutter/material.dart';
import '../../components/custom_top_curve.dart';
import '../components/login_form.dart';
import '../../widgets/footer.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTopCurve(label: "Acessar"),
              SizedBox(height: 2),
              LoginForm(),
              SizedBox(height: 12),
              Footer(mensagem: 'Não tem conta? ', acao: 'Cadastrar',),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
