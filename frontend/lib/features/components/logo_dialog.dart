import 'package:flutter/material.dart';

class LogoDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: size.width,
        height: size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.grey[900]?.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sobre o EVOLVERE',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection(
                      'Nossa Missão',
                      'O EVOLVERE nasceu da necessidade de ajudar pessoas a desenvolverem hábitos saudáveis e sustentáveis em suas vidas. Acreditamos que pequenas mudanças diárias podem levar a grandes transformações.',
                      theme,
                    ),
                    _buildSection(
                      'Como Funciona',
                      'Nossa plataforma utiliza técnicas comprovadas de formação de hábitos, combinadas com um sistema de acompanhamento personalizado, para ajudar você a alcançar seus objetivos de forma gradual e sustentável.',
                      theme,
                    ),
                    _buildSection(
                      'Nossos Valores',
                      'Comprometimento com o bem-estar dos usuários, inovação constante e desenvolvimento sustentável são os pilares que guiam todas as nossas ações e decisões.',
                      theme,
                    ),
                    _buildSection(
                      'Junte-se a Nós',
                      'Faça parte dessa jornada de evolução pessoal. Comece hoje mesmo a transformar seus hábitos e alcance uma vida mais saudável e equilibrada.',
                      theme,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Entendi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
