import 'package:flutter/material.dart';

class ColorSelector extends StatefulWidget {
  final List<Color> colors;
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  const ColorSelector({
    super.key,
    required this.colors,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  State<ColorSelector> createState() => _ColorSelectorState();
}

class _ColorSelectorState extends State<ColorSelector> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Cor tema",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1C),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: widget.selectedColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white24, width: 1),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Selecionar cor',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color:
                        _isExpanded
                            ? const Color(0xFF007AFF)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _isExpanded ? Icons.check : Icons.add,
                    color: _isExpanded ? Colors.white : Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1C),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12, width: 1),
            ),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children:
                  widget.colors.map((cor) {
                    bool selecionada = cor.value == widget.selectedColor.value;
                    return GestureDetector(
                      onTap: () {
                        widget.onColorSelected(cor);
                        setState(() {
                          _isExpanded = false;
                        });
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: cor,
                          shape: BoxShape.circle,
                          border:
                              selecionada
                                  ? Border.all(
                                    color: const Color(0xFF007AFF),
                                    width: 3,
                                  )
                                  : Border.all(
                                    color: const Color(0xFF333333),
                                    width: 1,
                                  ),
                        ),
                        child:
                            selecionada
                                ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 24,
                                )
                                : null,
                      ),
                    );
                  }).toList(),
            ),
          ),
        ],
      ],
    );
  }
}
