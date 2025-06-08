class States {
  final int id;
  final String name;
  final int countryId;
  final DateTime createdAt;
  final DateTime updatedAt;

  States({
    required this.id,
    required this.name,
    required this.countryId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory States.fromJson(Map<String, dynamic> json) {
    return States(
      id: json['id'],
      name: json['name'],
      countryId: json['country_id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
