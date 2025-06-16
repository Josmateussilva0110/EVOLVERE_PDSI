import 'package:flutter/material.dart';

class CustomTopCurve extends StatelessWidget {
  final String label;
  final VoidCallback? onBack;

  const CustomTopCurve({super.key, required this.label, this.onBack});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(double.infinity, double.infinity),
            painter: TopCurvePainter(),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                left: 16,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white70),
                onPressed: onBack ?? () => Navigator.of(context).pop(),
              ),
            ),
          ),
          Positioned(
            top: 60,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class TopCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF1F222A);

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height * 0.7);

    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 1.0,
      size.width,
      size.height * 0.7,
    );

    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
