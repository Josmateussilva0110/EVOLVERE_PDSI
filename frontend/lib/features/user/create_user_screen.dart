import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: RegisterUserScreen()));

class RegisterUserScreen extends StatefulWidget {
  @override
  _RegisterUserScreenState createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 65, 84, 192),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(88),
                    bottomRight: Radius.circular(88),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 40),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 12),
                    Center(
                      child: Text(
                        'Cadastrar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextField(
                      label: "Usuário",
                      hint: "Digite o nome do Usuário",
                    ),
                    SizedBox(height: 20),
                    _buildTextField(label: "Email", hint: "Digite seu email"),
                    SizedBox(height: 20),
                    _buildPasswordField(
                      label: "Senha",
                      hint: "Digite sua Senha",
                      obscureText: _obscurePassword,
                      toggle: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                    SizedBox(height: 20),
                    _buildPasswordField(
                      label: "Confirmar Senha",
                      hint: "Confirme sua Senha",
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
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 65, 84, 192),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      child: Text('Registrar', style: TextStyle(fontSize: 16)),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: 'Já tem uma conta? ',
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: 'Login',
                              style: TextStyle(
                                color: Color(0xFF5A4DE2),
                                fontWeight: FontWeight.bold,
                              ),
                              // Add onTap functionality if needed
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required String hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),

            // Sem borda quando não está focado
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),

            // Com borda colorida ao focar
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Color.fromARGB(255, 65, 84, 192),
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required String hint,
    required bool obscureText,
    required VoidCallback toggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 5),
        TextField(
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[100],
            suffixIcon: IconButton(
              icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
              onPressed: toggle,
            ),

            contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            // Sem borda quando não está focado
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),

            // Com borda colorida ao focar
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Color.fromARGB(255, 65, 84, 192),
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
