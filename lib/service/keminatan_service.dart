import 'dart:convert';
import 'dart:developer'; // Menambahkan import log
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class KeminatanService {
  static const String _baseUrl = "http://10.0.2.2:8000/api";

  static Future<List<Map<String, dynamic>>> getKeminatan() async {
    final box = GetStorage();
    final token = box.read("token");

    if (token == null) throw Exception("Token tidak ditemukan.");

    final response = await http.get(
      Uri.parse("$_baseUrl/keminatan"),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    log('Response Status: ${response.statusCode}'); // Log status code
    log('Response Body: ${response.body}'); // Log response body

    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> data = json;
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      log('Error Message: ${json['message']}'); // Log error message
      throw Exception(
        json['message'] ?? 'Terjadi kesalahan saat mengambil data keminatan',
      );
    }
  }
}
