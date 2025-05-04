import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../components/Tela_Frequencia/frequency_option.dart';
import '../../components/Tela_Frequencia/navigation_dots.dart';
import '../../themes/Tela_Frequencia/frequency_theme.dart';
import '../../widgets/Tela_Frequencia/frequency_pickers.dart';

class TelaFrequencia extends StatefulWidget {
  @override
  _TelaFrequenciaState createState() => _TelaFrequenciaState();
}

class _TelaFrequenciaState extends State<TelaFrequencia> {
  String selectedFrequency = 'todos_os_dias';
  List<String> selectedDaysOfWeek = [];
  List<int> selectedDaysOfMonth = [];
  List<DateTime> selectedYearDays = [];
  int repeatTimes = 1;
  String repeatPeriod = 'SEMANA';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FrequencyTheme.backgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildFrequencyOptions(),
                ],
              ),
            ),
          ),
          _buildBottomNavigation(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: FrequencyTheme.textColor),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Definir Frequência e Prazo',
        style: GoogleFonts.inter(
          color: FrequencyTheme.textColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      'Com que frequência você deseja\nfazer isso?',
      textAlign: TextAlign.left,
      style: GoogleFonts.inter(
        color: FrequencyTheme.textColor,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildFrequencyOptions() {
    return Column(
      children: [
        FrequencyOption(
          value: 'todos_os_dias',
          label: 'Todos os dias',
          selectedFrequency: selectedFrequency,
          onSelect: _handleFrequencySelection,
        ),
        FrequencyOption(
          value: 'alguns_dias_semana',
          label: 'Alguns dias da semana',
          selectedFrequency: selectedFrequency,
          onSelect: _handleFrequencySelection,
        ),
        FrequencyOption(
          value: 'dias_especificos_mes',
          label: 'Dias específicos do mês',
          selectedFrequency: selectedFrequency,
          onSelect: _handleFrequencySelection,
        ),
        FrequencyOption(
          value: 'dias_especificos_ano',
          label: 'Dias específicos do ano',
          selectedFrequency: selectedFrequency,
          onSelect: _handleFrequencySelection,
        ),
        FrequencyOption(
          value: 'algumas_vezes_periodo',
          label: 'Algumas vezes por período',
          selectedFrequency: selectedFrequency,
          onSelect: _handleFrequencySelection,
        ),
        FrequencyOption(
          value: 'repetir',
          label: 'Repetir',
          selectedFrequency: selectedFrequency,
          onSelect: _handleFrequencySelection,
        ),
      ],
    );
  }

  void _handleFrequencySelection(String value) {
    setState(() {
      selectedFrequency = value;
    });

    switch (value) {
      case 'alguns_dias_semana':
        FrequencyPickers.showWeekDaysPicker(context, selectedDaysOfWeek, (
          days,
        ) {
          setState(() => selectedDaysOfWeek = days);
        });
        break;
      case 'dias_especificos_mes':
        FrequencyPickers.showMonthDaysPicker(context, selectedDaysOfMonth, (
          days,
        ) {
          setState(() => selectedDaysOfMonth = days);
        });
        break;
      case 'dias_especificos_ano':
        FrequencyPickers.showYearDaysPicker(context, selectedYearDays, (dates) {
          setState(() {
            selectedYearDays = dates;
          });
        });
        break;
      case 'algumas_vezes_periodo':
        FrequencyPickers.showPeriodPicker(context, repeatTimes, repeatPeriod, (
          times,
          period,
        ) {
          setState(() {
            repeatTimes = times;
            repeatPeriod = period;
          });
        });
        break;
      case 'repetir':
        FrequencyPickers.showRepeatPicker(context, repeatTimes, (times) {
          setState(() => repeatTimes = times);
        });
        break;
    }
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: FrequencyTheme.backgroundColor,
        border: Border(top: BorderSide(color: Colors.grey[900]!, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed:
                () => Navigator.pushReplacementNamed(context, '/habitos'),
            child: Text(
              'Anterior',
              style: GoogleFonts.inter(
                color: FrequencyTheme.textColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          NavigationDots(currentIndex: 1, totalDots: 3),
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/prazo'),
            child: Text(
              'Próxima',
              style: GoogleFonts.inter(
                color: FrequencyTheme.accentColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
