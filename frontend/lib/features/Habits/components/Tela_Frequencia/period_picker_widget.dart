import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../frequency_screen/themes/frequency_theme.dart';

class PeriodPickerWidget extends StatefulWidget {
  final int times;
  final String period;
  final Function(int, String) onPeriodSelected;

  const PeriodPickerWidget({
    Key? key,
    required this.times,
    required this.period,
    required this.onPeriodSelected,
  }) : super(key: key);

  @override
  State<PeriodPickerWidget> createState() => _PeriodPickerWidgetState();
}

class _PeriodPickerWidgetState extends State<PeriodPickerWidget> {
  late int _times;
  late String _period;
  final List<String> _periods = ['DIA', 'SEMANA', 'MÊS', 'ANO'];

  @override
  void initState() {
    super.initState();
    _times = widget.times;
    _period = widget.period;
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
          _buildPeriodSelector(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(Icons.update, color: FrequencyTheme.accentColor, size: 24),
        const SizedBox(width: 12),
        Text(
          'Algumas vezes por período',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2D3A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildNumberInput(),
          const SizedBox(width: 8),
          Text(
            'vezes por',
            style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(width: 8),
          _buildPeriodDropdown(),
        ],
      ),
    );
  }

  Widget _buildNumberInput() {
    return Container(
      width: 48,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF1C1F26),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: FrequencyTheme.accentColor),
      ),
      child: Center(
        child: TextField(
          controller: TextEditingController(text: _times.toString()),
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
          ),
          onChanged: (value) {
            final newTimes = int.tryParse(value) ?? 1;
            setState(() {
              _times = newTimes;
              widget.onPeriodSelected(_times, _period);
            });
          },
        ),
      ),
    );
  }

  Widget _buildPeriodDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1F26),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: FrequencyTheme.accentColor),
      ),
      child: DropdownButton<String>(
        value: _period,
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        underline: Container(),
        dropdownColor: const Color(0xFF1C1F26),
        style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
        items:
            _periods.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              _period = newValue;
              widget.onPeriodSelected(_times, _period);
            });
          }
        },
      ),
    );
  }
}
