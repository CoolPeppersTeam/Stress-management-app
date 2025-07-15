//затычка чтобы у вас это отобразилось

class Recommendation {
  final int id;
  final String title;
  final String description;

  Recommendation({required this.id, required this.title, required this.description});

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    final id = json['id'] ?? json['ID'];
    if (id == null) throw Exception('Incorrect data: id == null');
    return Recommendation(
      id: id as int,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}
