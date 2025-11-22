import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plp/config/app_config.dart';

class AuthService {
  static const String baseUrl = AppConfig.baseUrl;

  static Future<http.Response> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) {
    name = name.isEmpty ? 'Unknown' : name;

    final url = Uri.parse('$baseUrl/register');

    return http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation,
      }),
    );
  }

  static Future<http.Response> login({
    required String email,
    required String password,
  }) {
    final url = Uri.parse('$baseUrl/login');

    return http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({"email": email, "password": password}),
    );
  }

  static Future<http.Response> requestPasswordReset({
    required String email,
  }) async {
    final url = Uri.parse('$baseUrl/forgot-password');

    return await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'email': email}),
    );
  }
}
