import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121217),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Configurações',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configurações Pessoais',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(color: Colors.grey[700]),
            ListTile(
              leading: Icon(Icons.lock, color: Colors.blueAccent),
              title: Text(
                'Alterar Senha',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onTap: () {
                // TODO: Navegar para a tela de Alterar Senha
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Tela de Alterar Senha em desenvolvimento.'),
                  ),
                );
              },
            ),
            Divider(color: Colors.grey[700]),
            const SizedBox(height: 30),
            // Exemplo de outras seções de configurações
            Text(
              'Configurações do Aplicativo',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            ListTile(
              leading: Icon(Icons.notifications, color: Colors.blueAccent),
              title: Text(
                'Notificações',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onTap: () {
                // TODO: Navegar para a tela de Notificações detalhadas
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Gerenciar preferências de notificações.'),
                  ),
                );
              },
            ),
            Divider(color: Colors.grey[700]),
          ],
        ),
      ),
    );
  }
}
