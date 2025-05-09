import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FrequencyOption extends StatelessWidget {
  final String value;
  final String label;
  final String selectedFrequency;
  final Function(String) onSelect;

  const FrequencyOption({
    required this.value,
    required this.label,
    required this.selectedFrequency,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelect(value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1F26),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF3B4254), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selectedFrequency == value
                    ? const Color(0xFF2B6BED)
                    : Colors.transparent,
                border: Border.all(
                  color: selectedFrequency == value
                      ? const Color(0xFF2B6BED)
                      : const Color(0xFF3B4254),
                  width: 2,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}