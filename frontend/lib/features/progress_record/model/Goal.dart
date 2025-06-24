class Goal {
  final String title;
  final String type;
  final int? progress;
  final int? total;
  final bool isProgressBar;

  Goal({
    required this.title,
    required this.type,
    this.progress,
    this.total,
    this.isProgressBar = false,
  });
}
