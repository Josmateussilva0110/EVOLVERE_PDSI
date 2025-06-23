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
      return _HistoryContent(historyData: historyData);
    },
  );
}

class _HistoryContent extends StatefulWidget {
  final List<HistoryRecord> historyData;
  const _HistoryContent({required this.historyData});

  @override
  State<_HistoryContent> createState() => _HistoryContentState();
}

class _HistoryContentState extends State<_HistoryContent> {
  String search = '';
  String statusFilter = 'Todos';
  String diffFilter = 'Todos';
  String moodFilter = 'Todos';
  String periodFilter = 'Todos';
  int? expandedIndex;

  List<HistoryRecord> get filteredData {
    return widget.historyData.where((h) {
      final matchesSearch =
          search.isEmpty ||
          h.reflection.toLowerCase().contains(search.toLowerCase()) ||
          h.location.toLowerCase().contains(search.toLowerCase());
      final matchesStatus = statusFilter == 'Todos' || h.status == statusFilter;
      final matchesDiff = diffFilter == 'Todos' || h.difficulty == diffFilter;
      final matchesMood = moodFilter == 'Todos' || h.mood == moodFilter;
      // periodFilter pode ser expandido para datas reais
      return matchesSearch && matchesStatus && matchesDiff && matchesMood;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    int feitos = filteredData.where((h) => h.status == 'Feito').length;
    int falhas = filteredData.where((h) => h.status == 'Falhou').length;
    int total = filteredData.length;
    int andamento =
        filteredData.where((h) => h.status == 'Em andamento').length;
    String humorMaisFrequente = _humorMaisFrequente(filteredData);

    return Container(
      height: MediaQuery.sizeOf(context).height * 0.85,
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
          const SizedBox(height: 10),
          // Resumo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _summaryCard('Feitos', feitos, Colors.greenAccent),
              _summaryCard('Falhas', falhas, Colors.redAccent),
              _summaryCard('Em andamento', andamento, Colors.orangeAccent),
              _summaryCard('Total', total, Colors.blueAccent),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.emoji_emotions, color: Colors.yellow, size: 18),
              const SizedBox(width: 4),
              Text(
                'Humor mais frequente: ',
                style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
              ),
              Text(
                humorMaisFrequente,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Busca
          TextField(
            style: GoogleFonts.inter(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Buscar por reflexão ou local...',
              hintStyle: GoogleFonts.inter(color: Colors.white38),
              filled: true,
              fillColor: const Color(0xFF181F2B),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.search, color: Colors.white38),
            ),
            onChanged: (v) => setState(() => search = v),
          ),
          const SizedBox(height: 10),
          // Filtros
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterChip(
                  'Todos',
                  statusFilter == 'Todos',
                  () => setState(() => statusFilter = 'Todos'),
                ),
                _filterChip(
                  'Feito',
                  statusFilter == 'Feito',
                  () => setState(() => statusFilter = 'Feito'),
                ),
                _filterChip(
                  'Falhou',
                  statusFilter == 'Falhou',
                  () => setState(() => statusFilter = 'Falhou'),
                ),
                _filterChip(
                  'Em andamento',
                  statusFilter == 'Em andamento',
                  () => setState(() => statusFilter = 'Em andamento'),
                ),
                const SizedBox(width: 12),
                _filterChip(
                  'Fácil',
                  diffFilter == 'Fácil',
                  () => setState(
                    () =>
                        diffFilter = diffFilter == 'Fácil' ? 'Todos' : 'Fácil',
                  ),
                ),
                _filterChip(
                  'Médio',
                  diffFilter == 'Médio',
                  () => setState(
                    () =>
                        diffFilter = diffFilter == 'Médio' ? 'Todos' : 'Médio',
                  ),
                ),
                _filterChip(
                  'Difícil',
                  diffFilter == 'Difícil',
                  () => setState(
                    () =>
                        diffFilter =
                            diffFilter == 'Difícil' ? 'Todos' : 'Difícil',
                  ),
                ),
                const SizedBox(width: 12),
                _filterChip(
                  'Feliz',
                  moodFilter == 'Feliz',
                  () => setState(
                    () =>
                        moodFilter = moodFilter == 'Feliz' ? 'Todos' : 'Feliz',
                  ),
                ),
                _filterChip(
                  'Neutro',
                  moodFilter == 'Neutro',
                  () => setState(
                    () =>
                        moodFilter =
                            moodFilter == 'Neutro' ? 'Todos' : 'Neutro',
                  ),
                ),
                _filterChip(
                  'Motivado',
                  moodFilter == 'Motivado',
                  () => setState(
                    () =>
                        moodFilter =
                            moodFilter == 'Motivado' ? 'Todos' : 'Motivado',
                  ),
                ),
                _filterChip(
                  'Desanimado',
                  moodFilter == 'Desanimado',
                  () => setState(
                    () =>
                        moodFilter =
                            moodFilter == 'Desanimado' ? 'Todos' : 'Desanimado',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child:
                filteredData.isEmpty
                    ? Center(
                      child: Text(
                        'Nenhum registro encontrado.',
                        style: GoogleFonts.inter(color: Colors.white38),
                      ),
                    )
                    : ListView.separated(
                      itemCount: filteredData.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final record = filteredData[i];
                        Color statusColor;
                        IconData statusIcon;
                        switch (record.status) {
                          case 'Feito':
                            statusColor = Colors.greenAccent;
                            statusIcon = Icons.check_circle_outline;
                            break;
                          case 'Em andamento':
                            statusColor = Colors.orangeAccent;
                            statusIcon = Icons.timelapse;
                            break;
                          case 'Falhou':
                            statusColor = Colors.redAccent;
                            statusIcon = Icons.cancel_outlined;
                            break;
                          default:
                            statusColor = Colors.white;
                            statusIcon = Icons.info_outline;
                        }
                        String moodEmoji;
                        switch (record.mood) {
                          case 'Feliz':
                            moodEmoji = '😁';
                            break;
                          case 'Neutro':
                            moodEmoji = '😐';
                            break;
                          case 'Motivado':
                            moodEmoji = '💪';
                            break;
                          case 'Desanimado':
                            moodEmoji = '😩';
                            break;
                          default:
                            moodEmoji = '🙂';
                        }
                        String diffEmoji;
                        switch (record.difficulty) {
                          case 'Fácil':
                            diffEmoji = '😃';
                            break;
                          case 'Médio':
                            diffEmoji = '😐';
                            break;
                          case 'Difícil':
                            diffEmoji = '😣';
                            break;
                          default:
                            diffEmoji = '❓';
                        }
                        final isExpanded = expandedIndex == i;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            color: const Color(0xFF181F2B),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(statusIcon, color: statusColor, size: 28),
                                const SizedBox(height: 4),
                                Text(
                                  record.date,
                                  style: GoogleFonts.inter(
                                    color: Colors.white54,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            title: Row(
                              children: [
                                Text(
                                  diffEmoji,
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  record.difficulty,
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  moodEmoji,
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  record.mood,
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.place,
                                      color: Colors.blueAccent,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      record.location,
                                      style: GoogleFonts.inter(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                if (record.reflection.trim().isNotEmpty &&
                                    record.reflection != '-')
                                  AnimatedCrossFade(
                                    duration: const Duration(milliseconds: 250),
                                    crossFadeState:
                                        isExpanded
                                            ? CrossFadeState.showSecond
                                            : CrossFadeState.showFirst,
                                    firstChild: GestureDetector(
                                      onTap:
                                          () =>
                                              setState(() => expandedIndex = i),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                        ),
                                        child: Text(
                                          '“${record.reflection.length > 40 ? record.reflection.substring(0, 40) + '...' : record.reflection}”',
                                          style: GoogleFonts.inter(
                                            color: Colors.white70,
                                            fontSize: 13,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                    ),
                                    secondChild: GestureDetector(
                                      onTap:
                                          () => setState(
                                            () => expandedIndex = null,
                                          ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                        ),
                                        child: Text(
                                          '“${record.reflection}”',
                                          style: GoogleFonts.inter(
                                            color: Colors.white70,
                                            fontSize: 13,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            onTap:
                                () => setState(
                                  () => expandedIndex = isExpanded ? null : i,
                                ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.info_outline,
                                color: Colors.white38,
                              ),
                              onPressed:
                                  () => _showDetailModal(context, record),
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(String label, int value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value.toString(),
            style: GoogleFonts.inter(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, bool selected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color:
                selected ? Colors.blueAccent.withOpacity(0.18) : Colors.white10,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? Colors.blueAccent : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.inter(
              color: selected ? Colors.blueAccent : Colors.white70,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  String _humorMaisFrequente(List<HistoryRecord> data) {
    if (data.isEmpty) return '-';
    final Map<String, int> count = {};
    for (var h in data) {
      count[h.mood] = (count[h.mood] ?? 0) + 1;
    }
    return count.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  void _showDetailModal(BuildContext context, HistoryRecord record) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            backgroundColor: const Color(0xFF181F2B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Colors.blueAccent,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        record.date,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.flag, color: Colors.greenAccent, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        record.status,
                        style: GoogleFonts.inter(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        'Dificuldade: ',
                        style: GoogleFonts.inter(color: Colors.white70),
                      ),
                      Text(
                        record.difficulty,
                        style: GoogleFonts.inter(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Humor: ',
                        style: GoogleFonts.inter(color: Colors.white70),
                      ),
                      Text(
                        record.mood,
                        style: GoogleFonts.inter(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.place, color: Colors.blueAccent, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        record.location,
                        style: GoogleFonts.inter(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (record.reflection.trim().isNotEmpty &&
                      record.reflection != '-')
                    Text(
                      'Reflexão:',
                      style: GoogleFonts.inter(color: Colors.white70),
                    ),
                  if (record.reflection.trim().isNotEmpty &&
                      record.reflection != '-')
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        '“${record.reflection}”',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
    );
  }
}
