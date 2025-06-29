import 'dart:io';
import 'dart:ui' as ui; // Import necessário para a conversão de ícone para imagem
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart'; // Import do path_provider
import '../../user/widgets/text_field.dart';
import '../../user/widgets/form_container.dart';
import '../widgets/color_selector.dart';
// O widget IconPicker não será mais necessário aqui, a lógica estará dentro do form.
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterFormCategory extends StatefulWidget {
  final dynamic category;
  RegisterFormCategory({this.category, Key? key}) : super(key: key);

  @override
  _RegisterFormCategoryState createState() => _RegisterFormCategoryState();
}

class _RegisterFormCategoryState extends State<RegisterFormCategory> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  int? _userId;
  final List<Color> _colorsAvailable = [
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.cyan,
    Colors.black,
  ];

  Color _selectedColor = Colors.green; // Cor inicial alterada para verde
  
  // --- NOVOS ESTADOS PARA OS ÍCONES ---
  IconData? _selectedIconData;
  File? _pickedImage; // Para a imagem da galeria

  // Lista de ícones pré-definidos
  final List<IconData> _predefinedIcons = [
    Icons.directions_run,
    Icons.book,
    Icons.favorite,
    Icons.star,
    Icons.school,
    // Adicione mais ícones conforme desejar
  ];

  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('loggedInUserId');
    setState(() {
      _userId = userId;
    });
    print('USER ID: $_userId');
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    // Definir um ícone padrão ao iniciar
    if (_predefinedIcons.isNotEmpty) {
      _selectedIconData = _predefinedIcons.first;
    }
    
    if (widget.category != null) {
      _nameController.text = widget.category.name ?? '';
      _descriptionController.text = widget.category.description ?? '';
      if (widget.category.color != null) {
        _selectedColor = widget.category.color;
      }
      // Lógica para carregar ícone existente (se vier do backend) pode ser adicionada aqui
    }
  }

  String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }

  // --- NOVA FUNÇÃO: CONVERTER IconData PARA File ---
  Future<File> _createFileFromIcon(IconData iconData) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    final iconStr = String.fromCharCode(iconData.codePoint);
    
    textPainter.text = TextSpan(
      text: iconStr,
      style: TextStyle(
        letterSpacing: 0.0,
        fontSize: 128.0, // Tamanho do ícone na imagem
        fontFamily: iconData.fontFamily,
        color: Colors.white, // Cor do ícone na imagem
      ),
    );

    textPainter.layout();
    textPainter.paint(canvas, Offset.zero);

    final picture = recorder.endRecording();
    final image = await picture.toImage(
        textPainter.width.toInt(), textPainter.height.toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/icon_${DateTime.now().millisecondsSinceEpoch}.png');
    await file.writeAsBytes(bytes!.buffer.asUint8List(), flush: true);

    return file;
  }

  Future<void> _submitCategory() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('O nome da categoria é obrigatório'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // --- LÓGICA DE SUBMISSÃO MODIFICADA ---
    File? iconFile;
    if (_pickedImage != null) {
      iconFile = _pickedImage;
    } else if (_selectedIconData != null) {
      // Converte o ícone selecionado em um arquivo antes de enviar
      iconFile = await _createFileFromIcon(_selectedIconData!);
    }
    // Se nenhum dos dois for selecionado, iconFile continuará null

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${dotenv.env['API_URL']}/category'),
    )
      ..fields['name'] = _nameController.text
      ..fields['description'] = _descriptionController.text
      ..fields['color'] = colorToHex(_selectedColor)
      ..fields['user_id'] = _userId.toString();

    if (iconFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('icon', iconFile.path),
      );
    }

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Categoria cadastrada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        String errorMessage = 'Erro ao cadastrar uma categoria.';
        try {
          final respStr = await response.stream.bytesToString();
          final Map<String, dynamic> data = jsonDecode(respStr);
          if (data.containsKey('err')) {
            errorMessage = data['err'];
          }
        } catch (_) {}

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao conectar com o servidor: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
        _selectedIconData = null; // Desmarca o ícone pré-definido
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormContainer(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  label: "Nome da Categoria",
                  controller: _nameController,
                  maxLength: 30,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O nome da categoria é obrigatório';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: "Descrição",
                  maxLines: 5,
                  maxLength: 200,
                  controller: _descriptionController,
                ),
                const SizedBox(height: 24),
                
                // --- NOVA SEÇÃO DE ÍCONES ---
                const Text('Ícone', style: TextStyle(color: Colors.white70, fontSize: 16)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12.0,
                  runSpacing: 12.0,
                  children: [
                    ..._predefinedIcons.map((icon) {
                      final isSelected = _selectedIconData == icon;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIconData = icon;
                            _pickedImage = null; // Desmarca a imagem da galeria
                          });
                        },
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.2) : Colors.grey[800],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Icon(icon, color: Colors.white, size: 30),
                        ),
                      );
                    }).toList(),

                    // Botão para pegar da galeria
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(8),
                           border: _pickedImage != null ? Border.all(color: Theme.of(context).primaryColor, width: 2) : null,
                        ),
                        // Mostra a imagem selecionada ou um ícone de galeria
                        child: _pickedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.file(_pickedImage!, fit: BoxFit.cover),
                              )
                            : const Icon(Icons.photo_library, color: Colors.white, size: 30),
                      ),
                    ),
                  ],
                ),
                // --- FIM DA SEÇÃO DE ÍCONES ---

                const SizedBox(height: 32),
                ColorSelector(
                  colors: _colorsAvailable,
                  selectedColor: _selectedColor,
                  onColorSelected: (color) {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007AFF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _userId == null ? null : _submitCategory,
            child: const Text(
              'Cadastrar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }
}