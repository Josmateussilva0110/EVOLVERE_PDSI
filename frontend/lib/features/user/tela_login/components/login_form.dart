import 'package:flutter/material.dart';
import '../../widgets/form_container.dart';
import '../../widgets/text_field.dart';
import '../../widgets/password_field.dart';
import '../widgets/login_options.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscurePassword = true;
  bool _lembrarSenha = false;

  @override
  Widget build(BuildContext context) {
    return FormContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(label: 'Email/Usuário'),
          SizedBox(height: 20),
          CustomPasswordField(
            label: 'Senha',
            obscureText: _obscurePassword,
            toggle: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
          SizedBox(height: 20),

          LoginOptionsRow(
            lembrarSenha: _lembrarSenha,
            onLembrarSenhaChanged: (value) {
              setState(() => _lembrarSenha = value);
            },
            onEsqueciSenha: () {
              print('Usuário clicou em "Esqueci minha senha"');
            },
          ),
        ],
      ),
    );
  }
}
