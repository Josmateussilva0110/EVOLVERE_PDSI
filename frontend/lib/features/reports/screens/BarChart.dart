import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../service/reports_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressBarChart extends StatefulWidget {
  const ProgressBarChart({super.key});

  @override
  State<ProgressBarChart> createState() => _ProgressBarChartState();
}

class _ProgressBarChartState extends State<ProgressBarChart> {
  List<Map<String, dynamic>> _progressData = [];
  bool _loading = true;
  int? _userId;

  final HabitService _habitService = HabitService();

  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('loggedInUserId');
    if (userId != null) {
      setState(() {
        _userId = userId;
      });
      await loadProgressData();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> loadProgressData() async {
    final data = await _habitService.fetchBarGraph(_userId!);
    setState(() {
      _progressData = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_progressData.isEmpty) {
      return const Center(
        child: Text(
          "Nenhum dado encontrado",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return SizedBox(
      height: 300,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final barWidth = constraints.maxWidth / (_progressData.length * 2);

          return Stack(
            children: [
              BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceBetween,
                  maxY: (_maxValue() * 1.2).ceilToDouble(),
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${_progressData[groupIndex]['label']}\n${rod.toY.toInt()}',
                          const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ),
                  barGroups: _progressData.asMap().entries.map((e) {
                    return BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                          toY: (e.value['value'] as int).toDouble(),
                          gradient: const LinearGradient(
                            colors: [Colors.blueAccent, Colors.cyan],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          width: barWidth,
                          borderRadius: BorderRadius.circular(4),
                        )
                      ],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(color: Colors.white, fontSize: 10),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx >= 0 && idx < _progressData.length) {
                          return Text(
                            _progressData[idx]['label'] as String,
                            style: const TextStyle(fontSize: 10, color: Colors.white),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),

                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.white.withOpacity(0.1),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                ),
                swapAnimationDuration: const Duration(milliseconds: 800),
                swapAnimationCurve: Curves.easeOutQuart,
              ),

              
            ],
          );
        },
      ),
    );
  }

  int _maxValue() {
    if (_progressData.isEmpty) return 1;
    return _progressData
        .map((e) => e['value'] as int)
        .reduce((a, b) => a > b ? a : b);
  }
}
