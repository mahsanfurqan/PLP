import 'dart:convert';
import 'dart:developer'; // Untuk log
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class KeminatanService {
  static const String _baseUrl = "http://10.0.2.2:8000/api";

  /// Ambil semua keminatan (GET)
  static Future<List<Map<String, dynamic>>> getKeminatan() async {
    final box = GetStorage();
    final token = box.read("token");

    if (token == null) throw Exception("Token tidak ditemukan.");

    final response = await http.get(
      Uri.parse("$_baseUrl/keminatan"),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    log('🔵 Response Status: ${response.statusCode}');
    log('🔵 Response Body: ${response.body}');

    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> data = json;
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      log('🔴 Error Message: ${json['message']}');
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

    log('🟡 POST Response Status: ${response.statusCode}');
    log('🟡 POST Response Body: ${response.body}');

    final json = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      log('✅ Keminatan berhasil ditambahkan: ${json['message']}');
    } else {
      throw Exception(json['message'] ?? 'Gagal menambahkan keminatan');
    }
  }
}
