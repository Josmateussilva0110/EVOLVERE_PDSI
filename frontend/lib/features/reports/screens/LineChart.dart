import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';


class HabitFrequencyLineChart extends StatelessWidget {
  const HabitFrequencyLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    // exemplo fictício:
    final freqData = [
      {'day': 1, 'count': 2},
      {'day': 5, 'count': 5},
      {'day': 10, 'count': 3},
      {'day': 15, 'count': 4},
      {'day': 20, 'count': 6},
    ];

    return SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              color: Colors.orangeAccent,
              spots: freqData
                  .map((e) => FlSpot(
                        e['day']!.toDouble(),
                        e['count']!.toDouble(),
                      ))
                  .toList(),
              dotData: FlDotData(show: true),
            ),
          ],
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
          ),
        ),
      ),
    );
  }
}
