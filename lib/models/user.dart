class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final DateTime createdAt;
  final bool isAdmin;
  final bool isActive;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    required this.createdAt,
    this.isAdmin = false,
    this.isActive = true,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      createdAt: DateTime.parse(json['createdAt']),
      isAdmin: json['isAdmin'] ?? false,
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'createdAt': createdAt.toIso8601String(),
      'isAdmin': isAdmin,
      'isActive': isActive,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    DateTime? createdAt,
    bool? isAdmin,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      isAdmin: isAdmin ?? this.isAdmin,
      isActive: isActive ?? this.isActive,
    );
  }
}
