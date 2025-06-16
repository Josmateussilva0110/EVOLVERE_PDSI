import 'package:flutter/material.dart';
import 'dart:math' as math;

class WelcomeNeonBackground extends StatefulWidget {
  @override
  _WelcomeNeonBackgroundState createState() => _WelcomeNeonBackgroundState();
}

class _WelcomeNeonBackgroundState extends State<WelcomeNeonBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<NeonCircle> _circles = [];
  final int _numberOfCircles = 3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 15),
    )..repeat();

    // Inicializa os círculos
    for (int i = 0; i < _numberOfCircles; i++) {
      _circles.add(NeonCircle());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: WelcomeNeonPainter(
            circles: _circles,
            animation: _controller.value,
          ),
          child: Container(),
        );
      },
    );
  }
}

class NeonCircle {
  double x = math.Random().nextDouble();
  double y = math.Random().nextDouble();
  double size = 100 + math.Random().nextDouble() * 200;
  double speed = 0.2 + math.Random().nextDouble() * 0.3;
  double opacity = 0.05 + math.Random().nextDouble() * 0.1;
}

class WelcomeNeonPainter extends CustomPainter {
  final List<NeonCircle> circles;
  final double animation;

  WelcomeNeonPainter({required this.circles, required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    for (var circle in circles) {
      // Atualiza a posição do círculo
      circle.x =
          (circle.x + math.sin(animation * 2 * math.pi + circle.y * 5) * 0.01) %
          1.0;
      circle.y = (circle.y + circle.speed * 0.01) % 1.0;

      // Desenha o círculo com efeito de brilho
      final paint =
          Paint()
            ..color = Colors.blue.withOpacity(circle.opacity)
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, 30);

      canvas.drawCircle(
        Offset(circle.x * size.width, circle.y * size.height),
        circle.size,
        paint,
      );

      // Adiciona um brilho interno
      final innerPaint =
          Paint()
            ..color = Colors.white.withOpacity(circle.opacity * 0.5)
            ..maskFilter = MaskFilter.blur(BlurStyle.inner, 20);

      canvas.drawCircle(
        Offset(circle.x * size.width, circle.y * size.height),
        circle.size * 0.8,
        innerPaint,
      );
    }
  }

  @override
  bool shouldRepaint(WelcomeNeonPainter oldDelegate) => true;
}
