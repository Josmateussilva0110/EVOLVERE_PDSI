import 'package:flutter/material.dart';

class CustomTopCurve extends StatelessWidget {
  const CustomTopCurve({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 250,
      child: CustomPaint(painter: TopCurvePainter()),
    );
  }
}

class TopCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF2196F3);

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height * 0.65);

    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 1.05,
      size.width,
      size.height * 0.65,
    );

    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
