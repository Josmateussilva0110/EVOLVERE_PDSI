import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../habit_screen/themes/habits_theme.dart';

class HeaderAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;

  const HeaderAppBar({Key? key, required this.title, this.onBack})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: HabitsTheme.textColor),
        onPressed: onBack ?? () => Navigator.of(context).pop(),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          color: HabitsTheme.textColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
