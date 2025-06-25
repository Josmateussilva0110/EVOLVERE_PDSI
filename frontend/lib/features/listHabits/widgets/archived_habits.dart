import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/list_habits_service.dart';
import '../models/HabitModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArchivedHabitsModal extends StatefulWidget {
  final VoidCallback? onHabitRestored;
  const ArchivedHabitsModal({super.key, this.onHabitRestored});

  @override
  State<ArchivedHabitsModal> createState() => _ArchivedHabitsModalState();
}

class _ArchivedHabitsModalState extends State<ArchivedHabitsModal> {
  bool isLoading = true;
  List<Habit> _archivedHabits = [];
  int? userId;

  Future<int?> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('loggedInUserId');
  }

  Future<void> _loadArchived() async {
    if (userId == null) return;
    final allArchivedHabits = await HabitService.fetchHabitsArchived(userId!);
    if (mounted) {
      setState(() {
        _archivedHabits = allArchivedHabits;
        isLoading = false;
      });
    }
  }

  Future<void> _initData() async {
    final id = await _loadUserId();
    if (id != null) {
      setState(() {
        userId = id;
      });
      _loadArchived();
    }
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0A0A0A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header com indicador de arraste
          Container(
            margin: EdgeInsets.only(top: isSmallScreen ? 8 : 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header principal
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange.withOpacity(0.8),
                        Colors.orange.withOpacity(0.6),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.archive_outlined,
                    color: Colors.white,
                    size: isSmallScreen ? 20 : 24,
                  ),
                ),
                SizedBox(width: isSmallScreen ? 12 : 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hábitos Arquivados',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 18 : 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${_archivedHabits.length} hábito${_archivedHabits.length != 1 ? 's' : ''} arquivado${_archivedHabits.length != 1 ? 's' : ''}',
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: isSmallScreen ? 12 : 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: isSmallScreen ? 20 : 24,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),

          // Conteúdo
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              child:
                  isLoading
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: isSmallScreen ? 32 : 40,
                              height: isSmallScreen ? 32 : 40,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.orange.withOpacity(0.8),
                                ),
                              ),
                            ),
                            SizedBox(height: isSmallScreen ? 16 : 20),
                            Text(
                              'Carregando hábitos arquivados...',
                              style: GoogleFonts.inter(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: isSmallScreen ? 14 : 16,
                              ),
                            ),
                          ],
                        ),
                      )
                      : _archivedHabits.isEmpty
                      ? _buildEmptyState(isSmallScreen)
                      : _buildArchivedHabitsList(isSmallScreen),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isSmallScreen) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 20 : 32),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(isSmallScreen ? 40 : 50),
            ),
            child: Icon(
              Icons.archive_outlined,
              size: isSmallScreen ? 48 : 64,
              color: Colors.orange.withOpacity(0.6),
            ),
          ),
          SizedBox(height: isSmallScreen ? 16 : 24),
          Text(
            'Nenhum hábito arquivado',
            style: GoogleFonts.inter(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          Text(
            'Os hábitos arquivados aparecerão aqui',
            style: GoogleFonts.inter(
              fontSize: isSmallScreen ? 12 : 14,
              color: Colors.white.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildArchivedHabitsList(bool isSmallScreen) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 16 : 20),
      itemCount: _archivedHabits.length,
      itemBuilder: (context, index) {
        final habit = _archivedHabits[index];
        return Container(
          margin: EdgeInsets.only(bottom: isSmallScreen ? 12 : 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _showHabitDetails(habit, isSmallScreen),
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                habit.name,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: isSmallScreen ? 16 : 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (habit.description.isNotEmpty) ...[
                                SizedBox(height: isSmallScreen ? 4 : 6),
                                Text(
                                  habit.description,
                                  style: GoogleFonts.inter(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: isSmallScreen ? 12 : 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.green.withOpacity(0.8),
                                Colors.green.withOpacity(0.6),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.restore,
                            color: Colors.white,
                            size: isSmallScreen ? 18 : 20,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    Row(
                      children: [
                        if (habit.categoryName != null) ...[
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 8 : 10,
                              vertical: isSmallScreen ? 4 : 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              habit.categoryName!,
                              style: GoogleFonts.inter(
                                color: Colors.blue,
                                fontSize: isSmallScreen ? 10 : 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(width: isSmallScreen ? 8 : 12),
                        ],
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 8 : 10,
                            vertical: isSmallScreen ? 4 : 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getPriorityColor(
                              habit.priority,
                            ).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getPriorityIcon(habit.priority),
                                color: _getPriorityColor(habit.priority),
                                size: isSmallScreen ? 12 : 14,
                              ),
                              SizedBox(width: isSmallScreen ? 4 : 6),
                              Text(
                                _getPriorityText(habit.priority),
                                style: GoogleFonts.inter(
                                  color: _getPriorityColor(habit.priority),
                                  fontSize: isSmallScreen ? 10 : 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showHabitDetails(Habit habit, bool isSmallScreen) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => _HabitDetailsModal(
            habit: habit,
            isSmallScreen: isSmallScreen,
            onHabitRestored: widget.onHabitRestored,
          ),
    );
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icons.priority_high;
      case 2:
        return Icons.remove;
      case 3:
        return Icons.keyboard_arrow_down;
      default:
        return Icons.help_outline;
    }
  }

  String _getPriorityText(int priority) {
    switch (priority) {
      case 1:
        return 'Alta';
      case 2:
        return 'Normal';
      case 3:
        return 'Baixa';
      default:
        return 'Não definida';
    }
  }
}

class _HabitDetailsModal extends StatelessWidget {
  final Habit habit;
  final bool isSmallScreen;
  final VoidCallback? onHabitRestored;

  const _HabitDetailsModal({
    required this.habit,
    required this.isSmallScreen,
    this.onHabitRestored,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0A0A0A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange.withOpacity(0.8),
                        Colors.orange.withOpacity(0.6),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.white,
                    size: isSmallScreen ? 20 : 24,
                  ),
                ),
                SizedBox(width: isSmallScreen ? 12 : 16),
                Expanded(
                  child: Text(
                    'Detalhes do Hábito',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 18 : 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: isSmallScreen ? 20 : 24,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),

          // Conteúdo
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nome e descrição
                  Container(
                    padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.name,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: isSmallScreen ? 18 : 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (habit.description.isNotEmpty) ...[
                          SizedBox(height: isSmallScreen ? 8 : 12),
                          Text(
                            habit.description,
                            style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: isSmallScreen ? 14 : 16,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 16 : 20),

                  // Informações detalhadas
                  _buildDetailSection('Informações Gerais', [
                    _buildDetailItem(
                      'Categoria',
                      habit.categoryName ?? 'Não definida',
                    ),
                    _buildDetailItem(
                      'Prioridade',
                      _getPriorityText(habit.priority),
                    ),
                    _buildDetailItem(
                      'Frequência',
                      _getFrequencyText(habit.frequency),
                    ),
                  ], isSmallScreen),

                  SizedBox(height: isSmallScreen ? 16 : 20),

                  // Datas
                  _buildDetailSection('Período', [
                    if (habit.startDate != null)
                      _buildDetailItem(
                        'Data de início',
                        _formatDate(habit.startDate!),
                      ),
                    if (habit.endDate != null)
                      _buildDetailItem(
                        'Data de fim',
                        _formatDate(habit.endDate!),
                      ),
                  ], isSmallScreen),

                  SizedBox(height: isSmallScreen ? 24 : 32),

                  // Botão de restaurar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final success = await HabitService.activeHabit(
                          habit.id,
                        );
                        if (success) {
                          Navigator.pop(context); // Fecha o modal de detalhes
                          Navigator.pop(context); // Fecha o modal de arquivados
                          if (onHabitRestored != null) onHabitRestored!();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Hábito "${habit.name}" restaurado com sucesso!',
                              ),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Erro ao restaurar hábito.'),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      icon: Icon(Icons.restore, size: isSmallScreen ? 18 : 20),
                      label: Text(
                        'Restaurar Hábito',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: isSmallScreen ? 12 : 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(
    String title,
    List<Widget> children,
    bool isSmallScreen,
  ) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: isSmallScreen ? 8 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: isSmallScreen ? 80 : 100,
            child: Text(
              '$label:',
              style: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.6),
                fontSize: isSmallScreen ? 12 : 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: isSmallScreen ? 12 : 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getPriorityText(int priority) {
    switch (priority) {
      case 1:
        return 'Alta';
      case 2:
        return 'Normal';
      case 3:
        return 'Baixa';
      default:
        return 'Não definida';
    }
  }

  String _getFrequencyText(Frequency frequency) {
    switch (frequency.option) {
      case 'daily':
        return 'Diário';
      case 'weekly':
        return 'Semanal';
      case 'monthly':
        return 'Mensal';
      default:
        return 'Personalizado';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
