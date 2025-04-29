import 'package:flutter/material.dart';
import '../../widgets/password_field.dart';
import '../../widgets/text_field.dart';
import 'terms_checkbox.dart';
import '../../widgets/form_container.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    return FormContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(label: "Usuário"),
          SizedBox(height: 20),
          CustomTextField(label: "Email"),
          SizedBox(height: 20),
          CustomPasswordField(
            label: "Senha",
            obscureText: _obscurePassword,
            toggle: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
          SizedBox(height: 20),
          CustomPasswordField(
            label: "Confirmar senha",
            obscureText: _obscureConfirmPassword,
            toggle:
                () => setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword,
                ),
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
            onPressed: () {
              // lógica de cadastro
            },
            child: Text('Cadastrar', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
