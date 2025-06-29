import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'goal_settings_screen.dart';
import '../../listHabits/widgets/stat_card.dart';
import '../../listHabits/widgets/period_chip.dart';
import '../../listHabits/widgets/chart_type_icon.dart';
import 'goal_history_screen.dart';

class ProgressRecordScreen extends StatefulWidget {
  final int habitId;
  final String habitName;
  final String category;
  final int totalMinutes;
  final String dailyAverage;
  final String currentStreak;
  final String monthDays;
  final double progressPercent;
  final List<int> weeklyData;

  const ProgressRecordScreen({
    Key? key,
    required this.habitId,
    required this.habitName,
    required this.category,
    required this.totalMinutes,
    required this.dailyAverage,
    required this.currentStreak,
    required this.monthDays,
    required this.progressPercent,
    required this.weeklyData,
  }) : super(key: key);

  @override
  State<ProgressRecordScreen> createState() => _ProgressRecordScreenState();
}

class _ProgressRecordScreenState extends State<ProgressRecordScreen> {
  int _selectedPeriod = 0; // 0: Semana, 1: Mês, 2: Trimestre
  int _selectedChart = 0; // 0: Linha, 1: Barras, 2: Área
  late List<int> _chartData;

  @override
  void initState() {
    super.initState();
    _chartData = widget.weeklyData;
  }

  void _changePeriod(int period) {
    setState(() {
      _selectedPeriod = period;
      if (period == 0) {
        _chartData = widget.weeklyData;
      } else if (period == 1) {
        _chartData = [
          2,
          3,
          4,
          5,
          3,
          2,
          4,
          5,
          6,
          4,
          3,
          2,
          1,
          2,
          3,
          4,
          5,
          6,
          5,
          4,
          3,
          2,
          1,
          2,
          3,
          4,
          5,
          6,
          5,
          4,
        ];
      } else {
        _chartData = [10, 12, 14, 13, 15, 16, 18, 17, 19, 20, 18, 17];
      }
    });
  }

