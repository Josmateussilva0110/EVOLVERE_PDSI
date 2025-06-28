import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../service/reports_service.dart'; // seu service que busca do Node

class FinishHabitPieChart extends StatefulWidget {
  const FinishHabitPieChart({super.key});

  @override
  State<FinishHabitPieChart> createState() => _FinishHabitPieChartState();
}

class _FinishHabitPieChartState extends State<FinishHabitPieChart> {
  List<Map<String, dynamic>> _moods = [];
  bool _loading = true;

  final HabitService _habitService = HabitService();

  @override
  void initState() {
    super.initState();
    loadMoods();
  }

  Future<void> loadMoods() async {
    final data = await _habitService.fetchPizzaGraph();

    // mapeia cores fixas
    final mapped =
        data.map((item) {
          Color color;
          switch (item['label']) {
            case 'Feliz':
              color = Colors.green;
              break;
            case 'Triste':
              color = Colors.red;
              break;
            case 'Neutro':
              color = Colors.blue;
              break;
            default:
              color = Colors.grey;
          }
          return {
            'label': item['label'],
            'value': item['value'],
            'color': color,
          };
        }).toList();

    setState(() {
      _moods = mapped;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_moods.isEmpty) {
      return const Center(child: Text('Nenhum dado encontrado'));
    }

    final total = _moods.fold<int>(0, (sum, e) => sum + (e['value'] as int));

    return Column(
      children: [
        SizedBox(
          height: 250,
          child: PieChart(
            PieChartData(
              centerSpaceRadius: 60,
              sectionsSpace: 4,
              sections:
                  _moods.map((e) {
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
                      borderSide: const BorderSide(
                        color: Colors.black12,
                        width: 2,
                      ),
                    );
                  }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // legenda
        Wrap(
          spacing: 12,
          children:
              _moods.map((e) {
                return Row(
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
                );
              }).toList(),
        ),
      ],
    );
  }
}
