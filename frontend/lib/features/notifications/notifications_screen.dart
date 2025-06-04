import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E), // Cor de fundo escura
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0, // Alinhar o título à esquerda
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // Mudar a cor dos ícones da AppBar para branco
        title: const Text(
          'Notificações',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Ação para ler todas as notificações
            },
            child: const Text(
              'Ler todas',
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Seção Hoje
            const Text(
              'Hoje',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildNotificationItem(
              'Sequência de hábito alcançada',
              'Você está indo bem! Continue, cada passo conta.',
              '17:30',
              // Sem ícone na imagem para este item
            ),
            _buildNotificationItem(
              'Tarefa concluída',
              'Ótimo trabalho! Fique focado para ganhar pontos bônus.',
              '08:30',
              // Sem ícone na imagem para este item
            ),
            const SizedBox(height: 20),

            // Seção Anterior
            const Text(
              'Anterior',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildNotificationItem(
              'Novas tarefas desbloqueadas',
              'Engaje-se com novos desafios para impulsionar seu progresso.',
              'Ontem',
              icon: Icons.calendar_today,
            ),
            _buildNotificationItem(
              'Progresso da conquista atualizado',
              'Conclua uma tarefa para manter sua conquista.',
              'Ontem',
              icon: Icons.emoji_events, // Ícone de troféu
            ),
            _buildNotificationItem(
              'Hábito concluído',
              'Excelente trabalho em manter a disciplina, continue assim!',
              '2 dias atrás',
              // Sem ícone na imagem para este item
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Ação para definir lembrete
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text(
            'Definir Lembrete',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ), // Mudar a cor do texto para branco
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem(
    String title,
    String subtitle,
    String time, {
    IconData? icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C), // Cor de fundo do card
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[700],
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
          ] else ...[
            // Placeholder circular escuro similar ao da imagem para itens sem ícone
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[700],
              child: Container(), // Container vazio para simular o círculo
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 14.0),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(color: Colors.white54, fontSize: 12.0),
          ),
        ],
      ),
    );
  }
}
