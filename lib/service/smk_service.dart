import 'dart:convert';
import 'dart:developer'; // Untuk logging
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:plp/models/smk_model.dart'; // Pastikan import modelnya
import 'package:plp/config/app_config.dart';

class SmkService {
  static const String _baseUrl = AppConfig.baseUrl;
  static final box = GetStorage();

  /// 🔐 Ambil token dari storage
  static String? getToken() {
    return box.read("token");
  }

  /// ✅ Ambil semua SMK
  static Future<List<SmkModel>> getSmks() async {
    final token = getToken();
    if (token == null) throw Exception("Token tidak ditemukan.");

    final response = await http.get(
      Uri.parse("$_baseUrl/smk"),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    log('🔵 SMK Response Status: ${response.statusCode}');
    log('🔵 SMK Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => SmkModel.fromJson(item)).toList();
    } else {
      final json = jsonDecode(response.body);
      log('🔴 SMK Error Message: ${json['message']}');
      throw Exception(json['message'] ?? 'Gagal mengambil data SMK');
    }
  }

  /// ✅ Tambah SMK baru
  static Future<SmkModel> addSmk(String name) async {
    final token = getToken();
    if (token == null) throw Exception("Token tidak ditemukan.");

    final response = await http.post(
      Uri.parse("$_baseUrl/smk"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'name': name}),
    );

    log('🟣 Tambah SMK Status: ${response.statusCode}');
    log('🟣 Tambah SMK Response: ${response.body}');

    final json = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return SmkModel.fromJson(json['smk']);
    } else {
      throw Exception(json['message'] ?? 'Gagal menambah SMK');
    }
  }
}
