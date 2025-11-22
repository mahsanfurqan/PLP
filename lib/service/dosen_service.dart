import 'dart:convert';
import 'dart:developer';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:plp/models/user_model.dart'; // Ganti jika model usermu beda
import 'package:plp/config/app_config.dart';

class DosenService {
  static const String _baseUrl = AppConfig.baseUrl;
  static final box = GetStorage();

  static String? getToken() {
    return box.read("token");
  }

  /// ✅ Ambil semua user dengan role "Dosen Pembimbing"
  static Future<List<UserModel>> getDosenPembimbing() async {
    final token = getToken();
    if (token == null) throw Exception("Token tidak ditemukan.");

    final url = Uri.parse("$_baseUrl/users?role=Dosen Pembimbing");

    final response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    log('🟦 Dosen Response Status: ${response.statusCode}');
    log('🟦 Dosen Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => UserModel.fromJson(item)).toList();
    } else {
      final json = jsonDecode(response.body);
      throw Exception(json['message'] ?? 'Gagal mengambil data dosen');
    }
  }
}
