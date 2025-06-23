import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/services.dart';

class WelcomeNeonBackground extends StatefulWidget {
  final bool colorMode;
  final double parallax;
  const WelcomeNeonBackground({
    Key? key,
    this.colorMode = false,
    this.parallax = 0.0,
  }) : super(key: key);

  @override
  _WelcomeNeonBackgroundState createState() => _WelcomeNeonBackgroundState();
}

class _WelcomeNeonBackgroundState extends State<WelcomeNeonBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final List<NeonCircle> _circles = [];
  final int _numberOfCircles = 8;
  Offset? _touchPosition;
  double _touchRadius = 350.0;
  double _touchForce = 0.25;
  int? _draggedCircleIndex;
  double _circleTouchSensitivity = 1.2; // Aumenta a área de toque

  // Para ripple
  Offset? _rippleCenter;
  double _rippleProgress = 0.0;
  late AnimationController _rippleController;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 15))
          ..addListener(() {
            setState(() {}); // Para animar suavemente
          })
          ..repeat();

    _rippleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 650),
    )..addListener(() {
      setState(() {
        _rippleProgress = _rippleController.value;
      });
    });

    // Inicializa os círculos
    for (int i = 0; i < _numberOfCircles; i++) {
      var c = NeonCircle();
      c.originalX = c.x;
      c.originalY = c.y;
      _circles.add(c);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  int? _findTouchedCircle(Offset localPosition, Size size) {
    double minDist = double.infinity;
    int? idx;
    for (int i = 0; i < _circles.length; i++) {
      final c = _circles[i];
      final cx = c.x * size.width;
      final cy = c.y * size.height;
      final dist = (Offset(cx, cy) - localPosition).distance;
      if (dist < c.baseSize * _circleTouchSensitivity && dist < minDist) {
        minDist = dist;
        idx = i;
      }
    }
    return idx;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return GestureDetector(
          onPanStart: (details) {
            final idx = _findTouchedCircle(details.localPosition, size);
            if (idx != null) {
              HapticFeedback.lightImpact();
              setState(() {
                _draggedCircleIndex = idx;
                _circles[idx].draggedX = _circles[idx].x;
                _circles[idx].draggedY = _circles[idx].y;
              });
            } else {
              // Ripple ao tocar fora dos círculos
              _rippleCenter = details.localPosition;
              _rippleController.forward(from: 0.0);
            }
          },
          onPanUpdate: (details) {
            if (_draggedCircleIndex != null) {
              final c = _circles[_draggedCircleIndex!];
              setState(() {
                c.draggedX = details.localPosition.dx / size.width;
                c.draggedY = details.localPosition.dy / size.height;
              });
            }
          },
          onPanEnd: (details) {
            if (_draggedCircleIndex != null) {
              setState(() {
                _circles[_draggedCircleIndex!].draggedX = -1;
                _circles[_draggedCircleIndex!].draggedY = -1;
                _draggedCircleIndex = null;
              });
            }
          },
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: WelcomeNeonPainter(
                  circles: _circles,
                  animation: _controller.value,
                  draggedCircleIndex: _draggedCircleIndex,
                  rippleCenter: _rippleCenter,
                  rippleProgress: _rippleProgress,
                  showRipple: _rippleController.isAnimating,
                  colorMode: widget.colorMode,
                  parallax: widget.parallax,
                ),
                child: Container(),
              );
            },
          ),
        );
      },
    );
  }
}

class NeonCircle {
  double x = math.Random().nextDouble();
  double y = math.Random().nextDouble();
  double baseSize = 120 + math.Random().nextDouble() * 60;
  double speed = 0.2 + math.Random().nextDouble() * 0.3;
  double baseOpacity = 0.18 + math.Random().nextDouble() * 0.18;
  double phase =
      math.Random().nextDouble() *
      2 *
      math.pi; // para variar o tempo de cada círculo
  // Para animação suave
  double draggedX = -1; // -1 indica não arrastando
  double draggedY = -1;
  double originalX = 0;
  double originalY = 0;
  bool get isBeingDragged => draggedX >= 0 && draggedY >= 0;
}

class WelcomeNeonPainter extends CustomPainter {
  final List<NeonCircle> circles;
  final double animation;
  final int? draggedCircleIndex;
  final Offset? rippleCenter;
  final double rippleProgress;
  final bool showRipple;
  final bool colorMode;
  final double parallax;

  WelcomeNeonPainter({
    required this.circles,
    required this.animation,
    this.draggedCircleIndex,
    this.rippleCenter,
    this.rippleProgress = 0.0,
    this.showRipple = false,
    required this.colorMode,
    required this.parallax,
  });

  // Paleta reduzida para leveza (modo escuro minimalista)
  final List<Color> neonColorsMinimal = [
    Color(0xFFFFFFFF), // branco puro
    Color(0xFFE0E0E0), // cinza claro
    Color(0xFFB0B0B0), // cinza médio
  ];

