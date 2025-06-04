import 'package:flutter/material.dart';
import '../components/custom_top_curve.dart';
// import '../register_user/components/register_form.dart'; // Remover import não utilizado
import '../widgets/text_field.dart'; // Importar campo de texto genérico
// import '../widgets/footer.dart'; // Remover import não utilizado
import '../widgets/password_field.dart'; // Importar campo de senha, caso precise para alterar senha

class EditProfileScreen extends StatelessWidget {
  // Remova o construtor, pois a classe não é const.
  // const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTopCurve(label: "Editar Perfil"), // Altera o rótulo
              SizedBox(height: 20), // Espaço maior após o cabeçalho
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ), // Adiciona padding
                child: Column(
                  children: [
                    CustomTextField(
                      label: 'Nome de Usuário',
                    ), // Campo para editar nome de usuário
                    SizedBox(height: 20),
                    CustomTextField(label: 'Email'), // Campo para editar email
                    SizedBox(height: 30), // Espaço antes do botão
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2196F3), // Cor do botão
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 50,
                        ), // Ajusta padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: Size(
                          double.infinity,
                          50,
                        ), // Deixa o botão largo
                      ),
                      onPressed: () {
                        // TODO: Adicionar lógica para salvar as alterações do perfil
                        print('Botão Salvar clicado');
                      },
                      child: Text('Salvar', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
              // Remover o Footer, pois não é necessário na tela de edição.
              // Footer(mensagem: 'Já tem conta ? ', acao: 'Entrar', routeName: '/login',),
              SizedBox(height: 20), // Espaço no final
            ],
          ),
        ),
      ),
    );
  }
}
