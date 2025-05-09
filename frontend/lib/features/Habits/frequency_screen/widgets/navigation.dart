import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../themes/frequency_theme.dart';
import 'navigation_dots.dart';

class FrequencyBottomNavigation extends StatelessWidget {
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const FrequencyBottomNavigation({
    Key? key,
    required this.onPrevious,
    required this.onNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: FrequencyTheme.backgroundColor,
        border: Border(top: BorderSide(color: Colors.grey[900]!, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: onPrevious,
            child: Text(
              'Anterior',
              style: GoogleFonts.inter(
                color: FrequencyTheme.textColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          NavigationDots(currentIndex: 1, totalDots: 3),
          TextButton(
            onPressed: onNext,
            child: Text(
              'Próxima',
              style: GoogleFonts.inter(
                color: FrequencyTheme.accentColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
