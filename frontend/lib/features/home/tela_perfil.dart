import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  runApp(
    const MaterialApp(home: TelaPerfil(), debugShowCheckedModeBanner: false),
  );
}

class TelaPerfil extends StatefulWidget {
  const TelaPerfil({super.key});

  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  String? name;
  String? email;
  String? createdAt;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/user/profile/1'),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Parsed data: $data');
        setState(() {
          name = data['name'];
          email = data['email'];
          createdAt = data['createdAt'];
        });
      } else {
        throw Exception('Erro ao buscar perfil do usuário');
      }
    } catch (e) {
      print('Erro: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121217),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.settings, color: Colors.white),
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
                radius: 70,
                backgroundColor: Color(0xFF2C2C2C),
                child: Icon(Icons.person, size: 100, color: Colors.white),
              ),
              const SizedBox(height: 20),
              if (name != null)
                Text(
                  name!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (email != null)
                Text(email!, style: const TextStyle(color: Color(0xFFFFBE47))),
              if (createdAt != null)
                Text(
                  'Desde $createdAt',
                  style: const TextStyle(color: Color(0xFFFFBE47)),
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
                      iconColor: Color(0xFF00B2FF),
                    ),
                    CardInfo(
                      title: "Total de XP",
                      value: "482",
                      icon: Icons.bolt,
                      iconColor: Color(0xFFFFBE47),
                    ),
                    CardInfo(
                      title: "Hábitos Concluídos Hoje",
                      value: "3",
                      icon: Icons.check_circle_outline,
                      iconColor: Color(0xFF00B2FF),
                    ),
                    CardInfo(
                      title: "Hábitos Ativos",
                      value: "5",
                      icon: Icons.grid_view,
                      iconColor: Color(0xFF00B2FF),
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
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
