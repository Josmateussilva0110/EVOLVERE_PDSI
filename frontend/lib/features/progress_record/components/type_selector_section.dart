import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/type_selector.dart';

class TypeSelectorSection extends StatelessWidget {
  final int selectedType;
  final Function(int) onTypeSelected;
  final VoidCallback onInfoTap;

  const TypeSelectorSection({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
    required this.onInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = screenWidth > screenHeight;

    // Tamanhos de fontes adaptativos
    final titleFontSize = isLandscape ? screenWidth * 0.035 : screenWidth * 0.045;
    final descFontSize = isLandscape ? screenWidth * 0.03 : screenWidth * 0.035;
    final iconSize = isLandscape ? 26.0 : 30.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Tipo',
              style: GoogleFonts.inter(
                color: Colors.white70,
                fontSize: titleFontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: onInfoTap,
              child: Icon(Icons.info_outline, color: Colors.white38, size: iconSize * 0.7),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Usar Wrap em landscape para quebrar linha se necessário
        isLandscape
            ? Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.start,
                children: [
                  TypeSelector(
                    icon: Icons.settings,
                    iconColor: Colors.blueAccent,
                    label: 'Automático',
                    selected: selectedType == 0,
                    onTap: () => onTypeSelected(0),
                    iconSize: iconSize,
                    fontSize: descFontSize,
                  ),
                  TypeSelector(
                    icon: Icons.edit,
                    iconColor: Colors.orangeAccent,
                    label: 'Manual',
                    selected: selectedType == 1,
                    onTap: () => onTypeSelected(1),
                    iconSize: iconSize,
                    fontSize: descFontSize,
                  ),
                  TypeSelector(
                    icon: Icons.arrow_upward,
                    iconColor: Colors.purpleAccent,
                    label: 'Acumulativa',
                    selected: selectedType == 2,
                    onTap: () => onTypeSelected(2),
                    iconSize: iconSize,
                    fontSize: descFontSize,
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TypeSelector(
                    icon: Icons.settings,
                    iconColor: Colors.blueAccent,
                    label: 'Automático',
                    selected: selectedType == 0,
                    onTap: () => onTypeSelected(0),
                    iconSize: iconSize,
                    fontSize: descFontSize,
                  ),
                  TypeSelector(
                    icon: Icons.edit,
                    iconColor: Colors.orangeAccent,
                    label: 'Manual',
                    selected: selectedType == 1,
                    onTap: () => onTypeSelected(1),
                    iconSize: iconSize,
                    fontSize: descFontSize,
                  ),
                  TypeSelector(
                    icon: Icons.arrow_upward,
                    iconColor: Colors.purpleAccent,
                    label: 'Acumulativa',
                    selected: selectedType == 2,
                    onTap: () => onTypeSelected(2),
                    iconSize: iconSize,
                    fontSize: descFontSize,
                  ),
                ],
              ),

        const SizedBox(height: 12),
        Text(
          selectedType == 0
              ? 'O sistema registra automaticamente.'
              : selectedType == 1
                  ? 'Você marca quando cumprir.'
                  : 'Define uma meta de quantidade.',
          style: GoogleFonts.inter(
            color: Colors.white54,
            fontSize: descFontSize,
          ),
        ),
      ],
    );
  }
}
