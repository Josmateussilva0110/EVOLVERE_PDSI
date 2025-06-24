import 'package:flutter/material.dart';

class ModernThemeToggle extends StatefulWidget {
  final bool isColorfulMode;
  final Function(bool) onThemeChanged;
  final double? width;
  final double? height;

  const ModernThemeToggle({
    Key? key,
    required this.isColorfulMode,
    required this.onThemeChanged,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<ModernThemeToggle> createState() => _ModernThemeToggleState();
}

class _ModernThemeToggleState extends State<ModernThemeToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    if (widget.isColorfulMode) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ModernThemeToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isColorfulMode != widget.isColorfulMode) {
      if (widget.isColorfulMode) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  void _toggleTheme() {
    widget.onThemeChanged(!widget.isColorfulMode);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleTheme,
      child: Container(
        width: widget.width ?? 120,
        height: widget.height ?? 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [Colors.grey.shade100, Colors.grey.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Indicador deslizante
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Positioned(
                  left: _animation.value * (widget.width ?? 120 - 44),
                  top: 2,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      gradient: LinearGradient(
                        colors:
                            widget.isColorfulMode
                                ? [Colors.blue.shade400, Colors.purple.shade400]
                                : [Colors.grey.shade300, Colors.grey.shade400],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.isColorfulMode
                          ? Icons.palette
                          : Icons.format_paint,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                );
              },
            ),
            // Textos dos modos
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        color:
                            widget.isColorfulMode
                                ? Colors.grey.shade600
                                : Colors.grey.shade800,
                        fontSize: 12,
                        fontWeight:
                            widget.isColorfulMode
                                ? FontWeight.w400
                                : FontWeight.w600,
                      ),
                      child: const Text('Minimalista'),
                    ),
                  ),
                ),
                const SizedBox(width: 44), // Espaço para o indicador
                Expanded(
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        color:
                            widget.isColorfulMode
                                ? Colors.grey.shade800
                                : Colors.grey.shade600,
                        fontSize: 12,
                        fontWeight:
                            widget.isColorfulMode
                                ? FontWeight.w600
                                : FontWeight.w400,
                      ),
                      child: const Text('Colorido'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Widget de exemplo para demonstrar o uso
class ThemeToggleExample extends StatefulWidget {
  const ThemeToggleExample({Key? key}) : super(key: key);

  @override
  State<ThemeToggleExample> createState() => _ThemeToggleExampleState();
}

class _ThemeToggleExampleState extends State<ThemeToggleExample> {
  bool _isColorfulMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          _isColorfulMode ? Colors.blue.shade50 : Colors.grey.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Modo ${_isColorfulMode ? "Colorido" : "Minimalista"}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color:
                    _isColorfulMode
                        ? Colors.blue.shade700
                        : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 40),
            ModernThemeToggle(
              isColorfulMode: _isColorfulMode,
              onThemeChanged: (value) {
                setState(() {
                  _isColorfulMode = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Toque para alternar',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
