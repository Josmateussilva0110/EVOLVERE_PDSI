import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/name_field.dart';
import '../components/type_selector_section.dart';
import '../components/parameter_selector_section.dart';
import '../service/progress_record_service.dart';
import '../model/Progress_record_model.dart';

class AddGoalScreen extends StatefulWidget {
  final int? habitId;
  final String? initialName;
  final int? initialType;
  final int? initialParameter;
  final int? initialInterval;
  final bool isEditing;

  const AddGoalScreen({
    Key? key,
    this.habitId,
    this.initialName,
    this.initialType,
    this.initialParameter,
    this.initialInterval,
    this.isEditing = false,
  }) : super(key: key);

  @override
  State<AddGoalScreen> createState() => AddGoalScreenState();
}

class AddGoalScreenState extends State<AddGoalScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _nameController;
  late int _selectedType;
  late int _parameter;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  bool _nameValid = true;

  @override
  void initState() {
    super.initState();
    print('HABIT ID: ${widget.habitId}');
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _selectedType = widget.initialType ?? 0;
    _parameter = widget.initialParameter ?? 10;
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

  void _showTypeInfo() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF232B3E),
            title: Text('Tipo', style: GoogleFonts.inter(color: Colors.white)),
            content: Text(
              'Automático: o sistema registra automaticamente (ex: tempo de estudo).\n\n'
              'Manual: você marca quando cumprir.\n\n'
              'Acumulativa: você define uma meta de quantidade (ex: ler 10 tópicos).',
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

  void _validateAndSave() async {
    setState(() {
      _nameValid = _nameController.text.trim().isNotEmpty;
    });

    if (!_nameValid) return;

    final data = ProgressRecordData(
      habitId: widget.habitId, 
      name: _nameController.text.trim(),
      type: _selectedType,
      parameter:
          _selectedType == 1
              ? null
              : _parameter, 
    );

    final error = await ProgressRecordService.createProgressHabit(data);

    if (error == null) {
      // Sucesso
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  widget.isEditing ? 'Meta atualizada!' : 'Meta adicionada!',
                ),
              ],
            ),
            backgroundColor: Colors.blue,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) Navigator.pop(context);
    } else {
      // Erro
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: $error'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = screenWidth > screenHeight;
    final maxContentWidth = isLandscape ? 680.0 : double.infinity;

    return SafeArea(
      child: Scaffold(
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
              fontSize: isLandscape ? 18 : 20,
              letterSpacing: 0.5,
            ),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxContentWidth),
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
                          NameField(
                            controller: _nameController,
                            isValid: _nameValid,
                            onChanged: (value) {
                              setState(() {
                                _nameValid = value.trim().isNotEmpty;
                              });
                            },
                          ),

                          const SizedBox(height: 28),

                          TypeSelectorSection(
                            selectedType: _selectedType,
                            onTypeSelected: (value) {
                              setState(() {
                                _selectedType = value;
                              });
                            },
                            onInfoTap: _showTypeInfo,
                          ),

                          const SizedBox(height: 24),

                          Divider(color: Colors.white12, thickness: 1),

                          const SizedBox(height: 16),

                          ParameterSelectorSection(
                            selectedType: _selectedType,
                            parameterValue: _parameter,
                            onIncrement: () {
                              setState(() {
                                _parameter++;
                              });
                            },
                            onDecrement: () {
                              setState(() {
                                if (_parameter > 1) _parameter--;
                              });
                            },
                            onInfoTap: _showParameterInfo,
                          ),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),

                    const SizedBox(height: 36),

                    // Botão salvar/adicionar
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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                child: Center(
                                  child: Text(
                                    widget.isEditing ? 'Salvar' : 'Adicionar',
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: isLandscape ? 18 : 20,
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
