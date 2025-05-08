import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryHeader extends StatelessWidget {
  final String title;

  const CategoryHeader({Key? key, this.title = 'Categoria'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
