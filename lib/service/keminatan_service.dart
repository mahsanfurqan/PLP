import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:plp/config/app_config.dart';

class KeminatanService {
  static const String _baseUrl = AppConfig.baseUrl;

  /// Ambil semua keminatan (GET)
  static Future<List<Map<String, dynamic>>> getKeminatan() async {
    final box = GetStorage();
    final token = box.read("token");

    if (token == null) throw Exception("Token tidak ditemukan.");

    final response = await http.get(
      Uri.parse("$_baseUrl/keminatan"),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> data = json;
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception(
        json['message'] ?? 'Terjadi kesalahan saat mengambil data keminatan',
      );
    }
  }

  /// Tambah keminatan baru (POST)
  static Future<void> addKeminatan(String namaKeminatan) async {
    final box = GetStorage();
    final token = box.read("token");

    if (token == null) throw Exception("Token tidak ditemukan.");

    final response = await http.post(
      Uri.parse("$_baseUrl/keminatan"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': namaKeminatan}),
    );

    final json = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      throw Exception(json['message'] ?? 'Gagal menambahkan keminatan');
    }
  }
}
