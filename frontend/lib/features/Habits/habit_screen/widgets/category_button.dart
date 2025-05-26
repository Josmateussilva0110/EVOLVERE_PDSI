import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../themes/habits_theme.dart';

class CategoryButton extends StatelessWidget {
  final Widget icon; 
  final String label;
  final dynamic category;
  final bool isSelected;
  final void Function(dynamic) onSelect;

  const CategoryButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.category,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onSelect(category),
      child: Container(
        width: (MediaQuery.of(context).size.width - 48) / 2,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? HabitsTheme.accentColor : HabitsTheme.inputBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? HabitsTheme.accentColor : HabitsTheme.borderColor,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon, // icon pode ser qualquer Widget, como Icon ou Image
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                color: HabitsTheme.textColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
