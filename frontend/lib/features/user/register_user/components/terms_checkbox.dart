import 'package:flutter/material.dart';

class TermsCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const TermsCheckbox({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (bool? val) => onChanged(val ?? false),
          activeColor: Color(0xFF2196F3),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: 'Aceito todos os ',
              style: TextStyle(color: Colors.white),
              children: [
                TextSpan(
                  text: 'termos e condições',
                  style: TextStyle(
                    color: Color(0xFF2196F3),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
