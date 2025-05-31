class ResponsiveReading {
  final int id;
  final String name;
  final String title;
  final List<String> verse;

  ResponsiveReading({
    required this.id,
    required this.name,
    required this.title,
    required this.verse,
  });

  factory ResponsiveReading.fromJson(Map<String, dynamic> json) {
    return ResponsiveReading(
      id: json['id'],
      name: json['name'],
      title: json['title'],
      verse: List<String>.from(json['verse']),
    );
  }
}