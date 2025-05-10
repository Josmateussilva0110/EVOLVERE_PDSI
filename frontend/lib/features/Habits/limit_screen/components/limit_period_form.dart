// lib/components/limit_period_form.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/option_button.dart';

class LimitPeriodForm extends StatelessWidget {
  final bool dataAlvoEnabled;
  final Function(bool) onDataAlvoChanged;
  final String prioridade;
  final VoidCallback onSelecionarDataInicio;
  final VoidCallback onSelecionarLembretes;
  final VoidCallback onSelecionarPrioridade;

  const LimitPeriodForm({
    super.key,
    required this.dataAlvoEnabled,
    required this.onDataAlvoChanged,
    required this.prioridade,
    required this.onSelecionarDataInicio,
    required this.onSelecionarLembretes,
    required this.onSelecionarPrioridade,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OptionButton(
          icon: Icons.calendar_today,
          title: 'Data de início',
          subtitle: 'Selecione a data de início da tarefa',
          onTap: onSelecionarDataInicio,
        ),
        OptionButton(
          icon: Icons.calendar_month,
          title: 'Data alvo',
          subtitle: 'Ative ou desative a data alvo',
          hasSwitch: true,
          switchValue: dataAlvoEnabled,
          onSwitchChanged: onDataAlvoChanged,
        ),
        OptionButton(
          icon: Icons.notifications_outlined,
          title: 'Horário e lembretes',
          subtitle: 'Defina horários e lembretes para a tarefa',
          onTap: onSelecionarLembretes,
        ),
        OptionButton(
          icon: Icons.sort,
          title: 'Prioridade',
          subtitle: 'Selecione o nível de prioridade',
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1F26),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              prioridade,
              style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
            ),
          ),
          onTap: onSelecionarPrioridade,
        ),
      ],
    );
  }
}
