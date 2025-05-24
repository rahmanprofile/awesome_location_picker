class AwesomeCity {
  final int id;
  final String name;
  final int stateId;
  final DateTime createdAt;
  final DateTime updatedAt;

  AwesomeCity({
    required this.id,
    required this.name,
    required this.stateId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AwesomeCity.fromJson(Map<String, dynamic> json) {
    return AwesomeCity(
      id: json['id'],
      name: json['name'],
      stateId: json['state_id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AwesomeCity &&
          runtimeType == other.runtimeType &&
          id == other.id;
  @override
  int get hashCode => id.hashCode;
}
