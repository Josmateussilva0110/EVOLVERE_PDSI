import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/list_categories_service.dart';
import '../models/CategoryModel.dart';

class SearchBarWidget extends StatefulWidget {
  final void Function(String?)? onCategorySelected;
  final void Function(String)? onSearchChanged;
  final String? selectedCategory;

  const SearchBarWidget({
    Key? key,
    this.onCategorySelected,
    this.onSearchChanged,
    this.selectedCategory,
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<Category> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await CategoryService.fetchNotArchivedCategories();
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;
    final isVerySmallScreen = screenHeight < 600;
    final isNarrowScreen = screenWidth < 400;

    return Column(
      children: [
        // Barra de busca principal
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              if (widget.onSearchChanged != null) {
                widget.onSearchChanged!(value);
              }
            },
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: isSmallScreen ? 14 : 16,
            ),
            decoration: InputDecoration(
              hintText: 'Buscar hábitos...',
              hintStyle: GoogleFonts.inter(
                color: Colors.white54,
                fontSize: isSmallScreen ? 14 : 16,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white54,
                size: isSmallScreen ? 20 : 24,
              ),
              suffixIcon:
                  _searchController.text.isNotEmpty
                      ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.white54,
                          size: isSmallScreen ? 18 : 20,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          if (widget.onSearchChanged != null) {
                            widget.onSearchChanged!('');
                          }
                        },
                      )
                      : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16 : 20,
                vertical: isSmallScreen ? 12 : 16,
              ),
            ),
          ),
        ),

        SizedBox(height: isSmallScreen ? 8 : 12),

        // Para telas muito pequenas, mostrar seletor de categoria em linha separada
        if (isVerySmallScreen && isNarrowScreen)
          Container(
            margin: const EdgeInsets.only(top: 8),
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child:
                _isLoading
                    ? Center(
                      child: SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blue.withOpacity(0.8),
                          ),
                        ),
                      ),
                    )
                    : DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: widget.selectedCategory,
                        hint: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.category,
                                color: Colors.white54,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Categoria',
                                style: GoogleFonts.inter(
                                  color: Colors.white54,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white54,
                          size: 16,
                        ),
                        dropdownColor: const Color(0xFF1F222A),
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                        items: [
                          DropdownMenuItem<String>(
                            value: null,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.all_inclusive,
                                    color: Colors.blue,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Todas',
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Sem categoria',
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.not_interested,
                                    color: Colors.grey,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Sem categoria',
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ..._categories.map((category) {
                            return DropdownMenuItem<String>(
                              value: category.name,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: category.getColor(),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        category.name,
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 11,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                        onChanged: (value) {
                          if (widget.onCategorySelected != null) {
                            widget.onCategorySelected!(value);
                          }
                        },
                      ),
                    ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
