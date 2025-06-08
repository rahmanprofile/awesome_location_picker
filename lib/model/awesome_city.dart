class Cities {
  final int id;
  final String name;
  final int stateId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Cities({
    required this.id,
    required this.name,
    required this.stateId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Cities.fromJson(Map<String, dynamic> json) {
    return Cities(
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
      other is Cities &&
          runtimeType == other.runtimeType &&
          id == other.id;
  @override
  int get hashCode => id.hashCode;
}
