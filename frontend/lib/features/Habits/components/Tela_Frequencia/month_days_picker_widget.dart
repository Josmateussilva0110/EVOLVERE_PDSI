import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../frequency_screen/themes/frequency_theme.dart';

class MonthDaysPickerWidget extends StatefulWidget {
  final List<int> selectedDays;
  final Function(List<int>) onDaysSelected;

  const MonthDaysPickerWidget({
    Key? key,
    required this.selectedDays,
    required this.onDaysSelected,
  }) : super(key: key);

  @override
  State<MonthDaysPickerWidget> createState() => _MonthDaysPickerWidgetState();
}

class _MonthDaysPickerWidgetState extends State<MonthDaysPickerWidget> {
  late List<int> _selectedDays;

  @override
  void initState() {
    super.initState();
    _selectedDays = List.from(widget.selectedDays);
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
          _buildCalendarGrid(),
          const SizedBox(height: 16),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(Icons.calendar_month, color: FrequencyTheme.accentColor, size: 24),
        const SizedBox(width: 12),
        Text(
          'Dias específicos do mês',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: 31, // Apenas 31 dias
      itemBuilder: (context, index) {
        return _buildDayButton((index + 1).toString());
      },
    );
  }

  Widget _buildDayButton(String label) {
    final day = label == 'Último' ? 32 : int.tryParse(label) ?? 0;
    final isSelected = _selectedDays.contains(day);

    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedDays.remove(day);
          } else {
            _selectedDays.add(day);
          }
          widget.onDaysSelected(_selectedDays);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color:
              isSelected ? FrequencyTheme.accentColor : const Color(0xFF2B2D3A),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Text(
      'Selecione pelo menos um dia',
      style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 14),
    );
  }
}
