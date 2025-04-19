import 'dart:convert';
import 'dart:developer'; // Untuk log
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class SmkService {
  static const String _baseUrl = "http://10.0.2.2:8000/api";

  static Future<List<Map<String, dynamic>>> getSmks() async {
    final box = GetStorage();
    final token = box.read("token");

    if (token == null) throw Exception("Token tidak ditemukan.");

    final response = await http.get(
      Uri.parse("$_baseUrl/smk"),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    log('🔵 SMK Response Status: ${response.statusCode}');
    log('🔵 SMK Response Body: ${response.body}');

    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> data = json;
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      log('🔴 SMK Error Message: ${json['message']}');
      throw Exception(json['message'] ?? 'Gagal mengambil data SMK');
    }
  }
}
