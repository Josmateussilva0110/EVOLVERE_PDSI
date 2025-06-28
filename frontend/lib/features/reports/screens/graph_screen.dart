import 'package:flutter/material.dart';
import 'BarChart.dart';
import 'LineChart.dart';
import 'PieChart.dart';

class ChartsScreen extends StatelessWidget {
  const ChartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121217),
      appBar: AppBar(
        title: const Text('Relatórios'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // melhor alinhamento
          children: [
            const SizedBox(height: 16),
            const Text(
              "Progresso dos Hábitos",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const ProgressBarChart(),
            const SizedBox(height: 32),

            const Text(
              "Humor ao Finalizar Hábitos",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            const FinishHabitPieChart(),
            const SizedBox(height: 32),

            const Text(
              "Frequência de Hábitos",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const HabitFrequencyLineChart(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
