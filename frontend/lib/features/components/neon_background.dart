import 'package:flutter/material.dart';
import 'dart:math' as math;

class NeonBackground extends StatefulWidget {
  final Widget child;

  const NeonBackground({Key? key, required this.child}) : super(key: key);

  @override
  _NeonBackgroundState createState() => _NeonBackgroundState();
}

class _NeonBackgroundState extends State<NeonBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<NeonParticle> _particles = [];
  final int _numberOfParticles = 30;
  Offset? _touchPosition;
  double _touchRadius = 150.0;
  double _touchForce = 0.1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    )..repeat();

    // Inicializa as partículas
    for (int i = 0; i < _numberOfParticles; i++) {
      _particles.add(NeonParticle());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onPanStart: (details) {
            setState(() {
              _touchPosition = details.localPosition;
            });
          },
          onPanUpdate: (details) {
            setState(() {
              _touchPosition = details.localPosition;
            });
          },
          onPanEnd: (details) {
            setState(() {
              _touchPosition = null;
            });
          },
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: NeonPainter(
                  particles: _particles,
                  animation: _controller.value,
                  touchPosition: _touchPosition,
                  touchRadius: _touchRadius,
                  touchForce: _touchForce,
                ),
                child: Container(),
              );
            },
          ),
        ),
        widget.child,
      ],
    );
  }
}

class NeonParticle {
  double x = math.Random().nextDouble();
  double y = math.Random().nextDouble();
  double speed = 0.2 + math.Random().nextDouble() * 0.3;
  double size = 2 + math.Random().nextDouble() * 3;
  double opacity = 0.1 + math.Random().nextDouble() * 0.2;
  double baseX = 0;
  double baseY = 0;
  double velocityX = 0;
  double velocityY = 0;

  NeonParticle() {
    baseX = x;
    baseY = y;
  }
}

class NeonPainter extends CustomPainter {
  final List<NeonParticle> particles;
  final double animation;
  final Offset? touchPosition;
  final double touchRadius;
  final double touchForce;

  NeonPainter({
    required this.particles,
    required this.animation,
    this.touchPosition,
    required this.touchRadius,
    required this.touchForce,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.1)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3);

    for (var particle in particles) {
      // Atualiza a posição base da partícula
      particle.baseY = (particle.baseY + particle.speed * 0.01) % 1.0;
      particle.baseX =
          (particle.baseX +
              math.sin(animation * 2 * math.pi + particle.baseY * 10) * 0.01) %
          1.0;

      // Calcula a posição final considerando o toque
      double finalX = particle.baseX;
      double finalY = particle.baseY;

      if (touchPosition != null) {
        double touchX = touchPosition!.dx / size.width;
        double touchY = touchPosition!.dy / size.height;
        double distance = math.sqrt(
          math.pow(touchX - particle.baseX, 2) +
              math.pow(touchY - particle.baseY, 2),
        );

        if (distance < touchRadius / size.width) {
          double force =
              (1 - distance / (touchRadius / size.width)) * touchForce;
          double angle = math.atan2(
            particle.baseY - touchY,
            particle.baseX - touchX,
          );

          // Atualiza a velocidade da partícula
          particle.velocityX += math.cos(angle) * force;
          particle.velocityY += math.sin(angle) * force;

          // Aplica a velocidade
          finalX += particle.velocityX;
          finalY += particle.velocityY;

          // Reduz a velocidade gradualmente
          particle.velocityX *= 0.95;
          particle.velocityY *= 0.95;
        }
      }

      // Desenha a partícula
      canvas.drawCircle(
        Offset(finalX * size.width, finalY * size.height),
        particle.size,
        paint..color = Colors.white.withOpacity(particle.opacity),
      );
    }
  }

  @override
  bool shouldRepaint(NeonPainter oldDelegate) => true;
}
