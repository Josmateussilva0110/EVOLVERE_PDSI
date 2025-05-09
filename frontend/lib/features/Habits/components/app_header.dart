import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Appbody extends StatelessWidget {
  final String title;

  const Appbody({Key? key, required this.title}) : super(key: key);

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
