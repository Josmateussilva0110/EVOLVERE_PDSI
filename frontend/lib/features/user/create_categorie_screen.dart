import 'package:flutter/material.dart';

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

  Color _selectedColor = Colors.red; // inicializar com a primeira cor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 65, 84, 192),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(88),
                    bottomRight: Radius.circular(88),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 40),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 12),
                    Center(
                      child: Text(
                        'Nova Categoria',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextField(
                      label: "Nova Categoria",
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Cor tema"),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    SizedBox(height: 20),
                    SizedBox(height: 20),
                    SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 65, 84, 192),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      child: Text('Salvar', style: TextStyle(fontSize: 16)),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
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
        Text(label),
        SizedBox(height: 10),
        TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Color.fromARGB(255, 65, 84, 192),
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
