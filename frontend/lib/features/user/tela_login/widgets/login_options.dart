import 'package:flutter/material.dart';

class LoginOptionsRow extends StatefulWidget {
  final bool lembrarSenha;
  final ValueChanged<bool> onLembrarSenhaChanged;
  final VoidCallback onEsqueciSenha;

  const LoginOptionsRow({
    Key? key,
    required this.lembrarSenha,
    required this.onLembrarSenhaChanged,
    required this.onEsqueciSenha,
  }) : super(key: key);

  @override
  _LoginOptionsRowState createState() => _LoginOptionsRowState();
}

class _LoginOptionsRowState extends State<LoginOptionsRow> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 10,
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
              activeColor: Color(0xFF2196F3),
              checkColor: Colors.white,
            ),
            const Text("Lembrar minha senha", style: TextStyle(
              color: Colors.white,
              fontSize: 11,
            ),),
          ],
        ),
        TextButton(
          onPressed: widget.onEsqueciSenha,
          child: const Text("Esqueci minha senha", style: TextStyle(
            color: Colors.blue,
            fontSize: 11,
          ),),
        ),
      ],
    );
  }
}
