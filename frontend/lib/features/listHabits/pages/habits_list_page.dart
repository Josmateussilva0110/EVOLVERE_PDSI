import 'package:flutter/material.dart';
import '../widgets/filter_chips.dart';
import '../widgets/search_bar.dart';

class HabitsListPage extends StatelessWidget {
  const HabitsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: const Text('Hábitos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FilterChipsWidget(),
            const SizedBox(height: 12),
            const SearchBarWidget(),
            const SizedBox(height: 16),
            // Aqui futuramente virá a lista de hábitos (luquinhas)
            Expanded(
              child: Center(
                child: Text(
                  'Nenhum hábito cadastrado ainda.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        height: 56,
        child: FloatingActionButton.extended(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text('Novo Hábito'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
