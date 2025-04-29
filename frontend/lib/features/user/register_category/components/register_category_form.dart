import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/text_field.dart';
import '../../widgets/form_container.dart';
import '../widgets/color_selector.dart';
import '../widgets/icon_picker.dart';

class RegisterFormCategory extends StatefulWidget {
  @override
  _RegisterFormCategoryState createState() => _RegisterFormCategoryState();
}

class _RegisterFormCategoryState extends State<RegisterFormCategory> {
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
              CustomTextField(label: "Nome da Categoria"),
              SizedBox(height: 20),
              CustomTextField(label: "Descrição", maxLines: 5),
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
            onPressed: () {
              // lógica de cadastro
            },
            child: Text('Cadastrar', style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }
}
