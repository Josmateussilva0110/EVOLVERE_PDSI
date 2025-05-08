import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../themes/habits_theme.dart';

class BottomNavigation extends StatelessWidget {
  final String nextRoute;

  const BottomNavigation({
    Key? key,
    required this.nextRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF17171D),
        border: Border(top: BorderSide(color: Colors.grey[900]!, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, nextRoute);
            },
            child: Text(
              'Próxima',
              style: GoogleFonts.inter(
                color: HabitsTheme.accentColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
