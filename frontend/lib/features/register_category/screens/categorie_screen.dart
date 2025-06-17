import 'package:flutter/material.dart';
import '../components/register_category_form.dart';
import '../models/category.dart';
import 'package:google_fonts/google_fonts.dart';
// Removendo imports não utilizados após a refatoração do cabeçalho
// import 'package:front/features/components/auth_header.dart';

class RegisterCategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)?.settings.arguments as Category?;
    // final size = MediaQuery.of(context).size; // Não mais necessário aqui
    // final isSmallScreen = size.height < 600; // Não mais necessário aqui

    return Scaffold(
      backgroundColor: const Color(
        0xFF0A0A0A,
      ), // Fundo da tela: preto muito escuro
      appBar: AppBar(
        backgroundColor: const Color(
          0xFF0A0A0A,
        ), // Fundo da AppBar: preto muito escuro
        elevation: 0, // Sem sombra
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white70,
          ), // Ícone de voltar suave
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          category != null ? "Editar Categoria" : "Nova Categoria",
          style: GoogleFonts.inter(
            color: Colors.white, // Cor do texto branco
            fontWeight: FontWeight.w700, // Peso da fonte forte
            fontSize: 28, // Tamanho da fonte grande para destaque
          ),
          textAlign: TextAlign.center, // Centraliza o texto do título na AppBar
        ),
        centerTitle: true, // Centraliza o título da AppBar
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 24.0,
          ), // Padding geral para a SingleChildScrollView
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .stretch, // Estica os filhos para preencher a largura
            children: [
              // O AppBar agora lida com o cabeçalho, então removemos os elementos customizados daqui
              RegisterFormCategory(category: category),
              const SizedBox(
                height: 24,
              ), // Espaçamento inferior após o formulário
            ],
          ),
        ),
      ),
    );
  }
}
