import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  final String mensagem;
  final String acao;
  final String routeName;

  const Footer({
    Key? key,
    required this.mensagem,
    required this.acao,
    required this.routeName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(mensagem, style: TextStyle(color: Colors.white70, fontSize: 14)),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, routeName);
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 8),
            minimumSize: Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            acao,
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
