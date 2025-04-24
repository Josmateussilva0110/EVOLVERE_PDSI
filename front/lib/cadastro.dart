import 'package:flutter/material.dart';
import 'dart:convert'; // para jsonEncode
import 'package:http/http.dart' as http; // para requisições HTTP

class CadastroUsuarioPage extends StatefulWidget {
  @override
  _CadastroUsuarioPageState createState() => _CadastroUsuarioPageState();
}

class _CadastroUsuarioPageState extends State<CadastroUsuarioPage> {
  final _formKey = GlobalKey<FormState>();
  String nome = '';
  String email = '';
  String senha = '';

  void _cadastrar() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();

    var url = Uri.parse('http://192.168.1.5:3000/user');
    var body = jsonEncode({
      "name": nome,
      "email": email,
      "password": senha
    });

    var headers = {"Content-Type": "application/json"};

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuário cadastrado com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar: ${response.body}')),
        );
      }
    } catch (e) {
      print('Erro: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro de conexão com o servidor')),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro de Usuário')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) => value == null || value.isEmpty ? 'Digite seu nome' : null,
                onSaved: (value) => nome = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value != null && value.contains('@') ? null : 'Digite um email válido',
                onSaved: (value) => email = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) =>
                    value != null && value.length >= 6 ? null : 'A senha deve ter pelo menos 6 caracteres',
                onSaved: (value) => senha = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _cadastrar,
                child: Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
