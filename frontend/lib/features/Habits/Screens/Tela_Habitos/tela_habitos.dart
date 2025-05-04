import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../themes/Tela_Habitos/habits_theme.dart';
import '../../components/Tela_Habitos/habit_text_field.dart';
import '../../widgets/Tela_Habitos/category_grid.dart';

class TelaHabitos extends StatefulWidget {
  @override
  _TelaHabitosState createState() => _TelaHabitosState();
}

class _TelaHabitosState extends State<TelaHabitos> {
  String habitName = '';
  String description = '';
  String selectedCategory = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HabitsTheme.backgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HabitTextField(
                    label: 'Nome do Habito',
                    hint: 'ex: Aprender um Idioma',
                    onChanged: (value) => setState(() => habitName = value),
                  ),
                  const SizedBox(height: 24),
                  HabitTextField(
                    label: 'Descrição',
                    hint: 'Opcional',
                    onChanged: (value) => setState(() => description = value),
                  ),
                  const SizedBox(height: 32),
                  _buildCategoryHeader(),
                  const SizedBox(height: 16),
                  _buildCategoryGrid(),
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
        icon: const Icon(Icons.arrow_back, color: HabitsTheme.textColor),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Novo Hábito',
        style: GoogleFonts.inter(
          color: HabitsTheme.textColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCategoryHeader() {
    return Text(
      'Categoria',
      style: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return CategoryGrid(
      selectedCategory: selectedCategory,
      onCategorySelected: _onCategorySelected,
    );
  }

  void _onCategorySelected(String category) {
    setState(() {
      if (selectedCategory == category) {
        selectedCategory = '';
      } else {
        selectedCategory = category;
      }
    });
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF17171D),
        border: Border(top: BorderSide(color: Colors.grey[900]!, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Anterior',
              style: GoogleFonts.inter(
                color: HabitsTheme.textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Row(
            children: [
              _buildDot(isActive: true),
              _buildDot(isActive: false),
              _buildDot(isActive: false),
            ],
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/frequencia');
            },
            child: Text(
              'Proxima',
              style: GoogleFonts.inter(
                color: HabitsTheme.accentColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot({required bool isActive}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            isActive ? HabitsTheme.accentColor : HabitsTheme.secondaryTextColor,
      ),
    );
  }
}
