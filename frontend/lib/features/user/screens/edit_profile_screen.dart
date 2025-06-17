import 'package:flutter/material.dart';
// import '../components/custom_top_curve.dart'; // Removido: Substituído por cabeçalho personalizado
// import '../register_user/components/register_form.dart'; // Remover import não utilizado
import '../widgets/text_field.dart'; // Importar campo de texto genérico
// import '../widgets/footer.dart'; // Remover import não utilizado
//import '../widgets/password_field.dart'; // Importar campo de senha, caso precise para alterar senha
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Importar dotenv
import 'dart:convert'; // Importar convert
import 'package:http/http.dart' as http; // Importar http
import 'package:image_picker/image_picker.dart'; // Importar image_picker
import 'dart:io'; // Importar dart:io para File
import 'package:google_fonts/google_fonts.dart'; // Importar GoogleFonts para estilização

class EditProfileScreen extends StatefulWidget {
  final int userId; // Adicionar userId como propriedade obrigatória
  final String userEmail; // Adicionar userEmail como propriedade obrigatória

  const EditProfileScreen({
    Key? key,
    required this.userId,
    required this.userEmail,
  }) : super(key: key); // Construtor com userId e userEmail

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Variáveis para armazenar os dados do usuário
  String name = '';
  String email = '';
  String createdAt = '';
  int activeDays = 0; // Exemplo de nova variável
  int totalXp = 0; // Exemplo de nova variável
  int completedHabitsToday = 0; // Exemplo de nova variável
  int activeHabits = 0; // Exemplo de nova variável
  File? _profileImage; // Variável para armazenar a imagem de perfil selecionada

