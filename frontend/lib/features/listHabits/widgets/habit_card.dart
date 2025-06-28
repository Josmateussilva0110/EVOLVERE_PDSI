import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/HabitModel.dart';
import '../services/list_habits_service.dart';
import '../services/list_categories_service.dart';
import '../../progress_record/screens/progress_record_screen.dart';
import '../../habit_completion/screens/finish_habit_screen.dart';
import '../../Habits/model/HabitData.dart';
import 'confirm_action_dialog.dart';
import '../models/CategoryModel.dart';

class HabitCardWidget extends StatelessWidget {
  final Habit habit;
  final List<Category> categories;
  final VoidCallback? onHabitArchived;
  final VoidCallback? onHabitDeleted;
  final VoidCallback? onHabitUpdated;

  const HabitCardWidget({
    Key? key,
    required this.habit,
    required this.categories,
    this.onHabitArchived,
    this.onHabitDeleted,
    this.onHabitUpdated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;
    final isGrid = screenWidth > screenHeight || screenWidth > 700;

    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 8 : 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            _showHabitDetails(context);
          },
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cabeçalho do card
                  Row(
                    children: [
                      if (categories.any(
                        (cat) =>
                            cat.name == habit.categoryName &&
                            cat.icon.isNotEmpty,
                      ))
                        Container(
                          width: isSmallScreen ? 36 : 44,
                          height: isSmallScreen ? 36 : 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _buildCategoryImage(),
                        ),
                      if (categories.any(
                        (cat) =>
                            cat.name == habit.categoryName &&
                            cat.icon.isNotEmpty,
                      ))
                        SizedBox(width: isSmallScreen ? 12 : 16),

                      // Informações principais
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              habit.name,
                              style: GoogleFonts.inter(
                                fontSize: isSmallScreen ? 16 : 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: isSmallScreen ? 4 : 6),
                            Text(
                              habit.categoryName ?? 'Sem categoria',
                              style: GoogleFonts.inter(
                                fontSize: isSmallScreen ? 12 : 14,
                                color: Colors.white60,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Menu de opções
                      PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.white60,
                          size: isSmallScreen ? 20 : 24,
                        ),
                        color: const Color(0xFF1A1A1A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        onSelected: (value) {
                          switch (value) {
                            case 'edit':
                              _editHabit(context);
                              break;
                            case 'archive':
                              _archiveHabit(context);
                              break;
                            case 'delete':
                              _deleteHabit(context);
                              break;
                            case 'view_record':
                              _viewRecord(context);
                              break;
                            case 'complete':
                              _completeHabit(context);
                              break;
                          }
                        },
                        itemBuilder:
                            (context) => [
                              PopupMenuItem(
                                value: 'view_record',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.history,
                                      color: Colors.blue,
                                      size: isSmallScreen ? 18 : 20,
                                    ),
                                    SizedBox(width: isSmallScreen ? 8 : 12),
                                    Text(
                                      'Ver Registro',
                                      style: GoogleFonts.inter(
                                        color: Colors.blue,
                                        fontSize: isSmallScreen ? 14 : 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'complete',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline,
                                      color: Colors.green,
                                      size: isSmallScreen ? 18 : 20,
                                    ),
                                    SizedBox(width: isSmallScreen ? 8 : 12),
                                    Text(
                                      'Concluir',
                                      style: GoogleFonts.inter(
                                        color: Colors.green,
                                        fontSize: isSmallScreen ? 14 : 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: isSmallScreen ? 18 : 20,
                                    ),
                                    SizedBox(width: isSmallScreen ? 8 : 12),
                                    Text(
                                      'Editar',
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: isSmallScreen ? 14 : 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'archive',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.archive,
                                      color: Colors.amber,
                                      size: isSmallScreen ? 18 : 20,
                                    ),
                                    SizedBox(width: isSmallScreen ? 8 : 12),
                                    Text(
                                      'Arquivar',
                                      style: GoogleFonts.inter(
                                        color: Colors.amber,
                                        fontSize: isSmallScreen ? 14 : 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: isSmallScreen ? 18 : 20,
                                    ),
                                    SizedBox(width: isSmallScreen ? 8 : 12),
                                    Text(
                                      'Excluir',
                                      style: GoogleFonts.inter(
                                        color: Colors.red,
                                        fontSize: isSmallScreen ? 14 : 16,
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

                  SizedBox(height: isSmallScreen ? 12 : 16),

                  // Descrição
                  if (habit.description.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(bottom: isSmallScreen ? 8 : 12),
                      child: Text(
                        habit.description,
                        style: GoogleFonts.inter(
                          fontSize: isSmallScreen ? 13 : 14,
                          color: Colors.white60,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                  // Informações de frequência, prioridade e status
                  isGrid || !isSmallScreen
                      ? Wrap(
                        spacing: isSmallScreen ? 8 : 10,
                        runSpacing: 6,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          // Frequência
                          _buildFrequencyChip(habit),
                          // Prioridade
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 8 : 10,
                              vertical: isSmallScreen ? 4 : 5,
                            ),
                            decoration: BoxDecoration(
                              color: _getPriorityColor(
                                habit.priority,
                              ).withOpacity(0.1),
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
                                    fontSize: isSmallScreen ? 11 : 12,
                                    color: _getPriorityColor(habit.priority),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Frequência
                          _buildFrequencyChip(habit),
                          // Prioridade
                          Container(
                            margin: EdgeInsets.only(bottom: 4),
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 8 : 10,
                              vertical: isSmallScreen ? 4 : 5,
                            ),
                            decoration: BoxDecoration(
                              color: _getPriorityColor(
                                habit.priority,
                              ).withOpacity(0.1),
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
                                    fontSize: isSmallScreen ? 11 : 12,
                                    color: _getPriorityColor(habit.priority),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                  // Data de início (se disponível)
                  if (habit.startDate != null)
                    Padding(
                      padding: EdgeInsets.only(top: isSmallScreen ? 12 : 16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.white.withOpacity(0.4),
                            size: isSmallScreen ? 14 : 16,
                          ),
                          SizedBox(width: isSmallScreen ? 6 : 8),
                          Text(
                            'Início: ${_formatDate(habit.startDate!)}',
                            style: GoogleFonts.inter(
                              fontSize: isSmallScreen ? 12 : 14,
                              color: Colors.white.withOpacity(0.4),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Categoria
                  if (habit.categoryName != null)
                    Row(
                      children: [
                        Icon(
                          _getCategoryIcon(habit.categoryName),
                          size: isSmallScreen ? 14 : 16,
                          color: Colors.blue.withOpacity(0.8),
                        ),
                        SizedBox(width: isSmallScreen ? 6 : 8),
                        Text(
                          habit.categoryName!,
                          style: GoogleFonts.inter(
                            fontSize: isSmallScreen ? 14 : 16,
                            color: Colors.blue.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showHabitDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _HabitDetailsModal(habit: habit),
    );
  }

  void _viewRecord(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => ProgressRecordScreen(
              habitId: habit.id,
              habitName: habit.name,
              category: habit.categoryName ?? 'Categoria',
              totalMinutes: 6777,
              dailyAverage: '2h 16min',
              currentStreak: '1 mês e 3 dias',
              monthDays: '22 de 31',
              progressPercent: 0.66,
              weeklyData: [1, 2, 1, 3, 4, 2, 3],
            ),
      ),
    );
  }

  void _completeHabit(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FinishHabitScreen(habit: habit)),
    );
  }

  void _editHabit(BuildContext context) async {
    int? categoryId;
    if (habit.categoryName != null) {
      categoryId = await CategoryService.fetchCategoryIdByName(
        habit.categoryName!,
      );
    }

    await Navigator.pushNamed(
      context,
      '/cadastrar_habito',
      arguments: HabitData(
        habitId: habit.id,
        habitName: habit.name,
        description: habit.description,
        selectedCategory: categoryId,
        frequencyData: {
          'option': habit.frequency.option,
          'value': habit.frequency.value,
        },
        startDate: habit.startDate,
        endDate: habit.endDate,
        reminders: habit.reminders ?? [],
        priority: habit.priority,
      ),
    );

    if (onHabitUpdated != null) onHabitUpdated!();
  }

  void _archiveHabit(BuildContext context) async {
    final confirm = await showConfirmActionDialog(
      context: context,
      title: 'Arquivar hábito',
      message: 'Deseja arquivar este hábito?',
      confirmText: 'Arquivar',
      confirmColor: Colors.amber,
    );

    if (!confirm) return;

    final result = await HabitService.archiveHabit(habit.id);
    if (result) {
      await Future.delayed(const Duration(milliseconds: 700));
      if (onHabitArchived != null) onHabitArchived!();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hábito arquivado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao arquivar hábito!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _deleteHabit(BuildContext context) async {
    final confirm = await showConfirmActionDialog(
      context: context,
      title: 'Excluir hábito',
      message: 'Deseja excluir este hábito?',
      confirmText: 'Excluir',
      confirmColor: Colors.red,
    );

    if (!confirm) return;

    final result = await HabitService.deleteHabit(habit.id);
    if (result) {
      if (onHabitDeleted != null) onHabitDeleted!();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hábito excluído com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao excluir hábito!'),
          backgroundColor: Colors.red,
        ),
      );
    }
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

  IconData _getCategoryIcon(String? categoryName) {
    if (categoryName == null || categoryName.isEmpty) return Icons.category;

    final lowerCategory = categoryName.toLowerCase();
    if (lowerCategory.contains('saúde') || lowerCategory.contains('health')) {
      return Icons.favorite;
    } else if (lowerCategory.contains('exercício') ||
        lowerCategory.contains('fitness')) {
      return Icons.fitness_center;
    } else if (lowerCategory.contains('estudo') ||
        lowerCategory.contains('study')) {
      return Icons.school;
    } else if (lowerCategory.contains('trabalho') ||
        lowerCategory.contains('work')) {
      return Icons.work;
    } else if (lowerCategory.contains('casa') ||
        lowerCategory.contains('home')) {
      return Icons.home;
    } else if (lowerCategory.contains('financeiro') ||
        lowerCategory.contains('money')) {
      return Icons.attach_money;
    } else if (lowerCategory.contains('social') ||
        lowerCategory.contains('people')) {
      return Icons.people;
    } else if (lowerCategory.contains('hobby') ||
        lowerCategory.contains('lazer')) {
      return Icons.sports_esports;
    } else {
      return Icons.category;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$day/$month/$year às $hour:$minute';
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Widget _buildFrequencyChip(Habit habit) {
    final freq = habit.frequency;
    Color color;
    IconData icon;
    String label;

    switch (freq.option) {
      case 'daily':
        color = Colors.green;
        icon = Icons.calendar_today;
        label = 'Todos os dias';
        break;
      case 'weekly':
        color = Colors.blue;
        icon = Icons.view_week;
        if (freq.value is List && (freq.value as List).isNotEmpty) {
          final dias = _getShortDayNames(freq.value as List);
          label = dias.join(', ');
        } else {
          label = 'Semanal';
        }
        break;
      case 'monthly':
        color = Colors.purple;
        icon = Icons.calendar_month;
        if (freq.value is List && (freq.value as List).isNotEmpty) {
          label = (freq.value as List).join(', ');
        } else {
          label = 'Mensal';
        }
        break;
      default:
        color = Colors.orange;
        icon = Icons.tune;
        label = 'Personalizado';
    }

    return Chip(
      avatar: Icon(icon, color: Colors.white, size: 18),
      label: Text(
        label,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      backgroundColor: color.withOpacity(0.8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
    );
  }

  List<String> _getShortDayNames(List days) {
    const dayNames = {
      1: 'Seg',
      2: 'Ter',
      3: 'Qua',
      4: 'Qui',
      5: 'Sex',
      6: 'Sáb',
      7: 'Dom',
    };
    return days.map((d) => dayNames[d] ?? 'Dia$d').toList();
  }

  Widget _buildCategoryImage() {
    final category = categories.firstWhere(
      (cat) => cat.name == habit.categoryName,
      orElse:
          () => Category(id: 0, name: '', description: '', color: '', icon: ''),
    );

    if (category.icon.isNotEmpty) {
      final apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3333';
      final imageUrl = '$apiUrl${category.icon}';

      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return SizedBox.shrink();
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value:
                    loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white54),
              ),
            );
          },
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}

class _HabitDetailsModal extends StatelessWidget {
  final Habit habit;

  const _HabitDetailsModal({required this.habit});

  String _getFrequencyDetails() {
    switch (habit.frequency.option) {
      case 'daily':
        return 'Todos os dias';
      case 'weekly':
        if (habit.frequency.value is List) {
          final days = habit.frequency.value as List;
          if (days.isNotEmpty) {
            final dayNames = _getDayNames(days);
            return 'Dias da semana: ${dayNames.join(', ')}';
          }
        }
        return 'Semanal';
      case 'monthly':
        if (habit.frequency.value is List) {
          final days = habit.frequency.value as List;
          if (days.isNotEmpty) {
            final dayNumbers = days.map((d) => d.toString()).join(', ');
            return 'Dias do mês: $dayNumbers';
          }
        }
        return 'Mensal';
      default:
        if (habit.frequency.value is List) {
          final days = habit.frequency.value as List;
          if (days.isNotEmpty) {
            return 'Personalizado: ${days.join(', ')}';
          }
        }
        return 'Personalizado';
    }
  }

  String _getRemindersDetails() {
    final reminders = habit.reminders;
    if (reminders == null || reminders.isEmpty) {
      return 'Nenhum lembrete configurado';
    }
    final formattedReminders =
        reminders.map((r) => _formatDateTime(r)).toList();
    return formattedReminders.join('\n');
  }

  String _formatDateTime(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$day/$month/$year às $hour:$minute';
  }

  List<String> _getDayNames(List days) {
    final dayNames = {
      1: 'Segunda',
      2: 'Terça',
      3: 'Quarta',
      4: 'Quinta',
      5: 'Sexta',
      6: 'Sábado',
      7: 'Domingo',
    };
    return days.map((day) => dayNames[day] ?? 'Dia $day').toList();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  IconData _getCategoryIcon(String? categoryName) {
    if (categoryName == null || categoryName.isEmpty) return Icons.category;

    final lowerCategory = categoryName.toLowerCase();
    if (lowerCategory.contains('saúde') || lowerCategory.contains('health')) {
      return Icons.favorite;
    } else if (lowerCategory.contains('exercício') ||
        lowerCategory.contains('fitness')) {
      return Icons.fitness_center;
    } else if (lowerCategory.contains('estudo') ||
        lowerCategory.contains('study')) {
      return Icons.school;
    } else if (lowerCategory.contains('trabalho') ||
        lowerCategory.contains('work')) {
      return Icons.work;
    } else if (lowerCategory.contains('casa') ||
        lowerCategory.contains('home')) {
      return Icons.home;
    } else if (lowerCategory.contains('financeiro') ||
        lowerCategory.contains('money')) {
      return Icons.attach_money;
    } else if (lowerCategory.contains('social') ||
        lowerCategory.contains('people')) {
      return Icons.people;
    } else if (lowerCategory.contains('hobby') ||
        lowerCategory.contains('lazer')) {
      return Icons.sports_esports;
    } else {
      return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Color(0xFF1F222A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Text(
                    habit.name,
                    style: GoogleFonts.inter(
                      fontSize: isSmallScreen ? 20 : 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 6 : 8),

                  // Categoria
                  if (habit.categoryName != null)
                    Row(
                      children: [
                        Icon(
                          _getCategoryIcon(habit.categoryName),
                          size: isSmallScreen ? 14 : 16,
                          color: Colors.blue.withOpacity(0.8),
                        ),
                        SizedBox(width: isSmallScreen ? 6 : 8),
                        Text(
                          habit.categoryName!,
                          style: GoogleFonts.inter(
                            fontSize: isSmallScreen ? 14 : 16,
                            color: Colors.blue.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                  SizedBox(height: isSmallScreen ? 16 : 20),

                  // Descrição
                  if (habit.description.isNotEmpty) ...[
                    Text(
                      'Descrição',
                      style: GoogleFonts.inter(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 6 : 8),
                    Text(
                      habit.description,
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: isSmallScreen ? 14 : 16,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 16 : 20),
                  ],

                  // Detalhes
                  _buildDetailSection(
                    title: 'Frequência',
                    icon: Icons.repeat,
                    content: _getFrequencyDetails(),
                    isSmallScreen: isSmallScreen,
                  ),

                  SizedBox(height: isSmallScreen ? 12 : 16),

                  if (habit.startDate != null)
                    _buildDetailSection(
                      title: 'Data de Início',
                      icon: Icons.calendar_today,
                      content: _formatDate(habit.startDate!),
                      isSmallScreen: isSmallScreen,
                    ),

                  if (habit.endDate != null) ...[
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    _buildDetailSection(
                      title: 'Data de Término',
                      icon: Icons.event_busy,
                      content: _formatDate(habit.endDate!),
                      isSmallScreen: isSmallScreen,
                    ),
                  ],

                  SizedBox(height: isSmallScreen ? 12 : 16),

                  _buildDetailSection(
                    title: 'Prioridade',
                    icon: Icons.priority_high,
                    content: _getPriorityText(habit.priority),
                    color: _getPriorityColor(habit.priority),
                    isSmallScreen: isSmallScreen,
                  ),

                  if (habit.reminders?.isNotEmpty == true) ...[
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    _buildDetailSection(
                      title: 'Lembretes',
                      icon: Icons.notifications,
                      content: _getRemindersDetails(),
                      isSmallScreen: isSmallScreen,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
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

  Widget _buildDetailSection({
    required String title,
    required IconData icon,
    required String content,
    Color? color,
    required bool isSmallScreen,
  }) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
            decoration: BoxDecoration(
              color: (color ?? Colors.blue).withOpacity(0.2),
              borderRadius: BorderRadius.circular(isSmallScreen ? 6 : 8),
            ),
            child: Icon(
              icon,
              color: color ?? Colors.blue,
              size: isSmallScreen ? 16 : 20,
            ),
          ),
          SizedBox(width: isSmallScreen ? 12 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: Colors.white70,
                    fontSize: isSmallScreen ? 10 : 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 2 : 4),
                Text(
                  content,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
