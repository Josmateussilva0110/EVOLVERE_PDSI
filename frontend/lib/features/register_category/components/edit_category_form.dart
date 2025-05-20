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
import '../models/category.dart';

class EditCategoryForm extends StatefulWidget {
  final Category? category;
  EditCategoryForm({this.category, Key? key}) : super(key: key);

  @override
  _EditCategoryFormState createState() => _EditCategoryFormState();
}

class _EditCategoryFormState extends State<EditCategoryForm> {
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
      _nameController.text = widget.category!.name;
      _descriptionController.text = widget.category!.description;
      _selectedColor = widget.category!.color;
      // Se a categoria tiver um ícone, não carrega localmente, mas mostra opção de remover
    }
  }

  String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }

  Future<void> _submitEdit() async {
    if (widget.category == null) return;
    var request =
        http.MultipartRequest(
            'PATCH',
            Uri.parse(
              '${dotenv.env['API_URL']}/category/${widget.category!.id}',
            ),
          )
          ..fields['name'] = _nameController.text
          ..fields['description'] = _descriptionController.text
          ..fields['color'] = colorToHex(_selectedColor);

    // Se _image for File(''), sinaliza remoção da imagem
    if (_image != null && _image!.path.isEmpty) {
      request.fields['remove_icon'] = 'true';
    } else if (_image != null && _image!.path.isNotEmpty) {
      request.files.add(
        await http.MultipartFile.fromPath('icon', _image!.path),
      );
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Categoria editada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } else {
      String errorMessage = 'Erro ao editar a categoria.';
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
              // Ícone e botão de remover/modificar
              if (widget.category != null && widget.category!.iconUrl.isNotEmpty && _image == null)
                Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: ClipOval(
                        child: Image.network(
                          '${dotenv.env['API_URL']}${widget.category!.iconUrl}',
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _image = File(''); // Sinaliza remoção
                        });
                      },
                      icon: Icon(Icons.delete, color: Colors.red),
                      label: Text('Remover foto', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              if (_image != null && _image!.path.isNotEmpty)
                IconPicker(image: _image, onPickImage: _pickImage)
              else if (_image == null && (widget.category == null || widget.category!.iconUrl.isEmpty))
                IconPicker(image: null, onPickImage: _pickImage)
              else if (_image != null && _image!.path.isEmpty)
                IconPicker(image: null, onPickImage: _pickImage),
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
            onPressed: _submitEdit,
            child: Text('Salvar', style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }
}
