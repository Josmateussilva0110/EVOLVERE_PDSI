import 'package:flutter/material.dart';
import '../../widgets/form_container.dart';
import '../../widgets/text_field.dart';
import '../../widgets/password_field.dart';
import '../widgets/login_options.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _lembrarSenha = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(label: 'Email/Usuário', controller: _emailController),
          SizedBox(height: 20),
          CustomPasswordField(
            label: 'Senha',
            obscureText: _obscurePassword,
            toggle: () => setState(() => _obscurePassword = !_obscurePassword),
            controller: _passwordController,
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
          SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2196F3),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            onPressed: () async {
              final response = await http.post(
                Uri.parse('${dotenv.env['API_URL']}/login'),
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode({
                  'email': _emailController.text,
                  'password': _passwordController.text,
                }),
              );

              if (response.statusCode == 200) {
                final Map<String, dynamic> responseData = jsonDecode(
                  response.body,
                );
                final int? userId = responseData['userId'];
                final String? username = responseData['username'];

                if (userId != null && username != null) {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setInt('loggedInUserId', userId);
                  await prefs.setString('username', username);
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Login realizado com sucesso!'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pushReplacementNamed(context, '/inicio');
              } else {
                String errorMessage = 'Erro no login';
                try {
                  final Map<String, dynamic> data = jsonDecode(response.body);
                  if (data.containsKey('err')) {
                    errorMessage = data['err'];
                  }
                } catch (_) {}

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(errorMessage),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text('Login', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
