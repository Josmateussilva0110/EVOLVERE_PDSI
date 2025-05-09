import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TelaPrazo extends StatefulWidget {
  @override
  _TelaPrazoState createState() => _TelaPrazoState();
}

class _TelaPrazoState extends State<TelaPrazo> {
  bool dataAlvoEnabled = false;
  String prioridade = 'Normal';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121217),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Definir Prazo',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quando você quer fazer isso?',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildOptionButton(
                    icon: Icons.calendar_today,
                    title: 'Data de início',
                    subtitle: 'Selecione a data de início da tarefa',
                    onTap: () {
                      // Implementar seleção de data
                    },
                  ),
                  _buildOptionButton(
                    icon: Icons.calendar_month,
                    title: 'Data alvo',
                    subtitle: 'Ative ou desative a data alvo',
                    hasSwitch: true,
                    switchValue: dataAlvoEnabled,
                    onSwitchChanged: (value) {
                      setState(() {
                        dataAlvoEnabled = value;
                      });
                    },
                  ),
                  _buildOptionButton(
                    icon: Icons.notifications_outlined,
                    title: 'Horário e lembretes',
                    subtitle: 'Defina horários e lembretes para a tarefa',
                    onTap: () {
                      // Implementar configuração de lembretes
                    },
                  ),
                  _buildOptionButton(
                    icon: Icons.sort,
                    title: 'Prioridade',
                    subtitle: 'Selecione o nível de prioridade',
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1F26),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        prioridade,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    onTap: () {
                      // Implementar seleção de prioridade
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color(0xFF121217),
              border: Border(
                top: BorderSide(color: Colors.grey[900]!, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/cadastrar_frequencia');
                  },
                  child: Text(
                    'Anterior',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Row(
                  children: [
                    _buildDot(false),
                    _buildDot(false),
                    _buildDot(true),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    // Aqui você pode adicionar a lógica para criar o hábito
                    // Por exemplo, salvar os dados e voltar para a tela inicial
                    _criarHabito();
                  },
                  child: Text(
                    'Criar Hábito',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF2B6BED),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    bool hasSwitch = false,
    bool? switchValue,
    Function(bool)? onSwitchChanged,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1F26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3B4254), width: 1),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF2B2D3A),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 12),
        ),
        trailing:
            hasSwitch
                ? Switch(
                  value: switchValue ?? false,
                  onChanged: onSwitchChanged,
                  activeColor: const Color(0xFF2B6BED),
                )
                : trailing,
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? const Color(0xFF2B6BED) : Colors.grey[600],
      ),
    );
  }

  void _criarHabito() {
    // Adicione aqui a lógica para criar o hábito
    // Por exemplo:
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Hábito criado com sucesso!', style: GoogleFonts.inter()),
        backgroundColor: const Color(0xFF2B6BED),
      ),
    );

    // Voltar para a tela inicial ou outra tela desejada
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }
}
