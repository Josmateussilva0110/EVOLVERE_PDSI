import 'package:flutter/material.dart';

class LoginOptionsRow extends StatefulWidget {
  final bool lembrarSenha;
  final ValueChanged<bool> onLembrarSenhaChanged;
  final VoidCallback onEsqueciSenha;

  const LoginOptionsRow({
    super.key,
    required this.lembrarSenha,
    required this.onLembrarSenhaChanged,
    required this.onEsqueciSenha,
  });

  @override
  State<LoginOptionsRow> createState() => _LoginOptionsRowState();
}

class _LoginOptionsRowState extends State<LoginOptionsRow> {
  @override
  Widget build(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: widget.lembrarSenha,
              onChanged: (value) {
                if (value != null) {
                  widget.onLembrarSenhaChanged(value);
                }
              },
              activeColor: const Color(0xFF2196F3),
              checkColor: Colors.white,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            Text(
              "Lembrar-me",
              style: TextStyle(
                color: isLightMode ? Colors.black87 : Colors.white,
                fontSize: 11,
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: widget.onEsqueciSenha,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            "Esqueci a senha?",
            style: TextStyle(
              color: isLightMode ? Colors.blue.shade700 : Colors.blue,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}