  // Paleta colorida para modo escuro
  final List<Color> neonColorsColor = [
    Color(0xFF00FFFF), // ciano
    Color(0xFF0050FF), // azul
    Color(0xFF8F00FF), // roxo
    Color(0xFFFF00FF), // rosa
    Color(0xFF00FFC8), // ciano claro
    Color(0xFFFF5AF7), // rosa claro
  ];

  @override
  void paint(Canvas canvas, Size size) {
    double? leaderX, leaderY;
    if (draggedCircleIndex != null &&
        draggedCircleIndex! >= 0 &&
        draggedCircleIndex! < circles.length) {
      leaderX = circles[draggedCircleIndex!].x;
      leaderY = circles[draggedCircleIndex!].y;
    }

    for (int i = 0; i < circles.length; i++) {
      var circle = circles[i];
      // Atualiza a posição do círculo
      if (circle.isBeingDragged) {
        // Movimento suave até o ponto do dedo
        circle.x = lerpDouble(circle.x, circle.draggedX, 0.18)!;
        circle.y = lerpDouble(circle.y, circle.draggedY, 0.18)!;
      } else if (draggedCircleIndex != null &&
          draggedCircleIndex != i &&
          leaderX != null &&
          leaderY != null) {
        // Outros círculos seguem suavemente o círculo arrastado
        circle.x = lerpDouble(circle.x, leaderX, 0.06)!;
        circle.y = lerpDouble(circle.y, leaderY, 0.06)!;
      } else if (draggedCircleIndex == null || draggedCircleIndex != i) {
        // Movimento normal
        circle.x =
            (circle.x +
                math.sin(animation * 2 * math.pi + circle.y * 10) * 0.008) %
            1.0;
        circle.y = (circle.y + circle.speed * 0.008) % 1.0;
      } else if (!circle.isBeingDragged) {
        // Volta suavemente para a posição original
        circle.x = lerpDouble(circle.x, circle.originalX, 0.06)!;
        circle.y = lerpDouble(circle.y, circle.originalY, 0.06)!;
      }

      // Variação dinâmica de tamanho e opacidade
      double t = animation * 2 * math.pi + circle.phase;
      double sizeVar =
          math.sin(t) * 0.22 + 1.08; // menos variação, mais suave, maior base
      double opacityVar = math.cos(t) * 0.18 + 1.0; // menos variação
      double dynamicSize = circle.baseSize * sizeVar;
      double dynamicOpacity = (circle.baseOpacity * opacityVar).clamp(
        0.10,
        0.32,
      );

      // Seleciona a cor baseada no modo
      final color =
          colorMode
              ? neonColorsColor[i % neonColorsColor.length]
              : neonColorsMinimal[i % neonColorsMinimal.length];

      final center = Offset(
        (circle.x + parallax * 0.08) * size.width,
        (circle.y + parallax * 0.08) * size.height,
      );
      final isDragged = (i == draggedCircleIndex);
      double pulse =
          isDragged
              ? (1.0 +
                  0.12 * math.sin(animation * 2 * math.pi * 2 + circle.phase))
              : 1.0;
      double mainRadius = dynamicSize * (isDragged ? 1.25 * pulse : 1.0);

      // Rotação do círculo
      double rotation = animation * 2 * math.pi * 0.12 + i;
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(rotation);
      canvas.translate(-center.dx, -center.dy);

      // Gradiente radial
      final gradPaint =
          Paint()
            ..shader = RadialGradient(
              colors: [
                color.withOpacity(isDragged ? 0.32 : 0.18),
                Colors.transparent,
              ],
              stops: [0.0, 1.0],
            ).createShader(Rect.fromCircle(center: center, radius: mainRadius));
      canvas.drawCircle(center, mainRadius, gradPaint);

      // Brilho interno
      final innerPaint =
          Paint()
            ..color = Colors.white.withOpacity(isDragged ? 0.12 : 0.07)
            ..maskFilter = MaskFilter.blur(
              BlurStyle.normal,
              isDragged ? 14 : 8,
            );
      canvas.drawCircle(center, mainRadius * 0.62, innerPaint);
      canvas.restore();
    }

    // Ripple
    if (showRipple && rippleCenter != null) {
      final ripplePaint =
          Paint()
            ..shader = RadialGradient(
              colors: [
                Colors.white.withOpacity(0.13 * (1 - rippleProgress)),
                Colors.transparent,
              ],
              stops: [0.0, 1.0],
            ).createShader(
              Rect.fromCircle(
                center: rippleCenter!,
                radius: 180.0 * rippleProgress + 40,
              ),
            );
      canvas.drawCircle(
        rippleCenter!,
        180.0 * rippleProgress + 40,
        ripplePaint,
      );
    }
  }

  @override
  bool shouldRepaint(WelcomeNeonPainter oldDelegate) => true;
}