  void _changeChart(int chart) {
    setState(() {
      _selectedChart = chart;
    });
  }

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.sizeOf(context).width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF10182B),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/listar_habitos',
                (route) => false,
              );
            },
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.habitName,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                widget.category,
                style: GoogleFonts.inter(
                  color: Colors.blue[200],
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Painel de Progresso
              Container(
                width: largura * 0.9,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Painel de Progresso',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${(widget.progressPercent * 100).toInt()}%',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: widget.progressPercent,
                      minHeight: 10,
                      backgroundColor: Colors.white12,
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              StatCard(
                                icon: Icons.timer,
                                label: 'Tempo Total',
                                value: '${widget.totalMinutes} min',
                                color: Colors.blueAccent,
                              ),
                              const SizedBox(height: 12),
                              StatCard(
                                icon: Icons.trending_up,
                                label: 'Sequência Atual',
                                value: widget.currentStreak,
                                color: Colors.orangeAccent,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            children: [
                              StatCard(
                                icon: Icons.av_timer,
                                label: 'Média diária',
                                value: widget.dailyAverage,
                                color: Colors.greenAccent,
                              ),
                              const SizedBox(height: 12),
                              StatCard(
                                icon: Icons.calendar_today,
                                label: 'Dias consecutivos',
                                value: widget.monthDays,
                                color: Colors.purpleAccent,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Análise Profunda
              Container(
                width: largura * 0.9,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF232B3E), Color(0xFF1B2236)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Análise Profunda',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        PeriodChip(
                          label: 'Semana',
                          selected: _selectedPeriod == 0,
                          onTap: () => _changePeriod(0),
                        ),
                        PeriodChip(
                          label: 'Mês',
                          selected: _selectedPeriod == 1,
                          onTap: () => _changePeriod(1),
                        ),
                        PeriodChip(
                          label: 'Trimestre',
                          selected: _selectedPeriod == 2,
                          onTap: () => _changePeriod(2),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ChartTypeIcon(
                            icon: Icons.show_chart,
                            label: 'Linha',
                            selected: _selectedChart == 0,
                            onTap: () => _changeChart(0),
                          ),
                        ),
                        Expanded(
                          child: ChartTypeIcon(
                            icon: Icons.bar_chart,
                            label: 'Barras',
                            selected: _selectedChart == 1,
                            onTap: () => _changeChart(1),
                          ),
                        ),
                        Expanded(
                          child: ChartTypeIcon(
                            icon: Icons.area_chart,
                            label: 'Área',
                            selected: _selectedChart == 2,
                            onTap: () => _changeChart(2),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),
                    SizedBox(
                      height: 200,
                      child:
                          _selectedChart == 0
                              ? _buildLineChart()
                              : _selectedChart == 1
                              ? _buildBarChart()
                              : _buildAreaChart(),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        SizedBox(
                          width: largura * 0.9,
                          child: TextButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => GoalSettingsScreen(widget.habitId),
                                ),
                              );
                            },
                            icon: const Icon(Icons.tune, color: Colors.white),
                            label: Text(
                              'Configurar Metas',
                              style: GoogleFonts.inter(color: Colors.white),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white12,
                              padding: EdgeInsets.symmetric(
                                horizontal: largura * 0.05,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: largura * 0.9,
                          child: TextButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => GoalHistoryScreen(
                                        habitId: widget.habitId,
                                      ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.history,
                              color: Colors.white,
                            ),
                            label: Text(
                              'Visualizar histórico',
                              style: GoogleFonts.inter(color: Colors.white),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue.withOpacity(0.12),
                              padding: EdgeInsets.symmetric(
                                horizontal: largura * 0.05,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget:
                  (value, meta) => Text(
                    value.toInt().toString(),
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (_selectedPeriod == 0) {
                  const days = [
                    'Seg',
                    'Ter',
                    'Qua',
                    'Qui',
                    'Sex',
                    'Sáb',
                    'Dom',
                  ];
                  if (value % 1 == 0 && value >= 0 && value < days.length) {
                    return Text(
                      days[value.toInt()],
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                } else if (_selectedPeriod == 1) {
                  if (value % 5 == 0 && value >= 0 && value < 30) {
                    return Text(
                      '${value.toInt() + 1}',
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                } else {
                  if (value % 2 == 0 && value >= 0 && value < 12) {
                    return Text(
                      'S${(value ~/ 1) + 1}',
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }
              },
              reservedSize: 28,
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.white24, width: 1),
        ),
        minX: 0,
        maxX: (_chartData.length - 1).toDouble(),
        minY: 0,
        maxY:
            (_chartData.isNotEmpty
                ? (_chartData.reduce((a, b) => a > b ? a : b) + 1).toDouble()
                : 5),
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (int i = 0; i < _chartData.length; i++)
                FlSpot(i.toDouble(), _chartData[i].toDouble()),
            ],
            isCurved: true,
            color: Colors.blueAccent,
            barWidth: 4,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blueAccent.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        gridData: FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget:
                  (value, meta) => Text(
                    value.toInt().toString(),
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (_selectedPeriod == 0) {
                  const days = [
                    'Seg',
                    'Ter',
                    'Qua',
                    'Qui',
                    'Sex',
                    'Sáb',
                    'Dom',
                  ];
                  if (value % 1 == 0 && value >= 0 && value < days.length) {
                    return Text(
                      days[value.toInt()],
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                } else if (_selectedPeriod == 1) {
                  if (value % 5 == 0 && value >= 0 && value < 30) {
                    return Text(
                      '${value.toInt() + 1}',
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                } else {
                  if (value % 2 == 0 && value >= 0 && value < 12) {
                    return Text(
                      'S${(value ~/ 1) + 1}',
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }
              },
              reservedSize: 28,
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.white24, width: 1),
        ),
        minY: 0,
        maxY:
            (_chartData.isNotEmpty
                ? (_chartData.reduce((a, b) => a > b ? a : b) + 1).toDouble()
                : 5),
        barGroups: [
          for (int i = 0; i < _chartData.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: _chartData[i].toDouble(),
                  color: Colors.blueAccent,
                  width: 12,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildAreaChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget:
                  (value, meta) => Text(
                    value.toInt().toString(),
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (_selectedPeriod == 0) {
                  const days = [
                    'Seg',
                    'Ter',
                    'Qua',
                    'Qui',
                    'Sex',
                    'Sáb',
                    'Dom',
                  ];
                  if (value % 1 == 0 && value >= 0 && value < days.length) {
                    return Text(
                      days[value.toInt()],
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                } else if (_selectedPeriod == 1) {
                  if (value % 5 == 0 && value >= 0 && value < 30) {
                    return Text(
                      '${value.toInt() + 1}',
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                } else {
                  if (value % 2 == 0 && value >= 0 && value < 12) {
                    return Text(
                      'S${(value ~/ 1) + 1}',
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }
              },
              reservedSize: 28,
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.white24, width: 1),
        ),
        minX: 0,
        maxX: (_chartData.length - 1).toDouble(),
        minY: 0,
        maxY:
            (_chartData.isNotEmpty
                ? (_chartData.reduce((a, b) => a > b ? a : b) + 1).toDouble()
                : 5),
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (int i = 0; i < _chartData.length; i++)
                FlSpot(i.toDouble(), _chartData[i].toDouble()),
            ],
            isCurved: true,
            color: Colors.blueAccent,
            barWidth: 4,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blueAccent.withOpacity(0.35),
            ),
          ),
        ],
      ),
    );
  }
}
