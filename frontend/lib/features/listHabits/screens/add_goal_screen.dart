import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddGoalScreen extends StatefulWidget {
  final String? initialName;
  final int? initialType; // 0: Automático, 1: Manual, 2: Acumulativa
  final int? initialParameter;
  final int? initialInterval; // 0: Dia, 1: Semanal, 2: Mensal
  final bool isEditing;

  const AddGoalScreen({
    Key? key,
    this.initialName,
    this.initialType,
    this.initialParameter,
    this.initialInterval,
    this.isEditing = false,
  }) : super(key: key);

  @override
  State<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _nameController;
  late int _selectedType;
  late int _parameter;
  late int _selectedInterval;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  bool _nameValid = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _selectedType = widget.initialType ?? 0;
    _parameter = widget.initialParameter ?? 10;
    _selectedInterval = widget.initialInterval ?? 0;
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutQuart,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _showParameterInfo() {
    String info = '';
    if (_selectedType == 0) {
      info = 'Automático: tempo em horas.';
    } else if (_selectedType == 2) {
      info = 'Acumulativa: número de vezes.';
    } else {
      info = 'Manual: sem parâmetro.';
    }
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF232B3E),
            title: Text(
              'Parâmetro',
              style: GoogleFonts.inter(color: Colors.white),
            ),
            content: Text(
              info,
              style: GoogleFonts.inter(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK', style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
    );
  }

  void _showIntervalInfo() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF232B3E),
            title: Text(
              'Intervalo',
              style: GoogleFonts.inter(color: Colors.white),
            ),
            content: Text(
              'Diário: aparece todos os dias.\nSemanal: reinicia toda semana.\nMensal: reinicia todo mês.',
              style: GoogleFonts.inter(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK', style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
    );
  }

  void _showTypeInfo() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF232B3E),
            title: Text('Tipo', style: GoogleFonts.inter(color: Colors.white)),
            content: Text(
              'Automático: o sistema registra automaticamente (ex: tempo de estudo).\nManual: você marca quando cumprir.\nAcumulativa: você define uma meta de quantidade (ex: ler 10 tópicos).',
              style: GoogleFonts.inter(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK', style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
    );
  }

  void _validateAndSave() {
    setState(() {
      _nameValid = _nameController.text.trim().isNotEmpty;
    });
    if (_nameValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 22),
              const SizedBox(width: 8),
              Text(widget.isEditing ? 'Meta atualizada!' : 'Meta adicionada!'),
            ],
          ),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFF10182B),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            widget.isEditing ? 'Editar meta' : 'Nova meta',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: MediaQuery.of(context).size.width * 0.045,
              letterSpacing: 0.5,
            ),
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: FadeTransition(
            opacity: _fadeAnim,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1B2236), Color(0xFF232B3E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.13),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _nameController,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.045,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Nome',
                          labelStyle: GoogleFonts.inter(
                            color: Colors.white70,
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                          ),
                          hintText: 'Leitura, revisar...',
                          hintStyle: GoogleFonts.inter(
                            color: Colors.white24,
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                          ),
                          filled: true,
                          fillColor: const Color(0xFF232B3E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 20,
                          ),
                          suffixIcon:
                              _nameValid
                                  ? const Icon(
                                    Icons.check_circle,
                                    color: Colors.greenAccent,
                                    size: 22,
                                  )
                                  : const Icon(
                                    Icons.error_outline,
                                    color: Colors.redAccent,
                                    size: 22,
                                  ),
                        ),
                        onChanged: (v) {
                          setState(() {
                            _nameValid = v.trim().isNotEmpty;
                          });
                        },
                      ),
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          Text(
                            'Tipo',
                            style: GoogleFonts.inter(
                              color: Colors.white70,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.035,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: _showTypeInfo,
                            child: const Icon(
                              Icons.info_outline,
                              color: Colors.white38,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _TypeSelector(
                            icon: Icons.settings,
                            iconColor: Colors.blueAccent,
                            label: 'Automático',
                            selected: _selectedType == 0,
                            onTap: () => setState(() => _selectedType = 0),
                          ),
                          _TypeSelector(
                            icon: Icons.edit,
                            iconColor: Colors.orangeAccent,
                            label: 'Manual',
                            selected: _selectedType == 1,
                            onTap: () => setState(() => _selectedType = 1),
                          ),
                          _TypeSelector(
                            icon: Icons.arrow_upward,
                            iconColor: Colors.purpleAccent,
                            label: 'Acumulativa',
                            selected: _selectedType == 2,
                            onTap: () => setState(() => _selectedType = 2),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _selectedType == 0
                            ? 'Automático: o sistema registra automaticamente (ex: tempo de estudo).'
                            : _selectedType == 1
                            ? 'Manual: você marca quando cumprir.'
                            : 'Acumulativa: você define uma meta de quantidade (ex: ler 10 tópicos).',
                        style: GoogleFonts.inter(
                          color: Colors.white54,
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Divider(color: Colors.white12, thickness: 1, height: 24),
                      Row(
                        children: [
                          Text(
                            'Parâmetro',
                            style: GoogleFonts.inter(
                              color: Colors.white70,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.035,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: _showParameterInfo,
                            child: const Icon(
                              Icons.info_outline,
                              color: Colors.white38,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          if (_selectedType != 1)
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF232B3E),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                    ),
                                    splashRadius: 20,
                                    onPressed: () {
                                      setState(() {
                                        if (_parameter > 1) _parameter--;
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    width: 40,
                                    child: Text(
                                      '$_parameter',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                            0.045,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    splashRadius: 20,
                                    onPressed: () {
                                      setState(() {
                                        _parameter++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            )
                          else
                            Text(
                              'Sem parâmetro',
                              style: GoogleFonts.inter(
                                color: Colors.white38,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.035,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Divider(color: Colors.white12, thickness: 1, height: 24),
                      Row(
                        children: [
                          Text(
                            'Intervalo',
                            style: GoogleFonts.inter(
                              color: Colors.white70,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.035,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: _showIntervalInfo,
                            child: const Icon(
                              Icons.info_outline,
                              color: Colors.white38,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _IntervalSelector(
                            label: 'Dia',
                            selected: _selectedInterval == 0,
                            onTap: () => setState(() => _selectedInterval = 0),
                          ),
                          const SizedBox(width: 8),
                          _IntervalSelector(
                            label: 'Semanal',
                            selected: _selectedInterval == 1,
                            onTap: () => setState(() => _selectedInterval = 1),
                          ),
                          const SizedBox(width: 8),
                          _IntervalSelector(
                            label: 'Mensal',
                            selected: _selectedInterval == 2,
                            onTap: () => setState(() => _selectedInterval = 2),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTapDown: (_) => setState(() {}),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 120),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2196F3), Color(0xFF1565C0)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.18),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          splashColor: Colors.white24,
                          onTap: _validateAndSave,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: Text(
                                widget.isEditing ? 'Salvar' : 'Adicionar',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.045,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TypeSelector extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TypeSelector({
    required this.icon,
    this.iconColor,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color:
              selected
                  ? Colors.blue.withOpacity(0.18)
                  : const Color(0xFF232B3E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? Colors.blue : Colors.white12,
            width: 2,
          ),
          boxShadow:
              selected
                  ? [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : [],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: iconColor ?? (selected ? Colors.blue : Colors.white54),
              size: 32,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                color: selected ? Colors.blue : Colors.white54,
                fontWeight: FontWeight.w600,
                fontSize: MediaQuery.of(context).size.width * 0.035,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IntervalSelector extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _IntervalSelector({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color:
              selected
                  ? Colors.blue.withOpacity(0.18)
                  : const Color(0xFF232B3E),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? Colors.blue : Colors.white12,
            width: 2,
          ),
          boxShadow:
              selected
                  ? [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.10),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : [],
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: selected ? Colors.blue : Colors.white54,
            fontWeight: FontWeight.w600,
            fontSize: MediaQuery.of(context).size.width * 0.035,
          ),
        ),
      ),
    );
  }
}
