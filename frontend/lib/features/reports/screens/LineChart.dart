import 'package:flutter/material.dart';
import '../service/reports_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FrequencyProgressChart extends StatefulWidget {
  const FrequencyProgressChart({super.key});

  @override
  State<FrequencyProgressChart> createState() => _FrequencyProgressChartState();
}

class _FrequencyProgressChartState extends State<FrequencyProgressChart> {
  final HabitService _habitService = HabitService();
  Map<String, int> data = {};
  bool isLoading = true;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('loggedInUserId');
    if (userId != null) {
      setState(() {
        _userId = userId;
      });
      await _loadFrequencyGraph();
    }
  }

  Future<void> _loadFrequencyGraph() async {
    final result = await _habitService.fetchFrequencyGraph(_userId!);

    Map<String, int> formatted = {
      for (var item in result)
        item['option'] ?? 'desconhecido': item['value'] ?? 0
    };

    setState(() {
      data = formatted;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (data.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum dado encontrado',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    final maxValue = data.values.reduce((a, b) => a > b ? a : b).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.entries.map((entry) {
        final percent = entry.value / maxValue;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.key,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Stack(
                children: [
                  Container(
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade700.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: percent,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                      height: 20,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF42A5F5),
                            Color(0xFF64B5F6),
                            Color(0xFF90CAF9),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "${entry.value}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                blurRadius: 2,
                                offset: Offset(0.5, 0.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
