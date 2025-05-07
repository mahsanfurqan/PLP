import 'dart:convert';

class DospemUser {
  final int id;
  final String name;
  final String email;
  final String role;
  final Map<String, dynamic>? details;
  final String? temporaryPassword;

  DospemUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.details,
    this.temporaryPassword,
  });

  factory DospemUser.fromJson(Map<String, dynamic> json) {
    return DospemUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      details:
          json['details'] != null
              ? Map<String, dynamic>.from(jsonDecode(json['details']))
              : null,
      temporaryPassword: json['temporary_password'],
    );
  }
}
