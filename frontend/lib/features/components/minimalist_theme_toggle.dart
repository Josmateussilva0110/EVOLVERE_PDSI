import 'package:flutter/material.dart';

class MinimalistThemeToggle extends StatefulWidget {
  final bool isColorfulMode;
  final Function(bool) onThemeChanged;
  final double? width;
  final double? height;

  const MinimalistThemeToggle({
    Key? key,
    required this.isColorfulMode,
    required this.onThemeChanged,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<MinimalistThemeToggle> createState() => _MinimalistThemeToggleState();
}

class _MinimalistThemeToggleState extends State<MinimalistThemeToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
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
  void didUpdateWidget(MinimalistThemeToggle oldWidget) {
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
        width: widget.width ?? 140,
        height: widget.height ?? 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.shade50,
          border: Border.all(color: Colors.grey.shade200, width: 1.5),
        ),
        child: Stack(
          children: [
            // Indicador deslizante
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Positioned(
                  left: _animation.value * (widget.width ?? 140 - 36),
                  top: 2,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color:
                          widget.isColorfulMode
                              ? Colors.blue.shade500
                              : Colors.grey.shade400,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.isColorfulMode
                          ? Icons.palette
                          : Icons.format_paint,
                      color: Colors.white,
                      size: 16,
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
                      duration: const Duration(milliseconds: 300),
                      style: TextStyle(
                        color:
                            widget.isColorfulMode
                                ? Colors.grey.shade500
                                : Colors.grey.shade800,
                        fontSize: 11,
                        fontWeight:
                            widget.isColorfulMode
                                ? FontWeight.w400
                                : FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                      child: const Text('MINIMALISTA'),
                    ),
                  ),
                ),
                const SizedBox(width: 36), // Espaço para o indicador
                Expanded(
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: TextStyle(
                        color:
                            widget.isColorfulMode
                                ? Colors.grey.shade800
                                : Colors.grey.shade500,
                        fontSize: 11,
                        fontWeight:
                            widget.isColorfulMode
                                ? FontWeight.w600
                                : FontWeight.w400,
                        letterSpacing: 0.5,
                      ),
                      child: const Text('COLORIDO'),
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

// Versão alternativa ainda mais minimalista
class UltraMinimalistThemeToggle extends StatefulWidget {
  final bool isColorfulMode;
  final Function(bool) onThemeChanged;
  final double? size;

  const UltraMinimalistThemeToggle({
    Key? key,
    required this.isColorfulMode,
    required this.onThemeChanged,
    this.size,
  }) : super(key: key);

  @override
  State<UltraMinimalistThemeToggle> createState() =>
      _UltraMinimalistThemeToggleState();
}

class _UltraMinimalistThemeToggleState extends State<UltraMinimalistThemeToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutBack,
      ),
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
  void didUpdateWidget(UltraMinimalistThemeToggle oldWidget) {
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
    final size = widget.size ?? 60.0;

    return GestureDetector(
      onTap: _toggleTheme,
      child: Container(
        width: size,
        height: size * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size * 0.2),
          color: Colors.grey.shade100,
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Stack(
          children: [
            // Indicador deslizante
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Positioned(
                  left: _animation.value * (size - size * 0.4),
                  top: 2,
                  child: Container(
                    width: size * 0.4 - 4,
                    height: size * 0.4 - 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular((size * 0.4 - 4) / 2),
                      color:
                          widget.isColorfulMode
                              ? Colors.blue.shade600
                              : Colors.grey.shade500,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Widget de exemplo para demonstrar o uso
class ThemeToggleDemo extends StatefulWidget {
  const ThemeToggleDemo({Key? key}) : super(key: key);

  @override
  State<ThemeToggleDemo> createState() => _ThemeToggleDemoState();
}

class _ThemeToggleDemoState extends State<ThemeToggleDemo> {
  bool _isColorfulMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          _isColorfulMode ? Colors.blue.shade50 : Colors.grey.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Seletores de Tema',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color:
                      _isColorfulMode
                          ? Colors.blue.shade700
                          : Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Escolha entre modo minimalista e colorido',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 60),

              // Versão moderna
              const Text(
                'Versão Moderna',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Center(
                child: MinimalistThemeToggle(
                  isColorfulMode: _isColorfulMode,
                  onThemeChanged: (value) {
                    setState(() {
                      _isColorfulMode = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 40),

              // Versão ultra minimalista
              const Text(
                'Versão Ultra Minimalista',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Center(
                child: UltraMinimalistThemeToggle(
                  isColorfulMode: _isColorfulMode,
                  onThemeChanged: (value) {
                    setState(() {
                      _isColorfulMode = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 40),

              // Status atual
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isColorfulMode ? Icons.palette : Icons.format_paint,
                      color:
                          _isColorfulMode
                              ? Colors.blue.shade600
                              : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Modo atual: ${_isColorfulMode ? "Colorido" : "Minimalista"}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color:
                            _isColorfulMode
                                ? Colors.blue.shade700
                                : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
