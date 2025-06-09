import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HabitOptionsMenu extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onArchive;
  final VoidCallback onDelete;
  final VoidCallback onViewRecord;
  final VoidCallback? onComplete;

  const HabitOptionsMenu({
    Key? key,
    required this.onEdit,
    required this.onArchive,
    required this.onDelete,
    required this.onViewRecord,
    this.onComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.history, color: Colors.blue),
            title: Text(
              'Ver Registro',
              style: GoogleFonts.inter(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              onViewRecord();
            },
          ),
          if (onComplete != null)
            ListTile(
              leading: const Icon(
                Icons.check_circle_outline,
                color: Colors.greenAccent,
              ),
              title: Text(
                'Concluir Hábito',
                style: GoogleFonts.inter(
                  color: Colors.greenAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                onComplete!();
              },
            ),
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.white),
            title: Text(
              'Editar hábito',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              onEdit();
            },
          ),
          ListTile(
            leading: const Icon(Icons.archive, color: Colors.amber),
            title: Text(
              'Arquivar hábito',
              style: GoogleFonts.inter(
                color: Colors.amber,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              onArchive();
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.redAccent),
            title: Text(
              'Excluir hábito',
              style: GoogleFonts.inter(
                color: Colors.redAccent,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              onDelete();
            },
          ),
        ],
      ),
    );
  }
}
