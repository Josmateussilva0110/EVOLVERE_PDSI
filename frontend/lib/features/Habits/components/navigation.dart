import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../frequency_screen/themes/frequency_theme.dart';
import '../frequency_screen/widgets/navigation_dots.dart';

class FrequencyBottomNavigation extends StatelessWidget {
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final String previousLabel;
  final String nextLabel;
  final int currentIndex;

  const FrequencyBottomNavigation({
    Key? key,
    required this.onPrevious,
    required this.onNext,
    this.previousLabel = 'Anterior',
    this.nextLabel = 'Próxima',
    this.currentIndex = 0,
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
              previousLabel,
              style: GoogleFonts.inter(
                color: FrequencyTheme.textColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          NavigationDots(currentIndex: currentIndex, totalDots: 3),
          TextButton(
            onPressed: onNext,
            child: Text(
              nextLabel,
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