  // Criar controllers para os campos de texto
  final TextEditingController _usernameController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController(); // Removido: Edição de email movida para configurações
  bool _isLoading = true; // Estado para controle do carregamento
  final ImagePicker _picker = ImagePicker(); // Instância do ImagePicker

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Chamar a função para carregar os dados
  }

  @override
  void dispose() {
    _usernameController.dispose();
    // _emailController.dispose(); // Removido: Edição de email movida para configurações
    super.dispose();
  }

  String formatDate(String dateStr) {
    try {
      if (dateStr.isEmpty) return '---';
      var parts = dateStr.split('T');
      if (parts.isEmpty) return '---';
      var dateParts = parts[0].split('-');
      if (dateParts.length != 3) return '---';
      return '${dateParts[2]}/${dateParts[1]}/${dateParts[0]}';
    } catch (e) {
      return '---';
    }
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
        Uri.parse('$apiURL/user/profile/${widget.userId}'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('DATA: ${data}');
        // Assumindo que a rota /user/:id retorna o objeto do usuário diretamente
        setState(() {
          name = data['name'] ?? 'Nome não encontrado';
          email = data['email'] ?? 'Email não encontrado';
          createdAt = data['createdAt'] ?? 'Data não encontrada';
          print('CREATED AT: ${createdAt}');
          // Atribuir valores simulados ou de uma API expandida
          activeDays = 75; // Simulado
          totalXp = 1200; // Simulado
          completedHabitsToday = 5; // Simulado
          activeHabits = 10; // Simulado

          _usernameController.text = name;
          // _emailController.text = email; // Removido: Edição de email movida para configurações
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
      // 'email': _emailController.text, // Removido: Edição de email movida para configurações
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
        // Não voltar para a tela anterior automaticamente se o email foi removido daqui
        // Navigator.pop(context);
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
    // Formatar a data de criação
    String formattedCreatedAt = 'Desde ${createdAt}';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Minha Conta',
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
      body: SafeArea(
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Alinhar conteúdo à esquerda
                    children: [
                      // Removido: CustomTopCurve (substituído por AppBar)
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Informações do Perfil',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Card(
                              color: Colors.grey[850], // Cor de fundo do card
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Center(
                                  // Centralizar a foto de perfil e informações
                                  child: Column(
                                    children: [
                                      Stack(
                                        children: [
                                          CircleAvatar(
                                            radius: 60,
                                            backgroundColor: Colors.grey[800],
                                            backgroundImage:
                                                _profileImage != null
                                                    ? FileImage(_profileImage!)
                                                        as ImageProvider<
                                                          Object
                                                        >?
                                                    : null, // Exibe a imagem selecionada ou nulo
                                            child:
                                                _profileImage == null
                                                    ? Icon(
                                                      Icons.person,
                                                      size: 80,
                                                      color: Colors.white,
                                                    )
                                                    : null, // Exibe o ícone se nenhuma imagem for selecionada
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: _pickImage,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.blueAccent,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                padding: const EdgeInsets.all(
                                                  8,
                                                ),
                                                child: const Icon(
                                                  Icons.camera_alt,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      // Nome e email para visualização, com opção de clique para alterar nome de usuário
                                      _buildEditableInfoTile(
                                        label: 'Nome de Usuário',
                                        value:
                                            name.isNotEmpty
                                                ? name
                                                : 'Carregando...',
                                        onTap:
                                            () => _showEditDialog(
                                              'Nome de Usuário',
                                              _usernameController,
                                              (value) {
                                                setState(() {
                                                  name = value;
                                                });
                                                _saveProfileChanges();
                                              },
                                            ),
                                      ),
                                      // Email (apenas visualização)
                                      _buildInfoTile(
                                        label: 'Email',
                                        value:
                                            email.isNotEmpty
                                                ? email
                                                : 'Carregando...', // Garante que o email da variável de estado seja usado
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ), // Ajuste de espaçamento
                                      Text(
                                        formattedCreatedAt,
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start, // Alinhar conteúdo à esquerda
                          children: [
                            Text(
                              'Estatísticas de Hábitos',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),
                            GridView.count(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              children: [
                                _buildMetricCard(
                                  'Dias Seguidos Ativos',
                                  activeDays.toString(),
                                  Icons.calendar_today,
                                ),
                                _buildMetricCard(
                                  'Total de XP',
                                  totalXp.toString(),
                                  Icons.star,
                                ),
                                _buildMetricCard(
                                  'Hábitos Concluídos Hoje',
                                  completedHabitsToday.toString(),
                                  Icons.check_circle,
                                ),
                                _buildMetricCard(
                                  'Hábitos Ativos',
                                  activeHabits.toString(),
                                  Icons.list_alt,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
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

  // Novo Widget para exibir informações de perfil clicáveis
  Widget _buildEditableInfoTile({
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    return ListTile(
      title: Text(
        label,
        style: TextStyle(color: Colors.grey[500], fontSize: 14),
      ),
      subtitle: Text(
        value,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: onTap != null ? Icon(Icons.edit, color: Colors.grey) : null,
      onTap: onTap,
    );
  }

  // Novo Widget para exibir informações de perfil não clicáveis
  Widget _buildInfoTile({required String label, required String value}) {
    return ListTile(
      title: Text(
        label,
        style: TextStyle(color: Colors.grey[500], fontSize: 14),
      ),
      subtitle: Text(
        value,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Diálogo para edição de texto
  void _showEditDialog(
    String title,
    TextEditingController controller,
    Function(String) onSave,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[850],
          title: Text(title, style: TextStyle(color: Colors.white)),
          content: CustomTextField(label: title, controller: controller),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Salvar', style: TextStyle(color: Colors.blueAccent)),
              onPressed: () {
                onSave(controller.text); // Salva o novo valor
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Função para selecionar imagem da galeria
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      // TODO: Implementar lógica para enviar a imagem para o backend
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Imagem selecionada! Implementar upload para o servidor.',
          ),
        ),
      );
    }
  }

  Widget _buildMetricCard(String title, String value, IconData icon) {
    return Card(
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.blue, size: 30),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
