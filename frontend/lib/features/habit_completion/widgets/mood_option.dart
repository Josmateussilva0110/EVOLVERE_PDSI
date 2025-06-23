import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MoodOption extends StatefulWidget {
  final String label;
  final int index;
  final int selectedMood;
  final void Function(int) onTap;

  const MoodOption({
    super.key,
    required this.label,
    required this.index,
    required this.selectedMood,
    required this.onTap,
  });

  @override
  State<MoodOption> createState() => _MoodOptionState();
}

class _MoodOptionState extends State<MoodOption>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  static const emojis = [
    '😐',
    '😁',
    '😩',
  ]; // 0: Neutro, 1: Motivado, 2: Desanimado

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _scaleAnim = TweenSequence([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.25,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.25,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.bounceOut)),
        weight: 50,
      ),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant MoodOption oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedMood == widget.index &&
        oldWidget.selectedMood != widget.index) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isSelected = widget.selectedMood == widget.index;
    return GestureDetector(
      onTap: () => widget.onTap(widget.index),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _scaleAnim,
            builder: (context, child) {
              return Transform.scale(
                scale: isSelected ? _scaleAnim.value : 1.0,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.transparent,
                      width: isSelected ? 3 : 0,
                    ),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.15),
                          blurRadius: 12,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    emojis[widget.index],
                    style: const TextStyle(fontSize: 38),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          Text(
            widget.label,
            style: GoogleFonts.inter(
              color: isSelected ? Colors.blue : Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
