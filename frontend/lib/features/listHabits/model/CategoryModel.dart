class Category {
  final int id;
  final String name;
  final String description;
  final String color;
  final String icon;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.icon,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      color: json['color'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}
