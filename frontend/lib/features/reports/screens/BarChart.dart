import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ProgressBarChart extends StatelessWidget {
  const ProgressBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    final progressData = [
      {'name': 'correr as 10 hrs', 'parameter': 10},
      {'name': 'correr as 11 hrs', 'parameter': 20},
      {'name': 'correr as 12 hrs', 'parameter': 15},
    ];

    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barGroups: progressData.asMap().entries.map((e) {
            return BarChartGroupData(
              x: e.key,
              barRods: [
                BarChartRodData(
                  toY: (e.value['parameter'] as int).toDouble(),
                  color: Colors.blueAccent,
                  width: 20,
                  borderRadius: BorderRadius.circular(4),
                )
              ],
            );
          }).toList(),

          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < progressData.length) {
                    return Text(progressData[value.toInt()]['name'] as String);
                  }
                  return const Text('');
                },

              ),
            ),
          ),
        ),
      ),
    );
  }
}
