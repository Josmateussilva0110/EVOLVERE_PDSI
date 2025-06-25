import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../user/widgets/text_field.dart';
import '../../user/widgets/form_container.dart';
import '../widgets/color_selector.dart';
import '../widgets/icon_picker.dart';
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

  Color _selectedColor = Colors.red;
  File? _image;

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
    if (widget.category != null) {
      _nameController.text = widget.category.name ?? '';
      _descriptionController.text = widget.category.description ?? '';
      if (widget.category.color != null) {
        _selectedColor = widget.category.color;
      }
      // Imagem não é carregada localmente, só se o usuário escolher outra
    }
  }

  String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
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

    var request =
        http.MultipartRequest(
            'POST',
            Uri.parse('${dotenv.env['API_URL']}/category'),
          )
          ..fields['name'] = _nameController.text
          ..fields['description'] = _descriptionController.text
          ..fields['color'] = colorToHex(_selectedColor)
          ..fields['user_id'] = _userId.toString();

    if (_image != null) {
      request.files.add(
        await http.MultipartFile.fromPath('icon', _image!.path),
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
        _image = File(pickedFile.path);
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
                IconPicker(image: _image, onPickImage: _pickImage),
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
