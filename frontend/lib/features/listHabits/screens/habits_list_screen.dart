import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/filter_chips.dart';
import '../widgets/search_bar.dart';
import '../services/list_habits_service.dart';
import '../models/HabitModel.dart';
import '../widgets/habit_card.dart';
import '../widgets/archived_habits.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HabitsListPage extends StatefulWidget {
  const HabitsListPage({Key? key}) : super(key: key);

  @override
  State<HabitsListPage> createState() => _HabitsListPageState();
}

class _HabitsListPageState extends State<HabitsListPage> {
  Future<List<Habit>> _habitsFuture = Future.value([]);
  String? searchQuery = '';
  String selectedFilter = 'Todos';
  int? userId;
  List<Habit> _allHabits =
      []; // Todos os hábitos (incluindo arquivados) para estatísticas
  List<Habit> _activeHabits = []; // Apenas hábitos ativos para exibição
  List<Habit> _filteredHabits = [];
  String? _selectedCategoryChip;
  bool showFilters = true;

  Future<int?> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('loggedInUserId');
  }

  Future<void> _loadHabits() async {
    if (userId == null) return;

    // Buscar todos os hábitos para estatísticas
    final allHabits = await HabitService.fetchAllHabits(userId!);
    // Buscar apenas hábitos ativos para exibição
    final activeHabits = await HabitService.fetchHabits(userId!);

    setState(() {
      _allHabits = allHabits;
      _activeHabits = activeHabits;
      _applyFilters();
    });
  }

  void _applyFilters() {
    List<Habit> filtered = List.from(_activeHabits);

    // Filtrar por categoria (chip)
    if (_selectedCategoryChip != null) {
      filtered =
          filtered
              .where(
                (h) =>
                    (h.categoryName ?? 'Sem categoria') ==
                    _selectedCategoryChip,
              )
              .toList();
    }

    // Filtrar por busca
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      filtered =
          filtered.where((h) {
            final name = h.name.toLowerCase();
            final description = h.description.toLowerCase();
            final category = h.categoryName?.toLowerCase() ?? '';
            final query = searchQuery!.toLowerCase();

            return name.contains(query) ||
                description.contains(query) ||
                category.contains(query);
          }).toList();
    }

    // Filtrar por prioridade/status/frequência
    switch (selectedFilter) {
      case 'Alta':
        filtered = filtered.where((h) => h.priority == 1).toList();
        break;
      case 'Normal':
        filtered = filtered.where((h) => h.priority == 2).toList();
        break;
      case 'Baixa':
        filtered = filtered.where((h) => h.priority == 3).toList();
        break;
      case 'Diário':
        filtered = filtered.where((h) => _shouldShowToday(h)).toList();
        break;
      case 'Semanal':
        filtered = filtered.where((h) => _shouldShowThisWeek(h)).toList();
        break;
      case 'Mensal':
        filtered = filtered.where((h) => _shouldShowThisMonth(h)).toList();
        break;
      case 'Anual':
        filtered = filtered.where((h) => _shouldShowThisYear(h)).toList();
        break;
      case 'Todos':
      default:
        // Não filtrar por prioridade/status
        break;
    }

    setState(() {
      _filteredHabits = filtered;
    });
  }

  // Métodos para calcular contadores dos filtros (usando hábitos ativos)
  int _getFilterCount(String filter) {
    List<Habit> filtered = List.from(_activeHabits);

    switch (filter) {
      case 'Alta':
        return filtered.where((h) => h.priority == 1).length;
      case 'Normal':
        return filtered.where((h) => h.priority == 2).length;
      case 'Baixa':
        return filtered.where((h) => h.priority == 3).length;
      case 'Diário':
        return filtered.where((h) => _shouldShowToday(h)).length;
      case 'Semanal':
        return filtered.where((h) => _shouldShowThisWeek(h)).length;
      case 'Mensal':
        return filtered.where((h) => _shouldShowThisMonth(h)).length;
      case 'Anual':
        return filtered.where((h) => _shouldShowThisYear(h)).length;
      case 'Todos':
      default:
        return _activeHabits.length;
    }
  }

  // Verifica se o hábito deve ser mostrado hoje
  bool _shouldShowToday(Habit habit) {
    final today = DateTime.now();

    // Verifica se está dentro do período do hábito
    if (habit.startDate != null && today.isBefore(habit.startDate!)) {
      return false;
    }
    if (habit.endDate != null && today.isAfter(habit.endDate!)) {
      return false;
    }

    // Verifica a frequência
    switch (habit.frequency.option) {
      case 'daily':
        return true; // Diário sempre aparece
      case 'weekly':
        // Verifica se hoje é um dos dias da semana configurados
        if (habit.frequency.value is List) {
          final days = habit.frequency.value as List;
          final weekday = today.weekday; // 1 = Segunda, 7 = Domingo
          return days.contains(weekday);
        }
        return true; // Se não tem configuração específica, mostra
      case 'monthly':
        // Verifica se hoje é um dos dias do mês configurados
        if (habit.frequency.value is List) {
          final days = habit.frequency.value as List;
          return days.contains(today.day);
        }
        return true;
      default:
        return true;
    }
  }

  // Verifica se o hábito deve ser mostrado esta semana
  bool _shouldShowThisWeek(Habit habit) {
    final today = DateTime.now();
    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    // Verifica se está dentro do período do hábito
    if (habit.startDate != null && endOfWeek.isBefore(habit.startDate!)) {
      return false;
    }
    if (habit.endDate != null && startOfWeek.isAfter(habit.endDate!)) {
      return false;
    }

    // Para hábitos semanais, sempre mostra
    if (habit.frequency.option == 'weekly') {
      return true;
    }

    // Para hábitos diários, mostra se tem pelo menos um dia na semana
    if (habit.frequency.option == 'daily') {
      return true;
    }

    return true;
  }

  // Verifica se o hábito deve ser mostrado este mês
  bool _shouldShowThisMonth(Habit habit) {
    final today = DateTime.now();
    final startOfMonth = DateTime(today.year, today.month, 1);
    final endOfMonth = DateTime(today.year, today.month + 1, 0);

    // Verifica se está dentro do período do hábito
    if (habit.startDate != null && endOfMonth.isBefore(habit.startDate!)) {
      return false;
    }
    if (habit.endDate != null && startOfMonth.isAfter(habit.endDate!)) {
      return false;
    }

    // Para hábitos mensais, sempre mostra
    if (habit.frequency.option == 'monthly') {
      return true;
    }

    // Para hábitos diários e semanais, mostra se tem pelo menos um dia no mês
    if (habit.frequency.option == 'daily' ||
        habit.frequency.option == 'weekly') {
      return true;
    }

    return true;
  }

  // Verifica se o hábito deve ser mostrado este ano
  bool _shouldShowThisYear(Habit habit) {
    final today = DateTime.now();
    final startOfYear = DateTime(today.year, 1, 1);
    final endOfYear = DateTime(today.year, 12, 31);

    // Verifica se está dentro do período do hábito
    if (habit.startDate != null && endOfYear.isBefore(habit.startDate!)) {
      return false;
    }
    if (habit.endDate != null && startOfYear.isAfter(habit.endDate!)) {
      return false;
    }

    return true; // Todos os hábitos ativos no ano aparecem
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
    });
    _applyFilters();
  }

  void _onFilterChanged(String filter) {
    setState(() {
      selectedFilter = filter;
    });
    _applyFilters();
  }

  Future<void> _initData() async {
    final id = await _loadUserId();
    if (id != null) {
      setState(() {
        userId = id;
      });
      await _loadHabits();
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700 || screenWidth < 500;
    final isVerySmallScreen = screenHeight < 600 || screenWidth < 400;
    final isNarrowScreen = screenWidth < 400;
    final isLandscape = screenWidth > screenHeight;
    final isTablet = screenWidth > 700;

    // Obter lista única de categorias dos hábitos ativos
    final categorias =
        _activeHabits
            .map((h) => h.categoryName ?? 'Sem categoria')
            .toSet()
            .toList();
    categorias.sort();

    return LayoutBuilder(
      builder: (context, constraints) {
        final useGrid = isLandscape || isTablet;
        final crossAxisCount = useGrid ? (isTablet ? 3 : 2) : 1;
        final cardAspectRatio = useGrid ? 1.7 : 2.8;
        return Scaffold(
          backgroundColor: const Color(0xFF0A0A0A),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Meus Hábitos',
              style: GoogleFonts.inter(
                fontSize: isSmallScreen ? 20 : 28,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/inicio');
              },
            ),
            actions: [
              Container(
                margin: EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange.withOpacity(0.8),
                      Colors.orange.withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder:
                            (_) => ArchivedHabitsModal(
                              onHabitRestored: () {
                                _loadHabits();
                              },
                            ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.archive_outlined,
                            color: Colors.white,
                            size: isSmallScreen ? 18 : 20,
                          ),
                          SizedBox(width: isSmallScreen ? 4 : 6),
                          Text(
                            'Arquivados',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: isSmallScreen ? 12 : 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 8 : 24,
                  vertical: isSmallScreen ? 8 : 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Estatísticas simplificadas
                    Container(
                      margin: EdgeInsets.only(bottom: isSmallScreen ? 8 : 24),
                      padding: EdgeInsets.all(isSmallScreen ? 12 : 28),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(
                          isSmallScreen ? 16 : 28,
                        ),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              icon: Icons.list_alt,
                              title: 'Total',
                              value: _allHabits.length.toString(),
                              color: Colors.white,
                              isSmallScreen: isSmallScreen,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: isSmallScreen ? 30 : 60,
                            color: Colors.white.withOpacity(0.1),
                          ),
                          Expanded(
                            child: _buildStatCard(
                              icon: Icons.check_circle_outline,
                              title: 'Ativos',
                              value:
                                  _allHabits
                                      .where((h) => h.status == 1)
                                      .length
                                      .toString(),
                              color: Colors.green,
                              isSmallScreen: isSmallScreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Barra de busca
                    SearchBarWidget(onSearchChanged: _onSearchChanged),
                    SizedBox(height: isSmallScreen ? 6 : 18),
                    // Botão de mostrar/ocultar filtros
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue,
                          backgroundColor: Colors.white.withOpacity(0.04),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                        ),
                        icon: AnimatedRotation(
                          turns: showFilters ? 0.5 : 0,
                          duration: Duration(milliseconds: 200),
                          child: Icon(Icons.filter_alt_rounded, size: 22),
                        ),
                        label: Text(
                          showFilters ? 'Ocultar filtros' : 'Mostrar filtros',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: isSmallScreen ? 12 : 14,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            showFilters = !showFilters;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 4 : 10),
                    AnimatedCrossFade(
                      duration: Duration(milliseconds: 250),
                      crossFadeState:
                          showFilters
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                      firstChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Filtro de categorias por chips
                          if (categorias.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: isSmallScreen ? 6 : 18,
                              ),
                              child: Wrap(
                                spacing: isSmallScreen ? 8 : 16,
                                runSpacing: 6,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: ChoiceChip(
                                      label: Text(
                                        'Todas',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              _selectedCategoryChip == null
                                                  ? Colors.white
                                                  : Colors.blue,
                                          fontSize: isSmallScreen ? 13 : 17,
                                        ),
                                      ),
                                      selected: _selectedCategoryChip == null,
                                      selectedColor: Colors.blue.shade600,
                                      backgroundColor: Colors.white.withOpacity(
                                        0.08,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          isSmallScreen ? 18 : 24,
                                        ),
                                        side: BorderSide(
                                          color:
                                              _selectedCategoryChip == null
                                                  ? Colors.blue.shade600
                                                  : Colors.white24,
                                          width: 2,
                                        ),
                                      ),
                                      elevation:
                                          _selectedCategoryChip == null ? 4 : 0,
                                      shadowColor: Colors.blue.withOpacity(0.2),
                                      onSelected: (selected) {
                                        setState(() {
                                          _selectedCategoryChip = null;
                                        });
                                        _applyFilters();
                                      },
                                    ),
                                  ),
                                  ...categorias.map(
                                    (cat) => Padding(
                                      padding: const EdgeInsets.only(
                                        right: 4.0,
                                      ),
                                      child: ChoiceChip(
                                        label: Text(
                                          cat,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                _selectedCategoryChip == cat
                                                    ? Colors.white
                                                    : Colors.blue,
                                            fontSize: isSmallScreen ? 13 : 17,
                                          ),
                                        ),
                                        selected: _selectedCategoryChip == cat,
                                        selectedColor: Colors.blue.shade600,
                                        backgroundColor: Colors.white
                                            .withOpacity(0.08),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            isSmallScreen ? 18 : 24,
                                          ),
                                          side: BorderSide(
                                            color:
                                                _selectedCategoryChip == cat
                                                    ? Colors.blue.shade600
                                                    : Colors.white24,
                                            width: 2,
                                          ),
                                        ),
                                        elevation:
                                            _selectedCategoryChip == cat
                                                ? 4
                                                : 0,
                                        shadowColor: Colors.blue.withOpacity(
                                          0.2,
                                        ),
                                        onSelected: (selected) {
                                          setState(() {
                                            _selectedCategoryChip =
                                                selected ? cat : null;
                                          });
                                          _applyFilters();
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          // Filtros de prioridade com contadores
                          FilterChipsWidget(
                            onFilterChanged: _onFilterChanged,
                            selectedFilter: selectedFilter,
                            filterCounts: {
                              'Todos': _getFilterCount('Todos'),
                              'Alta': _getFilterCount('Alta'),
                              'Normal': _getFilterCount('Normal'),
                              'Baixa': _getFilterCount('Baixa'),
                              'Diário': _getFilterCount('Diário'),
                              'Semanal': _getFilterCount('Semanal'),
                              'Mensal': _getFilterCount('Mensal'),
                              'Anual': _getFilterCount('Anual'),
                            },
                          ),
                        ],
                      ),
                      secondChild: SizedBox.shrink(),
                    ),
                    SizedBox(height: isSmallScreen ? 6 : 18),
                    // Indicador de filtros ativos (mais sutil)
                    if (searchQuery != null && searchQuery!.isNotEmpty ||
                        selectedFilter != 'Todos')
                      Container(
                        margin: EdgeInsets.only(bottom: isSmallScreen ? 8 : 20),
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 10 : 24,
                          vertical: isSmallScreen ? 6 : 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(
                            isSmallScreen ? 12 : 20,
                          ),
                          border: Border.all(
                            color: Colors.blue.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.filter_alt,
                              color: Colors.blue,
                              size: isSmallScreen ? 12 : 20,
                            ),
                            SizedBox(width: isSmallScreen ? 6 : 14),
                            Expanded(
                              child: Text(
                                _getFilterText(),
                                style: GoogleFonts.inter(
                                  color: Colors.blue,
                                  fontSize: isSmallScreen ? 10 : 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  searchQuery = '';
                                  selectedFilter = 'Todos';
                                });
                                _applyFilters();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Icon(
                                  Icons.clear,
                                  color: Colors.blue,
                                  size: isSmallScreen ? 12 : 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    // Lista de hábitos
                    if (_filteredHabits.isEmpty)
                      _buildEmptyState(isSmallScreen)
                    else
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final useGrid = isLandscape || isTablet;
                          final crossAxisCount =
                              useGrid ? (isTablet ? 3 : 2) : 1;
                          final cardAspectRatio = useGrid ? 1.7 : 2.8;
                          return useGrid
                              ? GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(
                                  horizontal: isSmallScreen ? 8 : 24,
                                  vertical: isSmallScreen ? 8 : 16,
                                ),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      crossAxisSpacing: isSmallScreen ? 8 : 24,
                                      mainAxisSpacing: isSmallScreen ? 8 : 24,
                                      childAspectRatio: cardAspectRatio,
                                    ),
                                itemCount: _filteredHabits.length,
                                itemBuilder: (context, index) {
                                  final habit = _filteredHabits[index];
                                  return HabitCardWidget(
                                    habit: habit,
                                    onHabitArchived: () {
                                      _loadHabits();
                                    },
                                    onHabitDeleted: () {
                                      _loadHabits();
                                    },
                                    onHabitUpdated: () {
                                      _loadHabits();
                                    },
                                  );
                                },
                              )
                              : ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(
                                  horizontal: isSmallScreen ? 8 : 16,
                                ),
                                itemCount: _filteredHabits.length,
                                itemBuilder: (context, index) {
                                  final habit = _filteredHabits[index];
                                  return HabitCardWidget(
                                    habit: habit,
                                    onHabitArchived: () {
                                      _loadHabits();
                                    },
                                    onHabitDeleted: () {
                                      _loadHabits();
                                    },
                                    onHabitUpdated: () {
                                      _loadHabits();
                                    },
                                  );
                                },
                              );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/cadastrar_habito');
            },
            child: const Icon(Icons.add_rounded, color: Colors.white),
            backgroundColor: Colors.blue.shade600,
            elevation: 4,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required bool isSmallScreen,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: isSmallScreen ? 20 : 24),
        SizedBox(height: isSmallScreen ? 6 : 8),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: isSmallScreen ? 18 : 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: isSmallScreen ? 11 : 12,
            color: Colors.white60,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmptyState(bool isSmallScreen) {
    String message;
    IconData icon;

    if (searchQuery != null && searchQuery!.isNotEmpty) {
      message = 'Nenhum hábito encontrado para "${searchQuery!}"';
      icon = Icons.search_off;
    } else if (selectedFilter != 'Todos') {
      message = 'Nenhum hábito com filtro "$selectedFilter"';
      icon = Icons.filter_list_off;
    } else if (_activeHabits.isEmpty) {
      message = 'Você ainda não tem hábitos cadastrados';
      icon = Icons.add_task;
    } else {
      message = 'Nenhum hábito encontrado';
      icon = Icons.inbox_outlined;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(isSmallScreen ? 40 : 50),
            ),
            child: Icon(
              icon,
              size: isSmallScreen ? 48 : 64,
              color: Colors.white54,
            ),
          ),
          SizedBox(height: isSmallScreen ? 16 : 24),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 20 : 32),
            child: Text(
              message,
              style: GoogleFonts.inter(
                fontSize: isSmallScreen ? 16 : 18,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: isSmallScreen ? 6 : 8),
          if (_activeHabits.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 20 : 32,
              ),
              child: Text(
                'Comece criando seu primeiro hábito!',
                style: GoogleFonts.inter(
                  fontSize: isSmallScreen ? 12 : 14,
                  color: Colors.white54,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          SizedBox(height: isSmallScreen ? 24 : 32),
          if (_activeHabits.isEmpty)
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/cadastrar_habito');
              },
              icon: Icon(Icons.add, size: isSmallScreen ? 18 : 20),
              label: Text(
                'Criar Primeiro Hábito',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: isSmallScreen ? 14 : 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 20 : 24,
                  vertical: isSmallScreen ? 10 : 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getFilterText() {
    List<String> filters = [];

    if (searchQuery != null && searchQuery!.isNotEmpty) {
      filters.add('Busca: "${searchQuery!}"');
    }

    if (selectedFilter != 'Todos') {
      filters.add('Filtro: $selectedFilter');
    }

    return filters.join(' • ');
  }
}
