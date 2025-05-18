import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class GuruPamongService {
  static final box = GetStorage();
  static const String baseUrl =
      'http://10.0.2.2:8000/api'; // Ganti jika pakai device fisik

  static Future<List<Map<String, dynamic>>> getAllGuruPamong() async {
    final token = box.read('token');

    final response = await http.get(
      Uri.parse('$baseUrl/akun/pamong'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      final List<dynamic> users = decoded['users'];
      return users.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Gagal mengambil data Guru Pamong');
    }
  }
}
