import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NotificationService {
  static Future<List<Map<String, dynamic>>?> getNotificationsByUserId(
    int userId,
  ) async {
    final url = Uri.parse(
      '${dotenv.env['API_URL']}/notifications/user/$userId',
    );

    try {
      print('🔍 Buscando notificações para usuário: $userId');
      print('🌐 URL: $url');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('📡 Status code: ${response.statusCode}');
      print('📄 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> notifications = jsonDecode(response.body);
        print('📋 Notificações encontradas: ${notifications.length}');

        final result =
            notifications.map<Map<String, dynamic>>((notification) {
              print('🔍 Processando notificação: ${notification['id']}');
              print('📊 Dados brutos: $notification');

              // Verificar se data é string ou já é objeto
              Map<String, dynamic> data;
              if (notification['data'] is String) {
                data = jsonDecode(notification['data']);
                print('🔄 Data convertida de string: $data');
              } else {
                data = Map<String, dynamic>.from(notification['data']);
                print('📊 Data já é objeto: $data');
              }

              final result = {
                'id': notification['id'],
                'user_id': notification['user_id'],
                'created_at': notification['created_at'],
                'updated_at': notification['updated_at'],
                'status':
                    notification['status'] == 1 ||
                    notification['status'] == true,
                ...data,
              };

              print('✅ Resultado final: $result');
              return result;
            }).toList();

        print('🎉 Total de notificações processadas: ${result.length}');
        return result;
      } else {
        print('❌ Erro na resposta: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('💥 Erro ao buscar notificações: $e');
      return null;
    }
  }

  static Future<bool> deleteNotification(int notificationId) async {
    final url = Uri.parse(
      '${dotenv.env['API_URL']}/notification/$notificationId',
    );

    try {
      print('🗑️ Deletando notificação: $notificationId');
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('📡 Status code: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('💥 Erro ao deletar notificação: $e');
      return false;
    }
  }

  static Future<bool> deleteAllUserNotifications(int userId) async {
    final url = Uri.parse(
      '${dotenv.env['API_URL']}/notifications/user/$userId',
    );

    try {
      print('🗑️ Deletando todas as notificações do usuário: $userId');
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('📡 Status code: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('💥 Erro ao deletar todas as notificações: $e');
      return false;
    }
  }

  static Future<bool> updateNotificationStatus(int notificationId) async {
    final url = Uri.parse(
      '${dotenv.env['API_URL']}/notification/$notificationId/status',
    );

    try {
      print('✅ Atualizando status da notificação: $notificationId');
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('📡 Status code: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('💥 Erro ao atualizar status da notificação: $e');
      return false;
    }
  }

  static Future<int> getUnreadCount(int userId) async {
    final url = Uri.parse('${dotenv.env['API_URL']}/notifications/unread/count/$userId');
    try {
      final response = await http.get(url, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return int.tryParse(data['unread'].toString()) ?? 0;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }
}
