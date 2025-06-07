import 'package:flutter/material.dart';
import '../user/screens/edit_profile_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  final String name;
  final String email;
  final String createdAt;

  User({required this.name, required this.email, required this.createdAt});

  factory User.fromJson(Map<String, dynamic> json) {
    print('Convertendo JSON para User: $json');
    return User(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }

  @override
  String toString() {
    return 'User(name: $name, email: $email, createdAt: $createdAt)';
  }
}

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
  // TODO: Obter o ID do usuário logado dinamicamente
  final int _loggedInUserId = 1; // ID do usuário raileal777888
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    print('Inicializando TelaPerfil com ID: $_loggedInUserId');
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print('Iniciando busca do usuário com ID: $_loggedInUserId');
      final response = await http.get(
        Uri.parse(
          'http://192.168.2.107:8080/user/profile/$_loggedInUserId',
        ), // *** SUBSTITUA 'SEU_IP_AQUI' PELO SEU IP REAL ***
      );

      print('Resposta da API: ${response.statusCode}');
      print('Corpo da resposta: ${response.body}');

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        print('Dados do usuário decodificados: $userData');

        setState(() {
          _user = User.fromJson(userData);
          _isLoading = false;
        });
      } else {
        print('Erro na resposta da API: ${response.statusCode}');
        throw Exception('Falha ao carregar dados do usuário');
      }
    } catch (e) {
      print('Erro ao carregar dados do usuário: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

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
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 2),
                      const CircleAvatar(
                        radius:
                            70, // Aumente este valor para um círculo maior (era 40)
                        backgroundColor: Color(0xFF2C2C2C),
                        child: Icon(
                          Icons.person,
                          size:
                              100, // Aumente este valor para um ícone maior (era 40)
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _user?.name ?? "Usuário não encontrado",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _user?.email ?? "",
                        style: const TextStyle(color: Color(0xFFFFBE47)),
                      ),
                      Text(
                        "Desde ${_user?.createdAt ?? ""}",
                        style: const TextStyle(
                          color: Color(0xFFFFBE47),
                        ), // Cor accent padrão
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
                onTap: () {
                  Navigator.pop(context); // Fechar o modal bottom sheet
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => EditProfileScreen(
                            userId: _loggedInUserId,
                          ), // Passar o ID para a tela de edição
                    ),
                  );
                },
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
