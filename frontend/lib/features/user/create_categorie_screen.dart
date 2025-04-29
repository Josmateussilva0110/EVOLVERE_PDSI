import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../user/tela_login/components/custom_top_curve.dart';

void main() => runApp(MaterialApp(home: RegisterCategorieScreen()));

class RegisterCategorieScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<RegisterCategorieScreen> {
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTopCurve(label: "Nova Categoria"),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFF1D1D1D),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTextField(
                        label: "Nome da Categoria",
                        hint: "Digite o nome da categoria",
                      ),
                      SizedBox(height: 20),
                      _buildTextField(
                        label: "Descrição",
                        hint: "Digite uma breve descrição",
                        maxLines: 5,
                      ),
                      SizedBox(height: 20),
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start, 
                        children: [
                          Text(
                            'Ícone',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          
                          Center(
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: CircleAvatar(
                                radius: 35,
                                backgroundColor: Color(0xFF2C2C2C),
                                backgroundImage:
                                    _image != null ? FileImage(_image!) : null,
                                child:
                                    _image == null
                                        ? Icon(
                                          Icons.add_a_photo,
                                          size: 28,
                                          color: const Color.fromARGB(255, 0, 0, 0),
                                        )
                                        : null,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Cor tema",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children:
                                    _colorsAvailable.map((cor) {
                                      bool selecionada = cor == _selectedColor;
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedColor = cor;
                                          });
                                        },
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: cor,
                                            shape: BoxShape.circle,
                                            border:
                                                selecionada
                                                    ? Border.all(
                                                      color: Color.fromARGB(
                                                        255,
                                                        65,
                                                        84,
                                                        192,
                                                      ),
                                                      width: 3,
                                                    )
                                                    : null,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                width: 200,
                height: 52, 
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 43, 107, 237),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Salvar',
                    style: TextStyle(fontSize: 18),
                  ), 
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white70, 
            fontSize: 16, 
            fontWeight: FontWeight.w500, 
          ),
        ),
        SizedBox(height: 10),
        TextField(
          maxLines: maxLines,
          style: TextStyle(
            color: Colors.white,
          ), 
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.white38,
            ), 
            filled: true,
            fillColor: Color(0xFF2C2C2C),
            contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Color.fromARGB(255, 43, 107, 237),
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
