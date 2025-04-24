import 'package:flutter/material.dart';
import 'dart:convert'; // para jsonEncode
import 'package:http/http.dart' as http; // para requisições HTTP
import 'home.dart';

class Login extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String senha = '';

  void _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var url = Uri.parse('http://192.168.1.5:3000/login');
      var body = jsonEncode({"email": email, "password": senha});

      var headers = {"Content-Type": "application/json"};

      try {
        var response = await http.post(url, headers: headers, body: body);

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login realizado com sucesso!')),
          );

          // Navegar para a HomePage passando dados do usuário (como token ou email)
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => HomePage(email: email, token: data['token']),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao fazer login: ${response.body}')),
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
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator:
                    (value) =>
                        value != null && value.contains('@')
                            ? null
                            : 'Digite um email válido',
                onSaved: (value) => email = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator:
                    (value) =>
                        value != null && value.length >= 6
                            ? null
                            : 'A senha deve ter pelo menos 6 caracteres',
                onSaved: (value) => senha = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _login, child: Text('Login')),
            ],
          ),
        ),
      ),
    );
  }
}
