import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/notification_service.dart';
import 'services/reminder_service.dart';
import 'models/notification_model.dart';
import 'widgets/notification_detail_dialog.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with TickerProviderStateMixin {
  List<NotificationModel> notifications = [];
  bool isLoading = true;
  int? userId;
  Map<int, bool> readNotifications = {};
  Map<int, AnimationController> animationControllers = {};

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  @override
  void dispose() {
    // Dispose de todos os controllers de animação
    for (var controller in animationControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Buscar userId do SharedPreferences
      final prefs = await SharedPreferences.getInstance();

      // Debug: verificar todas as chaves disponíveis
      print('🔍 Todas as chaves no SharedPreferences: ${prefs.getKeys()}');
      print('🔍 loggedInUserId: ${prefs.getInt('loggedInUserId')}');
      print('🔍 userId: ${prefs.getInt('userId')}');
      print('🔍 username: ${prefs.getString('username')}');
      print('🔍 email: ${prefs.getString('email')}');

      userId = prefs.getInt(
        'loggedInUserId',
      ); // Corrigido: era 'userId', agora é 'loggedInUserId'

      print('👤 UserId encontrado: $userId');

      if (userId != null) {
        final notificationsData =
            await NotificationService.getNotificationsByUserId(userId!);

        print('📱 Notificações recebidas no frontend: $notificationsData');

        if (notificationsData != null) {
          print('🔄 Convertendo dados para NotificationModel...');

          final convertedNotifications =
              notificationsData
                  .map((data) {
                    print('🔍 Convertendo: $data');
                    try {
                      final notification = NotificationModel.fromJson(data);
                      print('✅ Convertido com sucesso: ${notification.title}');
                      return notification;
                    } catch (e) {
                      print('❌ Erro ao converter: $e');
                      print('📊 Dados problemáticos: $data');
                      return null;
                    }
                  })
                  .where((notification) => notification != null)
                  .cast<NotificationModel>()
                  .toList();

          print(
            '🎉 Total de notificações convertidas: ${convertedNotifications.length}',
          );

          // Inicializar animações e status de leitura
          for (var notification in convertedNotifications) {
            // Criar controller de animação para cada notificação
            animationControllers[notification.id] = AnimationController(
              duration: const Duration(milliseconds: 300),
              vsync: this,
            );

            // Marcar como lida se o status for true (1)
            if (notification.status == true) {
              readNotifications[notification.id] = true;
              animationControllers[notification.id]?.forward();
            } else {
              // Se status for false (0), marcar como não lida
              readNotifications[notification.id] = false;
            }
          }

          setState(() {
            notifications = convertedNotifications;
            isLoading = false;
          });
        } else {
          print('❌ Nenhuma notificação recebida');
          setState(() {
            notifications = [];
            isLoading = false;
          });
        }
      } else {
        print('❌ UserId não encontrado');
        setState(() {
          notifications = [];
          isLoading = false;
        });
      }
    } catch (e) {
      print('💥 Erro ao carregar notificações: $e');
      setState(() {
        notifications = [];
        isLoading = false;
      });
    }
  }

  Future<void> _deleteAllNotifications() async {
    if (userId == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF2C2C2C),
            title: Text(
              'Limpar todas as notificações',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Tem certeza que deseja remover todas as notificações? Esta ação não pode ser desfeita.',
              style: GoogleFonts.inter(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'Cancelar',
                  style: GoogleFonts.inter(color: Colors.blue),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'Confirmar',
                  style: GoogleFonts.inter(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      final success = await NotificationService.deleteAllUserNotifications(
        userId!,
      );
      if (success) {
        setState(() {
          notifications.clear();
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Todas as notificações foram removidas',
                style: GoogleFonts.inter(color: Colors.white),
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      }
    }
  }

  Future<void> _deleteNotification(NotificationModel notification) async {
    final success = await NotificationService.deleteNotification(
      notification.id,
    );
    if (success) {
      setState(() {
        notifications.removeWhere((n) => n.id == notification.id);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Notificação removida',
              style: GoogleFonts.inter(color: Colors.white),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  void _showNotificationDetails(NotificationModel notification) {
    showDialog(
      context: context,
      builder:
          (context) => NotificationDetailDialog(notification: notification),
    );
  }

  Future<void> _markAsRead(NotificationModel notification) async {
    // Se já está lida, não fazer nada
    if (readNotifications[notification.id] == true) {
      return;
    }

    // Animar a transição para "lida"
    final controller = animationControllers[notification.id];
    if (controller != null) {
      await controller.forward();
    }

    // Marcar como lida localmente
    setState(() {
      readNotifications[notification.id] = true;
    });

    // Atualizar no backend
    try {
      final success = await NotificationService.updateNotificationStatus(
        notification.id,
      );
      if (success) {
        print('✅ Notificação marcada como lida no backend');
      } else {
        print('❌ Erro ao marcar notificação como lida no backend');
      }
    } catch (e) {
      print('💥 Erro ao atualizar status da notificação: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Notificações',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (notifications.isNotEmpty)
            TextButton(
              onPressed: _deleteAllNotifications,
              child: Text(
                'Excluir todas',
                style: GoogleFonts.inter(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child:
            isLoading
                ? const Center(
                  child: CircularProgressIndicator(color: Colors.blue),
                )
                : notifications.isEmpty
                ? _buildEmptyState()
                : _buildNotificationsList(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Ação para definir lembrete
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Funcionalidade em desenvolvimento',
                  style: GoogleFonts.inter(color: Colors.white),
                ),
                backgroundColor: Colors.orange,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            'Definir Lembrete',
            style: GoogleFonts.inter(
              fontSize: 16.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 80, color: Colors.grey[600]),
          const SizedBox(height: 16),
          Text(
            'Nenhuma notificação',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Complete hábitos para ver suas conquistas aqui!',
            style: GoogleFonts.inter(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    return RefreshIndicator(
      onRefresh: _loadNotifications,
      color: Colors.blue,
      backgroundColor: const Color(0xFF2C2C2C),
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return _buildNotificationItem(notification);
        },
      ),
    );
  }

  Widget _buildNotificationItem(NotificationModel notification) {
    final isRead = readNotifications[notification.id] ?? false;
    final controller = animationControllers[notification.id];

    return Container(
      height: 120, // Altura fixa para todos os boxes
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _markAsRead(notification);
            _showNotificationDetails(notification);
          },
          borderRadius: BorderRadius.circular(12.0),
          child: AnimatedBuilder(
            animation: controller ?? const AlwaysStoppedAnimation(0),
            builder: (context, child) {
              return Container(
                height: 120, // Altura fixa para todos os boxes
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color:
                      isRead
                          ? const Color(0xFF2C2C2C).withOpacity(0.7)
                          : const Color(0xFF2C2C2C),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color:
                        isRead
                            ? Colors.grey[600]!
                            : Colors.blue.withOpacity(0.3),
                    width: isRead ? 1 : 2,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            isRead
                                ? Colors.grey.withOpacity(0.2)
                                : Colors.blue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isRead ? Icons.mark_email_read : Icons.celebration,
                        color: isRead ? Colors.grey : Colors.blue,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Centraliza o conteúdo
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  notification.title,
                                  style: GoogleFonts.inter(
                                    color:
                                        isRead ? Colors.white70 : Colors.white,
                                    fontWeight:
                                        isRead
                                            ? FontWeight.normal
                                            : FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (!isRead)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Expanded(
                            child: Text(
                              notification.message,
                              style: GoogleFonts.inter(
                                color: isRead ? Colors.white54 : Colors.white70,
                                fontSize: 14.0,
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            notification.formattedDate,
                            style: GoogleFonts.inter(
                              color: isRead ? Colors.white38 : Colors.white54,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        color: isRead ? Colors.white54 : Colors.white70,
                      ),
                      color: const Color(0xFF2C2C2C),
                      onSelected: (value) {
                        if (value == 'delete') {
                          _deleteNotification(notification);
                        }
                      },
                      itemBuilder:
                          (context) => [
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Remover',
                                    style: GoogleFonts.inter(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Método para testar o processamento de lembretes
  Future<void> _testReminderProcessing() async {
    try {
      // Mostrar indicador de carregamento
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            ),
      );

      // Processar lembretes
      final result = await ReminderService.processReminders();

      // Fechar indicador de carregamento
      Navigator.of(context).pop();

      if (result != null) {
        // Recarregar notificações
        await _loadNotifications();

        // Mostrar mensagem de sucesso
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Lembretes processados com sucesso!',
                style: GoogleFonts.inter(color: Colors.white),
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      } else {
        // Mostrar mensagem de erro
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Erro ao processar lembretes',
                style: GoogleFonts.inter(color: Colors.white),
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      }
    } catch (e) {
      // Fechar indicador de carregamento se ainda estiver aberto
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      // Mostrar mensagem de erro
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro: $e',
              style: GoogleFonts.inter(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }
}
