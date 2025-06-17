import 'package:flutter/material.dart';
import '../../widgets/password_field.dart';
import '../../widgets/text_field.dart';
import 'terms_checkbox.dart';
import '../../widgets/form_container.dart';
import '../../widgets/password_strength_indicator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  bool _isButtonEnabled = false;
  PasswordStrength _passwordStrength = PasswordStrength.weak;

  final _formKey = GlobalKey<FormState>();

  PasswordStrength _calculatePasswordStrength(String password) {
    if (password.isEmpty) return PasswordStrength.weak;

    int score = 0;

    // Comprimento
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;

    // Complexidade
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_updateButtonState);
    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(() {
      setState(() {
        _passwordStrength = _calculatePasswordStrength(
          _passwordController.text,
        );
      });
      _updateButtonState();
    });
    _confirmPasswordController.addListener(_updateButtonState);
    _updateButtonState();
  }

  @override
  void dispose() {
    _usernameController.removeListener(_updateButtonState);
    _emailController.removeListener(_updateButtonState);
    _passwordController.removeListener(_updateButtonState);
    _confirmPasswordController.removeListener(_updateButtonState);
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled =
          _usernameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty &&
          _acceptTerms;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 600;

    return FormContainer(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                label: "Usuário",
                controller: _usernameController,
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu nome de usuário';
                  }
                  return null;
                },
              ),
              SizedBox(height: isSmallScreen ? 12 : 16),
              CustomTextField(
                label: "Email",
                controller: _emailController,
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu email';
                  }
                  if (!RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                  ).hasMatch(value)) {
                    return 'Por favor, insira um email válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: isSmallScreen ? 12 : 16),
              CustomPasswordField(
                label: "Senha",
                obscureText: _obscurePassword,
                toggle:
                    () => setState(() => _obscurePassword = !_obscurePassword),
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua senha';
                  }
                  if (value.length < 6) {
                    return 'A senha deve ter pelo menos 6 caracteres';
                  }
                  return null;
                },
              ),
              SizedBox(height: isSmallScreen ? 6 : 8),
              PasswordStrengthIndicator(
                password: _passwordController.text,
                strength: _passwordStrength,
              ),
              SizedBox(height: isSmallScreen ? 12 : 16),
              CustomPasswordField(
                label: "Confirmar senha",
                obscureText: _obscureConfirmPassword,
                toggle:
                    () => setState(
                      () => _obscureConfirmPassword = !_obscureConfirmPassword,
                    ),
                controller: _confirmPasswordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, confirme sua senha';
                  }
                  if (value != _passwordController.text) {
                    return 'As senhas não coincidem';
                  }
                  return null;
                },
              ),
              if (_confirmPasswordController.text.isNotEmpty &&
                  _confirmPasswordController.text != _passwordController.text)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'As senhas não coincidem',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              SizedBox(height: isSmallScreen ? 12 : 16),
              TermsCheckbox(
                value: _acceptTerms,
                onChanged: (value) {
                  setState(() => _acceptTerms = value ?? false);
                  _updateButtonState();
                },
              ),
              SizedBox(height: isSmallScreen ? 24 : 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isButtonEnabled ? const Color(0xFF2196F3) : Colors.grey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed:
                    _isButtonEnabled
                        ? () async {
                          if (_formKey.currentState!.validate()) {
                            if (!_acceptTerms) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Você precisa aceitar os termos",
                                  ),
                                ),
                              );
                              return;
                            }

                            final response = await http.post(
                              Uri.parse('${dotenv.env['API_URL']}/user'),
                              headers: {'Content-Type': 'application/json'},
                              body: jsonEncode({
                                'username': _usernameController.text,
                                'email': _emailController.text,
                                'password': _passwordController.text,
                              }),
                            );

                            if (response.statusCode == 200) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Cadastro realizado com sucesso!',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.pushReplacementNamed(context, '/');
                            } else {
                              String errorMessage =
                                  'Erro ao cadastrar. Tente novamente.';
                              try {
                                final Map<String, dynamic> data = jsonDecode(
                                  response.body,
                                );
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
                          }
                        }
                        : null,
                child: const Text('Cadastrar', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
