import 'package:flutter/material.dart';
import '../services/list_categories_service.dart';
import '../model/CategoryModel.dart';

class SearchBarWidget extends StatefulWidget {
  final void Function(String)? onCategorySelected;

  const SearchBarWidget({Key? key, this.onCategorySelected}) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final FocusNode _focusNode = FocusNode();
  bool _showIcon = false;
  List<Category> _categories = [];
  bool _isLoadingCategories = false;

  Future<void> _loadCategories() async {
    setState(() {
      _isLoadingCategories = true;
    });

    final fetched = await CategoryService.fetchNotArchivedCategories();

    setState(() {
      _categories = fetched;
      _isLoadingCategories = false;
    });

    _showCategoryFilterModal();
  }

  void _showCategoryFilterModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F222A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (context) => SizedBox(
            height: 300,
            child:
                _isLoadingCategories
                    ? const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                    : _categories.isEmpty
                    ? const Center(
                      child: Text(
                        'Nenhuma categoria encontrada.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                    : ListView.builder(
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        return ListTile(
                          leading: const Icon(Icons.label, color: Colors.white),
                          title: Text(
                            category.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            if (widget.onCategorySelected != null) {
                              widget.onCategorySelected!(category.name);
                            }
                          },
                        );
                      },
                    ),
          ),
    );
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _showIcon = _focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            focusNode: _focusNode,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Pesquisar...',
              hintStyle: const TextStyle(color: Colors.white70),
              prefixIcon:
                  _showIcon
                      ? const Icon(Icons.search, color: Colors.white70)
                      : null,
              filled: true,
              fillColor: Colors.grey[800],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Ink(
          decoration: ShapeDecoration(
            color: Colors.grey[800],
            shape: const CircleBorder(),
          ),
          child: IconButton(
            icon: const Icon(Icons.category),
            color: Colors.white,
            onPressed: _loadCategories,
            tooltip: 'Em breve',
          ),
        ),
      ],
    );
  }
}
