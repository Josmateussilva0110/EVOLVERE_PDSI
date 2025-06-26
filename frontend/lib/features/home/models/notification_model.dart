class NotificationModel {
  final int id;
  final int userId;
  final String type;
  final String title;
  final String message;
  final int? habitId;
  final String? habitName;
  final String completedAt;
  final int? difficulty;
  final int? mood;
  final String? reflection;
  final String? location;
  final String? timeSpent;
  final String createdAt;
  final String updatedAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.habitId,
    this.habitName,
    required this.completedAt,
    this.difficulty,
    this.mood,
    this.reflection,
    this.location,
    this.timeSpent,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    print('🔍 NotificationModel.fromJson - Dados recebidos: $json');
    
    try {
      return NotificationModel(
        id: json['id'] ?? 0,
        userId: json['user_id'] ?? 0,
        type: json['type'] ?? '',
        title: json['title'] ?? '',
        message: json['message'] ?? '',
        habitId: json['habitId'],
        habitName: json['habitName'],
        completedAt: json['completedAt'] ?? '',
        difficulty: json['difficulty'],
        mood: json['mood'],
        reflection: json['reflection'],
        location: json['location'],
        timeSpent: json['timeSpent'],
        createdAt: json['created_at'] ?? '',
        updatedAt: json['updated_at'] ?? '',
      );
    } catch (e) {
      print('❌ Erro no NotificationModel.fromJson: $e');
      print('📊 JSON problemático: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'title': title,
      'message': message,
      'habitId': habitId,
      'habitName': habitName,
      'completedAt': completedAt,
      'difficulty': difficulty,
      'mood': mood,
      'reflection': reflection,
      'location': location,
      'timeSpent': timeSpent,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  String get formattedDate {
    try {
      final date = DateTime.parse(createdAt);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'Hoje';
      } else if (difference.inDays == 1) {
        return 'Ontem';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} dias atrás';
      } else {
        return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      }
    } catch (e) {
      print('❌ Erro ao formatar data: $e');
      return 'Data desconhecida';
    }
  }

  String get formattedTime {
    try {
      final date = DateTime.parse(createdAt);
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      print('❌ Erro ao formatar hora: $e');
      return '';
    }
  }

  String get difficultyText {
    switch (difficulty) {
      case 0:
        return 'Fácil';
      case 1:
        return 'Médio';
      case 2:
        return 'Difícil';
      default:
        return 'Não informado';
    }
  }

  String get moodText {
    switch (mood) {
      case 0:
        return 'Neutro';
      case 1:
        return 'Motivado';
      case 2:
        return 'Desanimado';
      default:
        return 'Não informado';
    }
  }
} 