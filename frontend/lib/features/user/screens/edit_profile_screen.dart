import 'package:flutter/material.dart';
import '../components/custom_top_curve.dart';
// import '../register_user/components/register_form.dart'; // Remover import não utilizado
import '../widgets/text_field.dart'; // Importar campo de texto genérico
// import '../widgets/footer.dart'; // Remover import não utilizado
import '../widgets/password_field.dart'; // Importar campo de senha, caso precise para alterar senha
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Importar dotenv
import 'dart:convert'; // Importar convert
import 'package:http/http.dart' as http; // Importar http

class EditProfileScreen extends StatefulWidget {
  final int userId; // Adicionar userId como propriedade obrigatória
  const EditProfileScreen({Key? key, required this.userId})
    : super(key: key); // Construtor com userId

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Variáveis para armazenar os dados do usuário
  String name = '';
  String email = '';
  String createdAt = '';

  // Criar controllers para os campos de texto
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = true; // Estado para controle do carregamento

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Chamar a função para carregar os dados
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Função para carregar os dados do usuário do backend
  Future<void> _loadUserData() async {
    final String? apiURL = dotenv.env['API_URL'];
    if (apiURL == null) {
      print('API_URL não configurado no .env');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      // Buscar usuário pelo ID usando a rota correta
      final response = await http.get(
        Uri.parse('$apiURL/user/${widget.userId}'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        // Assumindo que a rota /user/:id retorna o objeto do usuário diretamente
        setState(() {
          name = data['username'] ?? 'Nome não encontrado';
          email = data['email'] ?? 'Email não encontrado';
          createdAt = data['createdAt'] ?? 'Data não encontrada';
          _usernameController.text = name;
          _emailController.text = email;
        });
      } else {
        // Tratar erro ao carregar dados
        print('Erro ao carregar dados do usuário: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar dados do usuário.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Erro na requisição de carregamento: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao conectar com o servidor.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Função para salvar as alterações no backend
  Future<void> _saveProfileChanges() async {
    final String? apiURL = dotenv.env['API_URL'];
    if (apiURL == null) {
      print('API_URL não configurado no .env');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar: URL da API não configurada.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final Map<String, dynamic> requestBody = {
      'username': _usernameController.text,
      'email': _emailController.text,
    };

    try {
      final response = await http.put(
        Uri.parse('$apiURL/user/edit/${widget.userId}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print('Perfil atualizado com sucesso!');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Perfil atualizado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Voltar para a tela anterior após sucesso
      } else {
        String errorMessage = 'Erro ao atualizar perfil.';
        try {
          final Map<String, dynamic> data = jsonDecode(response.body);
          if (data.containsKey('err')) {
            errorMessage = data['err'];
          }
        } catch (_) {
          // Ignorar erro de parsing se a resposta não for um JSON
        }
        print(
          'Erro ao atualizar perfil: ${response.statusCode} - $errorMessage',
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      print('Erro na requisição de atualização: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao conectar com o servidor.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomTopCurve(label: "Editar Perfil"),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            CustomTextField(
                              label: 'Nome de Usuário',
                              controller: _usernameController,
                            ),
                            SizedBox(height: 20),
                            CustomTextField(
                              label: 'Email',
                              controller: _emailController,
                            ),
                            SizedBox(height: 30),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF2196F3),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 50,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                minimumSize: Size(double.infinity, 50),
                              ),
                              onPressed: _saveProfileChanges,
                              child: Text(
                                'Salvar',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
      ),
    );
  }
}
