import 'package:flutter/material.dart';
import 'terms_dialog.dart';

class TermsCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const TermsCheckbox({Key? key, required this.value, required this.onChanged})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Checkbox(value: value, onChanged: onChanged),
        Expanded(
          child: GestureDetector(
            onTap: () {
              showDialog(context: context, builder: (context) => TermsDialog());
            },
            child: Text(
              'Li e aceito os termos e condições',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
