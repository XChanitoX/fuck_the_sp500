class Portfolio {
  final String id;
  final String name;
  final String? description;
  final String ownerUserId; // For future auth integration
  final DateTime createdAt;

  Portfolio({
    required this.id,
    required this.name,
    required this.ownerUserId,
    required this.createdAt,
    this.description,
  });

  factory Portfolio.fromJson(Map<String, dynamic> json) {
    return Portfolio(
      id: json['id'] as String,
      name: json['name'] as String,
      ownerUserId: json['ownerUserId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'ownerUserId': ownerUserId,
        'createdAt': createdAt.toIso8601String(),
      };
}
