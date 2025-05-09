import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../frequency_screen/themes/frequency_theme.dart';

class RepeatPickerWidget extends StatefulWidget {
  final int days;
  final Function(int) onDaysSelected;

  const RepeatPickerWidget({
    Key? key,
    required this.days,
    required this.onDaysSelected,
  }) : super(key: key);

  @override
  State<RepeatPickerWidget> createState() => _RepeatPickerWidgetState();
}

class _RepeatPickerWidgetState extends State<RepeatPickerWidget> {
  late int _days;

  @override
  void initState() {
    super.initState();
    _days = widget.days;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildRepeatSelector(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(Icons.repeat, color: FrequencyTheme.accentColor, size: 24),
        const SizedBox(width: 12),
        Text(
          'Repetir',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildRepeatSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2D3A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'A cada',
            style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(width: 12),
          Container(
            width: 48,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF1C1F26),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: FrequencyTheme.accentColor),
            ),
            child: Center(
              child: TextField(
                controller: TextEditingController(text: _days.toString()),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  final newDays = int.tryParse(value) ?? 2;
                  setState(() {
                    _days = newDays;
                    widget.onDaysSelected(_days);
                  });
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'dias',
            style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
