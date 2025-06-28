import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class FinishHabitPieChart extends StatelessWidget {
  const FinishHabitPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    final moods = [
      {'label': 'Feliz', 'value': 10, 'color': Colors.green},
      {'label': 'Neutro', 'value': 2, 'color': Colors.blue},
      {'label': 'Triste', 'value': 3, 'color': Colors.red},
    ];

    final total = moods.fold<int>(0, (sum, e) => sum + (e['value'] as int));

    return Column(
      children: [
        SizedBox(
          height: 250,
          child: PieChart(
            PieChartData(
              centerSpaceRadius: 60, // bonito donut
              sectionsSpace: 4,       // separação das fatias
              sections: moods.map((e) {
                final value = e['value'] as int;
                final percent = (value / total * 100).toStringAsFixed(0);
                return PieChartSectionData(
                  value: value.toDouble(),
                  color: e['color'] as Color,
                  radius: 80,
                  title: "$percent%",
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  borderSide: const BorderSide(color: Colors.black12, width: 2),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // legenda separada
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: moods.map((e) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: e['color'] as Color,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "${e['label']} (${e['value']})",
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            );
          }).toList(),
        ),

      ],
    );
  }
}
