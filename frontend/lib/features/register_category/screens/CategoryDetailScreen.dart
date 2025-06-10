import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/category.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CategoryDetailScreen extends StatelessWidget {
  final Category category;

  const CategoryDetailScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121217),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        title: Text(
          'Perfil da categoria',
          style: GoogleFonts.inter(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ícone com fundo colorido no topo
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: category.color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: category.iconUrl.isNotEmpty
                      ? Image.network(
                          '${dotenv.env['API_URL']}${category.iconUrl}',
                          width: 64,
                          height: 64,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.category, color: category.color, size: 64),
                        )
                      : Icon(Icons.category, color: category.color, size: 64),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Nome da categoria
            Center(
              child: Text(
                category.name,
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Descrição da categoria
            Text(
              category.description,
              textAlign: TextAlign.justify,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
