import 'package:flutter/material.dart';
import '../../widgets/password_field.dart';
import '../../widgets/text_field.dart';
import 'terms_checkbox.dart';
import '../../widgets/form_container.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

    @override
    void dispose() {
      _usernameController.dispose();
      _emailController.dispose();
      _passwordController.dispose();
      _confirmPasswordController.dispose();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    return FormContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(label: "Usuário", controller: _usernameController,),
          SizedBox(height: 20),
          CustomTextField(label: "Email", controller: _emailController,),
          SizedBox(height: 20),
          CustomPasswordField(
            label: "Senha",
            obscureText: _obscurePassword,
            toggle: () => setState(() => _obscurePassword = !_obscurePassword),
            controller: _passwordController,
          ),
          SizedBox(height: 20),
          CustomPasswordField(
            label: "Confirmar senha",
            obscureText: _obscureConfirmPassword,
            toggle:
                () => setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword,
                ),
            controller: _confirmPasswordController,
          ),
          SizedBox(height: 20),
          TermsCheckbox(
            value: _acceptTerms,
            onChanged: (value) => setState(() => _acceptTerms = value),
          ),
          SizedBox(height: 20),
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
              if (!_acceptTerms) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Você precisa aceitar os termos")),
                );
                return;
              }

              final response = await http.post(
                Uri.parse('http://192.168.1.8:8080/user'), 
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode({
                  'username': _usernameController.text,
                  'email': _emailController.text,
                  'password': _passwordController.text,
                }),
              );

              if (response.statusCode == 200) {
                ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Cadastro realizado com sucesso!'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pushReplacementNamed(context, '/');

              } else {
                String errorMessage = 'Erro ao cadastrar. Tente novamente.';
                try {
                  final Map<String, dynamic> data = jsonDecode(response.body);
                  if (data.containsKey('err')) {
                    errorMessage = data['err'];
                  }
                } catch (_) {
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(errorMessage),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },

            child: Text('Cadastrar', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
