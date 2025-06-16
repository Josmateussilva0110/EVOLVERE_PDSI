import 'package:flutter/material.dart';

enum PasswordStrength { weak, medium, strong }

class PasswordStrengthIndicator extends StatelessWidget {
  final String password;
  final PasswordStrength strength;

  const PasswordStrengthIndicator({
    Key? key,
    required this.password,
    required this.strength,
  }) : super(key: key);

  String get strengthText {
    switch (strength) {
      case PasswordStrength.weak:
        return 'Senha fraca';
      case PasswordStrength.medium:
        return 'Senha média';
      case PasswordStrength.strong:
        return 'Senha forte';
    }
  }

  Color get strengthColor {
    switch (strength) {
      case PasswordStrength.weak:
        return Colors.red;
      case PasswordStrength.medium:
        return Colors.orange;
      case PasswordStrength.strong:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value:
              strength == PasswordStrength.weak
                  ? 0.33
                  : strength == PasswordStrength.medium
                  ? 0.66
                  : 1.0,
          backgroundColor: Colors.grey[800],
          valueColor: AlwaysStoppedAnimation<Color>(strengthColor),
          minHeight: 4,
        ),
        SizedBox(height: 4),
        Text(
          strengthText,
          style: TextStyle(color: strengthColor, fontSize: 12),
        ),
      ],
    );
  }
}
