import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/history_record.dart';

void showHistoryBottomSheet(BuildContext context) {
  final List<HistoryRecord> historyData = [
    HistoryRecord(
      date: '24/05/2025',
      status: 'Feito',
      difficulty: 'Fácil',
      mood: 'Feliz',
      location: 'Casa',
      reflection: 'Mantive o foco!',
    ),
    HistoryRecord(
      date: '23/05/2025',
      status: 'Em andamento',
      difficulty: 'Médio',
      mood: 'Neutro',
      location: 'Biblioteca',
      reflection: '-',
    ),
    HistoryRecord(
      date: '22/05/2025',
      status: 'Falhou',
      difficulty: 'Difícil',
      mood: 'Motivado',
      location: 'Academia',
      reflection: '-',
    ),
  ];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF10182B),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Container(
        height: MediaQuery.sizeOf(context).height * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'Histórico',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  dataRowMinHeight: 48,
                  dataRowMaxHeight: 60,
                  headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) => const Color(0xFF1A223B),
                  ),
                  border: TableBorder.all(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  columns: const [
                    DataColumn(
                      label: Text(
                        'Data',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Status',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Dificuldade',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Humor',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Local',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Reflexão',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  rows:
                      historyData.map((record) {
                        Color statusColor;
                        switch (record.status) {
                          case 'Feito':
                            statusColor = Colors.greenAccent;
                            break;
                          case 'Em andamento':
                            statusColor = Colors.orangeAccent;
                            break;
                          case 'Falhou':
                            statusColor = Colors.redAccent;
                            break;
                          default:
                            statusColor = Colors.white;
                        }
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                record.date,
                                style: GoogleFonts.inter(color: Colors.white70),
                              ),
                            ),
                            DataCell(
                              Text(
                                record.status,
                                style: GoogleFonts.inter(
                                  color: statusColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                record.difficulty,
                                style: GoogleFonts.inter(color: Colors.white70),
                              ),
                            ),
                            DataCell(
                              Text(
                                record.mood,
                                style: GoogleFonts.inter(color: Colors.white70),
                              ),
                            ),
                            DataCell(
                              Text(
                                record.location,
                                style: GoogleFonts.inter(color: Colors.white70),
                              ),
                            ),
                            DataCell(
                              Text(
                                record.reflection,
                                style: GoogleFonts.inter(color: Colors.white70),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    historyData.map((record) {
                      int index = historyData.indexOf(record);
                      return Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: index == 0 ? Colors.blue : Colors.white38,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      );
    },
  );
}
