import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../frequency_screen/themes/frequency_theme.dart';

class YearDaysPickerWidget extends StatefulWidget {
  final List<DateTime> selectedDates;
  final Function(List<DateTime>) onDatesSelected;

  const YearDaysPickerWidget({
    Key? key,
    required this.selectedDates,
    required this.onDatesSelected,
  }) : super(key: key);

  @override
  State<YearDaysPickerWidget> createState() => _YearDaysPickerWidgetState();
}

class _YearDaysPickerWidgetState extends State<YearDaysPickerWidget> {
  late List<DateTime> _selectedDates;

  @override
  void initState() {
    super.initState();
    _selectedDates = List.from(widget.selectedDates);
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
          _buildDateSelector(),
          if (_selectedDates.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildSelectedDatesList(),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(Icons.calendar_today, color: FrequencyTheme.accentColor, size: 24),
        const SizedBox(width: 12),
        Text(
          'Dias específicos do ano',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2D3A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Selecione pelo menos um dia',
              style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 14),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: FrequencyTheme.accentColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: _showDatePicker,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedDatesList() {
    return Column(
      children:
          _selectedDates.map((date) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                '${date.day}/${date.month}/${date.year}',
                style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () {
                  setState(() {
                    _selectedDates.remove(date);
                    widget.onDatesSelected(_selectedDates);
                  });
                },
              ),
            );
          }).toList(),
    );
  }

  Future<void> _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: FrequencyTheme.accentColor,
              onPrimary: Colors.white,
              surface: const Color(0xFF1C1F26),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF1C1F26),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && !_selectedDates.contains(picked)) {
      setState(() {
        _selectedDates.add(picked);
        widget.onDatesSelected(_selectedDates);
      });
    }
  }
}
