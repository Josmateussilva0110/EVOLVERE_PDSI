import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class UserProfileService {
  final String? apiURL = dotenv.env['API_URL'];

  /// Atualiza o nome de usuário no backend
  Future<bool> updateUserProfile({
    required int userId,
    required String username,
    required BuildContext context,
  }) async {
    if (apiURL == null) {
      debugPrint('API_URL não configurado no .env');
      _showSnackbar(context, 'URL da API não configurada.', isError: true);
      return false;
    }

    final Uri url = Uri.parse('$apiURL/user/edit_name/$userId');

    final Map<String, dynamic> requestBody = {
      'username': username,
    };

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        _showSnackbar(context, 'Perfil atualizado com sucesso!', isError: false);
        return true;
      } else {
        String errorMessage = 'Erro ao atualizar perfil.';
        try {
          final Map<String, dynamic> data = jsonDecode(response.body);
          if (data.containsKey('err')) {
            errorMessage = data['err'];
          }
        } catch (_) {}
        debugPrint(
          'Erro ao atualizar perfil: ${response.statusCode} - $errorMessage',
        );
        _showSnackbar(context, errorMessage, isError: true);
        return false;
      }
    } catch (e) {
      debugPrint('Erro na requisição de atualização: $e');
      _showSnackbar(context, 'Erro ao conectar com o servidor.', isError: true);
      return false;
    }
  }

  /// Função auxiliar para exibir SnackBar
  void _showSnackbar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }
}
