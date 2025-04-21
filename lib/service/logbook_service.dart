import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:plp/models/logbook_model.dart';

class LogbookService {
  static const baseUrl = 'http://10.0.2.2:8000/api/logbooks';
  static final box = GetStorage();

  /// GET all logbooks (READ)
  static Future<List<LogbookModel>> getLogbooks() async {
    final token = box.read('token');

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => LogbookModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat logbook');
    }
  }

  /// POST create logbook (CREATE)
  static Future<LogbookModel> createLogbook(LogbookModel logbook) async {
    final token = box.read('token');

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(logbook.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return LogbookModel.fromJson(data['logbook']);
    } else {
      throw Exception('Gagal menambahkan logbook');
    }
  }

  /// PUT update logbook (UPDATE)
  static Future<LogbookModel> updateLogbook(
    int id,
    LogbookModel logbook,
  ) async {
    final token = box.read('token');

    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(logbook.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return LogbookModel.fromJson(data['logbook']);
    } else {
      throw Exception('Gagal memperbarui logbook');
    }
  }

  /// DELETE logbook (DELETE)
  static Future<void> deleteLogbook(int id) async {
    final token = box.read('token');

    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus logbook');
    }
  }
}
