import 'package:flutter/material.dart';
import '../user/tela_login/components/custom_top_curve.dart';

void main() => runApp(MaterialApp(home: RegisterUserScreen()));

class RegisterUserScreen extends StatefulWidget {
  @override
  _RegisterUserScreenState createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTopCurve(label: "Cadastrar"),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFF1D1D1D),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTextField(label: "Usuário"),
                      SizedBox(height: 20),
                      _buildTextField(label: "Email"),
                      SizedBox(height: 20),
                      _buildPasswordField(
                        label: "Senha",
                        obscureText: _obscurePassword,
                        toggle: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                      SizedBox(height: 20),
                      _buildPasswordField(
                        label: "Confirmar Senha",
                        obscureText: _obscureConfirmPassword,
                        toggle: () {
                          setState(
                            () =>
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword,
                          );
                        },
                      ),
                      SizedBox(height: 30),
                      Row(
                        children: [
                          Checkbox(
                            value: _acceptTerms,
                            onChanged: (bool? value) {
                              setState(() {
                                _acceptTerms = value ?? false;
                              });
                            },
                            activeColor: Color(0xFF2196F3),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: 'Aceito todos os ',
                                style: TextStyle(color: Colors.white),
                                children: [
                                  TextSpan(
                                    text: 'termos e condições',
                                    style: TextStyle(
                                      color: Color(0xFF2196F3),
                                      decoration: TextDecoration.underline,
                                    ),
                                    // Aqui você pode adicionar lógica de clique se quiser abrir outra tela
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
                        onPressed: () {},
                        child: Text(
                          'Cadastrar',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
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
                        // Pode adicionar funcionalidade de clique aqui
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String label}) {
    return TextField(
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Color(0xFF2C2C2C),
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF2196F3), width: 2),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required bool obscureText,
    required VoidCallback toggle,
  }) {
    return TextField(
      obscureText: obscureText,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Color(0xFF2C2C2C),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.white70,
          ),
          onPressed: toggle,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF2196F3), width: 2),
        ),
      ),
    );
  }
}
