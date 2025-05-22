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

class RegisterFormCategory extends StatefulWidget {
  final dynamic category;
  RegisterFormCategory({this.category, Key? key}) : super(key: key);

  @override
  _RegisterFormCategoryState createState() => _RegisterFormCategoryState();
}

class _RegisterFormCategoryState extends State<RegisterFormCategory> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
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

  @override
  void initState() {
    super.initState();
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
    var request =
        http.MultipartRequest(
            'POST',
            Uri.parse('${dotenv.env['API_URL']}/category'),
          )
          ..fields['name'] = _nameController.text
          ..fields['description'] = _descriptionController.text
          ..fields['color'] = colorToHex(_selectedColor);

    if (_image != null) {
      request.files.add(
        await http.MultipartFile.fromPath('icon', _image!.path),
      );
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Categoria cadastrada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                label: "Nome da Categoria",
                controller: _nameController,
              ),
              SizedBox(height: 20),
              CustomTextField(
                label: "Descrição",
                maxLines: 5,
                controller: _descriptionController,
              ),
              SizedBox(height: 20),
              IconPicker(image: _image, onPickImage: _pickImage),
              SizedBox(height: 20),
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
        SizedBox(height: 20),
        SizedBox(
          width: 200,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2196F3),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: _submitCategory,
            child: Text('Cadastrar', style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }
}
