import 'package:flutter/material.dart';
//import 'package:flutter/gestures.dart';

class FilterChipsWidget extends StatefulWidget {
  const FilterChipsWidget({Key? key}) : super(key: key);

  @override
  State<FilterChipsWidget> createState() => _FilterChipsWidgetState();
}

class _FilterChipsWidgetState extends State<FilterChipsWidget> {
  final filters = ['Todos', 'Hoje', 'Semana', 'Mês', 'Anual'];
  int selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();
  double _dragStartPosition = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (details) {
        _dragStartPosition = details.localPosition.dx;
      },
      onHorizontalDragUpdate: (details) {
        _scrollController.jumpTo(
          _scrollController.offset -
              (details.localPosition.dx - _dragStartPosition),
        );
        _dragStartPosition = details.localPosition.dx;
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        child: Row(
          children: List.generate(filters.length, (i) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: SizedBox(
                width: 90,
                child: FilterChip(
                  label: Center(child: Text(filters[i])),
                  selected: selectedIndex == i,
                  onSelected: (_) {
                    setState(() {
                      selectedIndex = i;
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                    side: BorderSide(color: Colors.white.withOpacity(0.2)),
                  ),
                  backgroundColor: Colors.grey[800],
                  selectedColor: Colors.grey[700],
                  checkmarkColor: Colors.white,
                  labelStyle: const TextStyle(color: Colors.white),
                  labelPadding: const EdgeInsets.symmetric(horizontal: 0),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
