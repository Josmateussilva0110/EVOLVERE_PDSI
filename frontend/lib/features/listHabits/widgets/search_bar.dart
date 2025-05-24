import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({Key? key}) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final FocusNode _focusNode = FocusNode();
  bool _showIcon = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _showIcon = _focusNode.hasFocus;
      });
    });
  }

  void _openCategoryFilter() {
    // TODO: abrir um modal, bottom sheet ou navegar para tela de filtro
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F222A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SizedBox(
        height: 250,
        child: Center(
          child: Text(
            'Filtro por categoria em breve',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
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
              prefixIcon: _showIcon ? const Icon(Icons.search, color: Colors.white70) : null,
              filled: true,
              fillColor: Colors.grey[800],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
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
            onPressed: _openCategoryFilter,
            tooltip: 'Em breve',
          ),
        ),
      ],
    );
  }
}
