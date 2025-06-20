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
import '../service/user_service.dart';

class CompletedHabit {
  final int id;
  final String name;
  final String description;
  final String? categoria;
  final String completedAt;

  CompletedHabit({
    required this.id,
    required this.name,
    required this.description,
    this.categoria,
    required this.completedAt,
  });

  factory CompletedHabit.fromJson(Map<String, dynamic> json) {
    return CompletedHabit(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      categoria: json['categoria'],
      completedAt: json['completedAt'],
    );
  }
}

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
  String? profileImagePath; // Adicionar variável para o caminho da imagem
  int activeDays = 0; // Exemplo de nova variável
  int totalXp = 0; // Exemplo de nova variável
  int completedHabitsToday = 0; // Exemplo de nova variável
  int activeHabits = 0; // Exemplo de nova variável
  File? _profileImage; // Variável para armazenar a imagem de perfil selecionada

  // Criar controllers para os campos de texto
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController =
      TextEditingController(); // Removido: Edição de email movida para configurações
  bool _isLoading = true; // Estado para controle do carregamento
  final ImagePicker _picker = ImagePicker(); // Instância do ImagePicker

  // Variáveis para hábitos completados
  Map<String, List<CompletedHabit>> _completedHabitsByMonth = {};
  bool _isLoadingHabits = false;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Chamar a função para carregar os dados
    _loadCompletedHabits(); // Carregar hábitos completados
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController
        .dispose(); // Removido: Edição de email movida para configurações
    super.dispose();
  }

  // Função para carregar hábitos completados
  Future<void> _loadCompletedHabits() async {
    setState(() {
      _isLoadingHabits = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
          '${dotenv.env['API_URL']}/habits/completed_by_month/${widget.userId}',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final Map<String, dynamic> rawHabits = data['completedHabits'];

        final Map<String, List<CompletedHabit>> groupedHabits = {};
        rawHabits.forEach((monthYear, habitsList) {
          groupedHabits[monthYear] =
              (habitsList as List)
                  .map((habit) => CompletedHabit.fromJson(habit))
                  .toList();
        });

        setState(() {
          _completedHabitsByMonth = groupedHabits;
        });
      }
    } catch (e) {
      print('Erro ao carregar hábitos completados: $e');
    } finally {
      setState(() {
        _isLoadingHabits = false;
      });
    }
  }

  // Função para formatar mês/ano
  String _formatMonthYear(String monthYear) {
    final parts = monthYear.split('-');
    if (parts.length == 2) {
      final year = parts[0];
      final month = int.tryParse(parts[1]) ?? 1;
      final monthNames = [
        'Janeiro',
        'Fevereiro',
        'Março',
        'Abril',
        'Maio',
        'Junho',
        'Julho',
        'Agosto',
        'Setembro',
        'Outubro',
        'Novembro',
        'Dezembro',
      ];
      return '${monthNames[month - 1]} $year';
    }
    return monthYear;
  }

  // Função para formatar a data de conclusão
  String _formatCompletionDate(String dateString) {
    print('Data recebida para formatação: $dateString');
    try {
      // Pega a parte da data (ex: "2025-06-19")
      final datePart = dateString.split('T')[0];
      // Divide em ano, mês e dia
      final dateComponents = datePart.split('-');
      // Reorganiza para o formato dd/mm/yyyy
      if (dateComponents.length == 3) {
        final year = dateComponents[0];
        final month = dateComponents[1];
        final day = dateComponents[2];
        return 'Completado em: $day/$month/$year';
      }
      return 'Completado em: $datePart'; // Fallback
    } catch (e) {
      // Fallback em caso de erro
      return 'Completado em: ${dateString.split('T')[0]}';
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
          profileImagePath =
              data['upload_perfil']; // Carregar caminho da imagem
          // Atribuir valores simulados ou de uma API expandida
          activeDays = 75; // Simulado
          totalXp = 1200; // Simulado
          completedHabitsToday = 5; // Simulado
          activeHabits = 10; // Simulado

          _usernameController.text = name;
          _emailController.text =
              email; // Removido: Edição de email movida para configurações
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
                                            backgroundImage: _getProfileImage(),
                                            child:
                                                _getProfileImage() == null
                                                    ? Icon(
                                                      Icons.person,
                                                      size: 80,
                                                      color: Colors.white,
                                                    )
                                                    : null,
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
                                        onTap: () {
                                          _showEditDialog(
                                            'Nome de Usuário',
                                            _usernameController,
                                            (newValue) async {
                                              setState(() {
                                                name = newValue;
                                              });

                                              // Chama o service para atualizar no backend
                                              final service =
                                                  UserProfileService();
                                              bool success = await service
                                                  .updateUserProfile(
                                                    userId: widget.userId,
                                                    username: newValue,
                                                    context: context,
                                                  );

                                              if (success) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Nome atualizado com sucesso!',
                                                    ),
                                                    backgroundColor:
                                                        Colors.green,
                                                  ),
                                                );
                                              }
                                            },
                                          );
                                        },
                                      ),

                                      // Email (apenas visualização)
                                      _buildEditableInfoTile(
                                        label: 'Email',
                                        value:
                                            email.isNotEmpty
                                                ? email
                                                : 'Carregando...',
                                        onTap: () {
                                          _showEditDialog(
                                            'Email',
                                            _emailController,
                                            (newValue) async {
                                              setState(() {
                                                email = newValue;
                                              });

                                              // Chama o service para atualizar no backend
                                              final service =
                                                  UserProfileService();
                                              bool success = await service
                                                  .updateEmailProfile(
                                                    userId: widget.userId,
                                                    email: newValue,
                                                    context: context,
                                                  );

                                              if (success) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Email atualizado com sucesso!',
                                                    ),
                                                    backgroundColor:
                                                        Colors.green,
                                                  ),
                                                );
                                              }
                                            },
                                          );
                                        },
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

                      // Container de Hábitos Concluídos
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hábitos Concluídos',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[850],
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.grey[700]!),
                              ),
                              child:
                                  _isLoadingHabits
                                      ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                      : _completedHabitsByMonth.isEmpty
                                      ? Center(
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.check_circle_outline,
                                              color: Colors.grey[400],
                                              size: 48,
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              'Nenhum hábito completado ainda',
                                              style: TextStyle(
                                                color: Colors.grey[400],
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                      : Column(
                                        children:
                                            _completedHabitsByMonth.entries.map((
                                              entry,
                                            ) {
                                              final monthYear = entry.key;
                                              final habits = entry.value;

                                              return Container(
                                                margin: EdgeInsets.only(
                                                  bottom: 20,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Cabeçalho do mês
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 12,
                                                            vertical: 8,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.blue
                                                            .withOpacity(0.1),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                        border: Border.all(
                                                          color: Colors.blue
                                                              .withOpacity(0.3),
                                                        ),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .calendar_month,
                                                            color: Colors.blue,
                                                            size: 20,
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Text(
                                                            _formatMonthYear(
                                                              monthYear,
                                                            ),
                                                            style:
                                                                GoogleFonts.inter(
                                                                  color:
                                                                      Colors
                                                                          .blue,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                          ),
                                                          Spacer(),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 4,
                                                                ),
                                                            decoration:
                                                                BoxDecoration(
                                                                  color:
                                                                      Colors
                                                                          .blue,
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        12,
                                                                      ),
                                                                ),
                                                            child: Text(
                                                              '${habits.length} hábito${habits.length != 1 ? 's' : ''}',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(height: 12),

                                                    // Lista de hábitos do mês
                                                    ...habits
                                                        .map(
                                                          (habit) => Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                  bottom: 8,
                                                                ),
                                                            padding:
                                                                EdgeInsets.all(
                                                                  12,
                                                                ),
                                                            decoration: BoxDecoration(
                                                              color:
                                                                  Colors
                                                                      .grey[800],
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    8,
                                                                  ),
                                                              border: Border.all(
                                                                color:
                                                                    Colors
                                                                        .grey[600]!,
                                                              ),
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .check_circle,
                                                                      color:
                                                                          Colors
                                                                              .green,
                                                                      size: 16,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 8,
                                                                    ),
                                                                    Expanded(
                                                                      child: Text(
                                                                        habit
                                                                            .name,
                                                                        style: GoogleFonts.inter(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                if (habit
                                                                        .categoria !=
                                                                    null) ...[
                                                                  const SizedBox(
                                                                    height: 6,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .category,
                                                                        color:
                                                                            Colors.grey[400],
                                                                        size:
                                                                            14,
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            4,
                                                                      ),
                                                                      Text(
                                                                        habit
                                                                            .categoria!,
                                                                        style: TextStyle(
                                                                          color:
                                                                              Colors.grey[400],
                                                                          fontSize:
                                                                              12,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                                const SizedBox(
                                                                  height: 6,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .schedule,
                                                                      color:
                                                                          Colors
                                                                              .grey[400],
                                                                      size: 14,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 4,
                                                                    ),
                                                                    Text(
                                                                      _formatCompletionDate(
                                                                        habit
                                                                            .completedAt,
                                                                      ),
                                                                      style: TextStyle(
                                                                        color:
                                                                            Colors.grey[400],
                                                                        fontSize:
                                                                            12,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                        .toList(),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
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

  // Função para selecionar imagem da galeria e fazer upload
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });

      // Fazer upload da imagem para o backend
      await _uploadImage(pickedFile);
    }
  }

  // Função para fazer upload da imagem
  Future<void> _uploadImage(XFile imageFile) async {
    try {
      final String? apiURL = dotenv.env['API_URL'];
      if (apiURL == null) {
        throw Exception('API_URL não configurado');
      }

      // Criar requisição multipart
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$apiURL/user/upload_image/${widget.userId}'),
      );

      // Adicionar arquivo
      var stream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();
      var multipartFile = http.MultipartFile(
        'profile_image',
        stream,
        length,
        filename: imageFile.name,
      );
      request.files.add(multipartFile);

      // Enviar requisição
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = json.decode(responseData);
        setState(() {
          profileImagePath = data['imagePath'];
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Imagem de perfil atualizada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        final errorData = json.decode(responseData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorData['err'] ?? 'Erro ao fazer upload da imagem'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Erro ao fazer upload da imagem: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao fazer upload da imagem'),
          backgroundColor: Colors.red,
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

  ImageProvider<Object>? _getProfileImage() {
    if (profileImagePath != null) {
      final String? apiURL = dotenv.env['API_URL'];
      if (apiURL != null) {
        return NetworkImage('$apiURL$profileImagePath');
      }
    } else if (_profileImage != null) {
      return FileImage(_profileImage!);
    }
    return null;
  }
}
