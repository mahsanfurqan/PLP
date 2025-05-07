import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:plp/models/user_model.dart'; // pastikan path sesuai

class AkunService {
  static const String _baseUrl = "http://10.0.2.2:8000/api";
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
}
