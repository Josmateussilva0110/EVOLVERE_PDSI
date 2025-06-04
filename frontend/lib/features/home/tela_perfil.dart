import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(home: TelaPerfil(), debugShowCheckedModeBanner: false),
  );
}

class TelaPerfil extends StatelessWidget {
  const TelaPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121217), // Cor de fundo padrão do app
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Icon(Icons.settings, color: Colors.white),
              onPressed: () => _mostrarOpcoesPerfil(context),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 2),
              const CircleAvatar(
                radius: 70, // Aumente este valor para um círculo maior (era 40)
                backgroundColor: Color(0xFF2C2C2C),
                child: Icon(
                  Icons.person,
                  size: 100, // Aumente este valor para um ícone maior (era 40)
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Gabriel",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Gabriel@email.com",
                style: TextStyle(color: Color(0xFFFFBE47)),
              ),
              const Text(
                "Desde abril de 2024",
                style: TextStyle(color: Color(0xFFFFBE47)), // Cor accent padrão
              ),
              const SizedBox(height: 30),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 1.2,
                  children: const [
                    CardInfo(
                      title: "Dias Seguidos Ativos",
                      value: "0",
                      icon: Icons.calendar_today,
                      iconColor: Color(0xFF00B2FF), // Azul claro
                    ),
                    CardInfo(
                      title: "Total de XP",
                      value: "482",
                      icon: Icons.bolt,
                      iconColor: Color(0xFFFFBE47), // Amarelo
                    ),
                    CardInfo(
                      title: "Hábitos Concluídos Hoje",
                      value: "3",
                      icon: Icons.check_circle_outline,
                      iconColor: Color(0xFF00B2FF), // Azul claro
                    ),
                    CardInfo(
                      title: "Hábitos Ativos",
                      value: "5",
                      icon: Icons.grid_view,
                      iconColor: Color(0xFF00B2FF), // Azul claro
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarOpcoesPerfil(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          color: const Color(0xFF1C1F26), // Cor de fundo do modal
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.edit, color: Colors.white),
                title: Text(
                  'Editar Perfil',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => {},
              ),
            ],
          ),
        );
      },
    );
  }
}

class CardInfo extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;
  final Color iconColor;

  const CardInfo({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1F26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3B4254)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ícone e número na mesma linha
          Row(
            children: [
              if (icon != null) Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 8),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Título abaixo
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
