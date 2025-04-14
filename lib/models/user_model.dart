class UserModel {
  final int id;
  final String name;
  final String email;
  final String? role; // ubah ke nullable

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.role, // tidak wajib di constructor
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    role: json['role'], // tidak ada fallback 'Observer'
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    if (role != null) 'role': role,
  };
}
