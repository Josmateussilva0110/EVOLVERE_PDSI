import 'package:flutter/material.dart';
import '../user/screens/edit_profile_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; 

class User {
  final String name;
  final String email;
  final String createdAt;

  User({required this.name, required this.email, required this.createdAt});

  factory User.fromJson(Map<String, dynamic> json) {
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
  int? _loggedInUserId; // Agora pode ser nulo no início
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAndFetchUserData(); // Nova função para carregar ID e buscar dados
  }

  Future<void> _loadAndFetchUserData() async {
    setState(() {
      _isLoading = true;
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _loggedInUserId = prefs.getInt('loggedInUserId'); // Recupera o ID

    if (_loggedInUserId == null) {
      setState(() {
        _isLoading = false;
      });
      // Opcional: Navegar para a tela de login se o ID não for encontrado
      // Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    await _fetchUserData(_loggedInUserId!); // Passa o ID para a função de busca
  }

  Future<void> _fetchUserData(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/user/profile/$userId'),
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);

        setState(() {
          _user = User.fromJson(userData);
          _isLoading = false;
        });
      } else {
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
      backgroundColor: const Color(0xFF121217),
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
            _isLoading || _loggedInUserId == null
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 2),
                      const CircleAvatar(
                        radius: 70,
                        backgroundColor: Color(0xFF2C2C2C),
                        child: Icon(
                          Icons.person,
                          size: 100,
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
                            userId: _loggedInUserId!,
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
