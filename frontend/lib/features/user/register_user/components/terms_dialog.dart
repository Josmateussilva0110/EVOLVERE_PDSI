import 'package:flutter/material.dart';

class TermsDialog extends StatelessWidget {
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
                    'Termos e Condições',
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
                      '1. Aceitação dos Termos',
                      'Ao acessar e usar este aplicativo, você concorda em cumprir estes termos e condições. Se você não concordar com qualquer parte destes termos, não poderá acessar o aplicativo.',
                      theme,
                    ),
                    _buildSection(
                      '2. Uso do Aplicativo',
                      'O aplicativo é destinado apenas para uso pessoal. Você concorda em não usar o aplicativo para qualquer propósito ilegal ou não autorizado.',
                      theme,
                    ),
                    _buildSection(
                      '3. Privacidade',
                      'Sua privacidade é importante para nós. Nossa política de privacidade explica como coletamos, usamos e protegemos suas informações pessoais.',
                      theme,
                    ),
                    _buildSection(
                      '4. Responsabilidades',
                      'Você é responsável por manter a confidencialidade de sua conta e senha. Você concorda em aceitar a responsabilidade por todas as atividades que ocorram em sua conta.',
                      theme,
                    ),
                    _buildSection(
                      '5. Modificações',
                      'Reservamo-nos o direito de modificar estes termos a qualquer momento. As modificações entram em vigor imediatamente após sua publicação no aplicativo.',
                      theme,
                    ),
                    _buildSection(
                      '6. Limitação de Responsabilidade',
                      'O aplicativo é fornecido "como está", sem garantias de qualquer tipo. Não nos responsabilizamos por quaisquer danos decorrentes do uso do aplicativo.',
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
