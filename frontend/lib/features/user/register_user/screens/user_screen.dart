import 'package:flutter/material.dart';
import '../../components/custom_top_curve.dart';
import '../components/register_form.dart';
import '../../widgets/footer.dart';

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
              Footer(mensagem: 'Já tem conta ? ', acao: 'Entrar',),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
