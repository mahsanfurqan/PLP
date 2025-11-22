import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:plp/models/user_model.dart'; // pastikan path sesuai
import 'package:plp/config/app_config.dart';

class AkunService {
  static const String _baseUrl = AppConfig.baseUrl;
  static final box = GetStorage();

  static String? getToken() {
    return box.read("token");
  }

  /// ✅ Ambil semua user dengan role Dosen Pembimbing
  static Future<List<UserModel>> getAllUsersByRole(String role) async {
    final token = getToken();
    if (token == null) throw Exception("Token tidak ditemukan.");

    // Sesuaikan endpoint berdasarkan role, bisa dibuat dinamis nanti
    Uri url;
    if (role == "Dosen Pembimbing") {
      url = Uri.parse("$_baseUrl/akun/dospem");
    } else {
      throw Exception("Role tidak dikenali: $role");
    }

    final response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> userList = json['users'];
      return userList.map((userJson) => UserModel.fromJson(userJson)).toList();
    } else {
      final json = jsonDecode(response.body);
      throw Exception(json['message'] ?? 'Gagal mengambil data user');
    }
  }

  /// 👤 Ambil semua user (untuk mapping nama)
  static Future<List<UserModel>> getAllUsers() async {
    final token = getToken();
    if (token == null) throw Exception("Token tidak ditemukan.");

    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/users"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((userJson) => UserModel.fromJson(userJson)).toList();
      } else {
        throw Exception('Gagal mengambil data semua user');
      }
    } catch (e) {
      return [];
    }
  }

  /// 👤 Ambil nama user berdasarkan ID
  static Future<String> getUserNameById(int userId) async {
    final token = getToken();
    if (token == null) throw Exception("Token tidak ditemukan.");

    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/users/$userId"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['name'] ?? 'Unknown User';
      } else {
        return 'User ID: $userId';
      }
    } catch (e) {
      return 'User ID: $userId';
    }
  }

  /// 👤 Buat akun baru (Akademik only)
  static Future<Map<String, dynamic>> createAccount({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String role,
    Map<String, dynamic>? details,
  }) async {
    final token = getToken();
    if (token == null) throw Exception("Token tidak ditemukan.");

    final requestBody = {
      "name": name,
      "email": email,
      "password": password,
      "password_confirmation": passwordConfirmation,
      "role": role,
      if (details != null) "details": details,
    };

    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/pembuatan-akun"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      final json = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json;
      } else {
        final message = json['message'] ?? 'Gagal membuat akun';
        throw Exception(message);
      }
    } catch (e) {
      rethrow;
    }
  }
}
