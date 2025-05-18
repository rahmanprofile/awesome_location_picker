class AwesomeCountry {
  final int id;
  final String name;
  final String emoji;
  final String emojiU;
  final DateTime createdAt;
  final DateTime updatedAt;

  AwesomeCountry({
    required this.id,
    required this.name,
    required this.emoji,
    required this.emojiU,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AwesomeCountry.fromJson(Map<String, dynamic> json) {
    return AwesomeCountry(
      id: json['id'],
      name: json['name'],
      emoji: json['emoji'],
      emojiU: json['emojiU'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
