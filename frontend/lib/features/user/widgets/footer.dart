import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Footer extends StatelessWidget {
  final String routeName;
  final String mensagem;
  final String acao;

  const Footer({
    super.key,
    required this.routeName,
    required this.mensagem,
    required this.acao,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          mensagem,
          style: GoogleFonts.inter(fontSize: 14, color: Colors.white70),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, routeName);
          },
          child: Text(
            acao,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
