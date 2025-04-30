import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  final String mensagem;
  final String acao;
  final VoidCallback? onTap;

  const Footer({
    Key? key,
    required this.mensagem,
    required this.acao,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: mensagem,
          style: const TextStyle(color: Colors.white),
          children: [
            TextSpan(
              text: acao,
              style: const TextStyle(
                color: Color(0xFF2196F3),
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()..onTap = onTap,
            ),
          ],
        ),
      ),
    );
  }
}
