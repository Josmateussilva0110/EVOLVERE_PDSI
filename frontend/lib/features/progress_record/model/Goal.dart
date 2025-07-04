class Goal {
  final int? id;
  final String title;
  final String type;
  final int? progress;
  final int? total;
  final bool isProgressBar;
  final String? status;

  Goal({
    this.id,
    required this.title,
    required this.type,
    this.progress,
    this.total,
    this.isProgressBar = false,
    this.status,
  });
}
