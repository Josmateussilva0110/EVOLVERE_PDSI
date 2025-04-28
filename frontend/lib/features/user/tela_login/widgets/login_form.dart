import 'package:flutter/material.dart';
import '../widgets/gradient_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscurePassword = true;
  bool _lembrarSenha = false;

  bool _emailHovered = false;
  bool _emailFocused = false;
  bool _senhaHovered = false;
  bool _senhaFocused = false;

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _senhaFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(() {
      setState(() {
        _emailFocused = _emailFocus.hasFocus;
      });
    });
    _senhaFocus.addListener(() {
      setState(() {
        _senhaFocused = _senhaFocus.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _senhaFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final actionColor = isDark ? Colors.white : Colors.black87;
    final highlightColor = isDark ? Colors.grey[800] : Colors.grey[300];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          MouseRegion(
            onEnter: (_) => setState(() => _emailHovered = true),
            onExit: (_) => setState(() => _emailHovered = false),
            child: Container(
              decoration: BoxDecoration(
                color:
                    (_emailHovered || _emailFocused)
                        ? highlightColor
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                focusNode: _emailFocus,
                decoration: InputDecoration(
                  labelText: 'Email/Usuário',
                  labelStyle: const TextStyle(fontWeight: FontWeight.normal),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          // Campo Senha
          MouseRegion(
            onEnter: (_) => setState(() => _senhaHovered = true),
            onExit: (_) => setState(() => _senhaHovered = false),
            child: Container(
              decoration: BoxDecoration(
                color:
                    (_senhaHovered || _senhaFocused)
                        ? highlightColor
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                focusNode: _senhaFocus,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  labelStyle: const TextStyle(fontWeight: FontWeight.normal),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          GradientButton(text: 'Login', onPressed: () {}),
          const SizedBox(height: 24),
          Row(
            children: [
              Checkbox(
                value: _lembrarSenha,
                onChanged: (value) {
                  setState(() {
                    _lembrarSenha = value ?? false;
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Text(
                'Lembrar minha senha',
                style: TextStyle(
                  color: actionColor,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Esqueci minha senha',
                  style: TextStyle(
                    color: actionColor,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
