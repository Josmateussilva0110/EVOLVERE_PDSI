import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:flutter/gestures.dart';

class FilterChipsWidget extends StatefulWidget {
  final void Function(String)? onFilterChanged;
  final String? selectedFilter;
  final Map<String, int>? filterCounts;

  const FilterChipsWidget({
    Key? key,
    this.onFilterChanged,
    this.selectedFilter,
    this.filterCounts,
  }) : super(key: key);

  @override
  State<FilterChipsWidget> createState() => _FilterChipsWidgetState();
}

class _FilterChipsWidgetState extends State<FilterChipsWidget> {
  final ScrollController _scrollController = ScrollController();
  double _dragStartPosition = 0.0;

  final List<FilterOption> filters = [
    FilterOption(label: 'Todos', icon: Icons.all_inclusive, color: Colors.blue),
    FilterOption(label: 'Alta', icon: Icons.priority_high, color: Colors.red),
    FilterOption(label: 'Normal', icon: Icons.remove, color: Colors.orange),
    FilterOption(
      label: 'Baixa',
      icon: Icons.keyboard_arrow_down,
      color: Colors.green,
    ),
    FilterOption(label: 'Diário', icon: Icons.today, color: Colors.purple),
    FilterOption(label: 'Semanal', icon: Icons.view_week, color: Colors.teal),
    FilterOption(
      label: 'Mensal',
      icon: Icons.calendar_month,
      color: Colors.indigo,
    ),
    FilterOption(
      label: 'Anual',
      icon: Icons.calendar_view_month,
      color: Colors.deepPurple,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 700;
    final isWide = screenWidth > 500;
    final isVerySmall = screenWidth < 350;
    final chipPadding =
        isTablet
            ? EdgeInsets.symmetric(horizontal: 28, vertical: 18)
            : isWide
            ? EdgeInsets.symmetric(horizontal: 20, vertical: 14)
            : isVerySmall
            ? EdgeInsets.symmetric(horizontal: 8, vertical: 4)
            : EdgeInsets.symmetric(horizontal: 16, vertical: 10);
    final chipFont =
        isTablet
            ? 20.0
            : isWide
            ? 16.0
            : isVerySmall
            ? 10.0
            : 14.0;
    final chipIcon =
        isTablet
            ? 26.0
            : isWide
            ? 20.0
            : isVerySmall
            ? 11.0
            : 16.0;
    final chipSpacing =
        isTablet
            ? 24.0
            : isWide
            ? 16.0
            : isVerySmall
            ? 6.0
            : 12.0;
    final chipBorder =
        isTablet
            ? 32.0
            : isWide
            ? 28.0
            : isVerySmall
            ? 14.0
            : 25.0;
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: EdgeInsets.symmetric(
        horizontal:
            isTablet
                ? 32
                : isWide
                ? 24
                : 16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children:
            filters.map((filter) {
              final isSelected = widget.selectedFilter == filter.label;
              final count = widget.filterCounts?[filter.label] ?? 0;
              return Padding(
                padding: EdgeInsets.only(right: chipSpacing),
                child: _buildFilterChip(
                  filter,
                  isSelected,
                  count,
                  chipPadding,
                  chipFont,
                  chipIcon,
                  chipBorder,
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildFilterChip(
    FilterOption filter,
    bool isSelected,
    int count,
    EdgeInsets chipPadding,
    double chipFont,
    double chipIcon,
    double chipBorder,
  ) {
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (filter.icon != null)
            Icon(
              filter.icon,
              size: chipIcon,
              color: isSelected ? Colors.blue : Colors.white70,
            ),
          if (filter.icon != null) SizedBox(width: 6),
          Text(
            filter.label,
            style: GoogleFonts.inter(
              fontSize: chipFont,
              color: isSelected ? Colors.blue : Colors.white70,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              letterSpacing: 0.1,
            ),
          ),
          if (count > 0) ...[
            SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color:
                    isSelected ? Colors.blue.withOpacity(0.15) : Colors.white12,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                count.toString(),
                style: GoogleFonts.inter(
                  fontSize: chipFont * 0.85,
                  color: isSelected ? Colors.blue : Colors.white54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
      selected: isSelected,
      backgroundColor: Colors.white.withOpacity(0.04),
      selectedColor: Colors.blue.withOpacity(0.10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(chipBorder),
        side: BorderSide(
          color: isSelected ? Colors.blue : Colors.white24,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      visualDensity: VisualDensity.compact,
      onSelected: (selected) {
        if (selected) widget.onFilterChanged!(filter.label);
      },
    );
  }
}

class FilterOption {
  final String label;
  final IconData icon;
  final Color color;

  FilterOption({required this.label, required this.icon, required this.color});
}
