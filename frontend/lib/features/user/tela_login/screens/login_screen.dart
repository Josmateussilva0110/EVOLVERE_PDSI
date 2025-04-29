import 'package:flutter/material.dart';
import '../widgets/login_form.dart';
import '../widgets/theme_toggle_button.dart';
import '../components/custom_top_curve.dart';

class LoginScreen extends StatelessWidget {
  final VoidCallback toggleTheme;

  const LoginScreen({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          const CustomTopCurve(label: 'Login',),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: ThemeToggleButton(onPressed: toggleTheme),
                ),
                const SizedBox(height: 10),
                Text(
                  'Acesse',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 44,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Com o e-mail e senha para entrar',
                  style: textTheme.bodyLarge?.copyWith(
                    fontSize: 18,
                    color: Colors.white.withOpacity(0.85),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 120),
                const LoginForm(),
                const SizedBox(height: 16),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Não tem uma conta? ',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(4),
                        onTap: () {
                          // ação de cadastro
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2,
                            vertical: 4,
                          ),
                          child: Text(
                            'Cadastrar',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
