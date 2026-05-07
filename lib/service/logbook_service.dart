import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:plp/config/app_config.dart';
import 'package:plp/models/logbook_group_model.dart';
import 'package:plp/models/logbook_model.dart';

class LogbookService {
  static const String _baseUrl = AppConfig.baseUrl;
  static final GetStorage _box = GetStorage();

  static String? _getToken() => _box.read('token');

  static Map<String, String> _headers(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }

  static Future<List<LogbookModel>> getLogbooks() async {
    final token = _getToken();
    if (token == null) throw Exception('Token tidak ditemukan.');

    final response = await http.get(
      Uri.parse('$_baseUrl/logbooks'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .whereType<Map<String, dynamic>>()
          .map(LogbookModel.fromJson)
          .toList();
    }

    throw Exception('Gagal memuat logbook');
  }

  static Future<Map<String, dynamic>> getIntegrityPactStatus() async {
    final token = _getToken();
    if (token == null) throw Exception('Token tidak ditemukan.');

    final response = await http.get(
      Uri.parse('$_baseUrl/logbooks/integrity-pact'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw Exception('Gagal memuat status pakta integritas');
  }

  static Future<void> acceptIntegrityPact() async {
    final token = _getToken();
    if (token == null) throw Exception('Token tidak ditemukan.');

    final response = await http.post(
      Uri.parse('$_baseUrl/logbooks/integrity-pact'),
      headers: _headers(token),
      body: jsonEncode({'accepted': true}),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      Map<String, dynamic>? data;
      try {
        data = jsonDecode(response.body) as Map<String, dynamic>?;
      } catch (_) {}

      throw Exception(
        data?['message'] ?? 'Gagal menyetujui pakta integritas',
      );
    }
  }

  static Future<void> createLogbookRaw({
    required String tanggal,
    required String keterangan,
    required String mulai,
    required String selesai,
    required String dokumentasi,
  }) async {
    final token = _getToken();
    if (token == null) throw Exception('Token tidak ditemukan.');

    final response = await http.post(
      Uri.parse('$_baseUrl/logbooks'),
      headers: _headers(token),
      body: jsonEncode({
        'tanggal': tanggal,
        'keterangan': keterangan,
        'mulai': mulai,
        'selesai': selesai,
        'dokumentasi': dokumentasi,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      final Map<String, dynamic>? data =
          jsonDecode(response.body) as Map<String, dynamic>?;
      throw Exception(data?['message'] ?? 'Gagal menambahkan logbook');
    }
  }

  static Future<void> updateLogbook(
    int id, {
    required String tanggal,
    required String keterangan,
    required String mulai,
    required String selesai,
    required String dokumentasi,
  }) async {
    final token = _getToken();
    if (token == null) throw Exception('Token tidak ditemukan.');

    final response = await http.put(
      Uri.parse('$_baseUrl/logbooks/$id'),
      headers: _headers(token),
      body: jsonEncode({
        'tanggal': tanggal,
        'keterangan': keterangan,
        'mulai': mulai,
        'selesai': selesai,
        'dokumentasi': dokumentasi,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      Map<String, dynamic>? data;
      try {
        data = jsonDecode(response.body) as Map<String, dynamic>?;
      } catch (_) {}

      throw Exception(
        data?['message'] ??
            'Gagal memperbarui logbook (HTTP ${response.statusCode})',
      );
    }
  }

  static Future<void> deleteLogbook(int id) async {
    final token = _getToken();
    if (token == null) throw Exception('Token tidak ditemukan.');

    final response = await http.delete(
      Uri.parse('$_baseUrl/logbooks/$id'),
      headers: _headers(token),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      Map<String, dynamic>? data;
      try {
        data = jsonDecode(response.body) as Map<String, dynamic>?;
      } catch (_) {}

      throw Exception(
        data?['message'] ??
            'Gagal menghapus logbook (HTTP ${response.statusCode})',
      );
    }
  }

  static Future<List<LogbookModel>> getAllLogbooks() async {
    final token = _getToken();
    if (token == null) throw Exception('Token tidak ditemukan.');

    final response = await http.get(
      Uri.parse('$_baseUrl/logbooks/all'),
      headers: _headers(token),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .whereType<Map<String, dynamic>>()
          .map(LogbookModel.fromJson)
          .toList();
    }

    if (response.statusCode == 403) {
      throw Exception('Unauthorized access');
    }

    final Map<String, dynamic>? errorBody =
        jsonDecode(response.body) as Map<String, dynamic>?;
    throw Exception(
      errorBody?['message'] ?? 'Gagal memuat semua logbook mahasiswa',
    );
  }

  static Future<List<LogbookGroupModel>> getLogbookGroups() async {
    final token = _getToken();
    if (token == null) throw Exception('Token tidak ditemukan.');

    final response = await http.get(
      Uri.parse('$_baseUrl/logbooks/groups'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .whereType<Map<String, dynamic>>()
          .map(LogbookGroupModel.fromJson)
          .toList();
    }

    final Map<String, dynamic>? errorBody =
        jsonDecode(response.body) as Map<String, dynamic>?;
    throw Exception(
      errorBody?['message'] ?? 'Gagal memuat kelompok logbook mahasiswa',
    );
  }

  static Future<List<LogbookModel>> getLogbooksForValidation() async {
    final token = _getToken();
    if (token == null) throw Exception('Token tidak ditemukan.');

    final response = await http.get(
      Uri.parse('$_baseUrl/logbooks/validasi'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .whereType<Map<String, dynamic>>()
          .map(LogbookModel.fromJson)
          .toList();
    }

    throw Exception('Gagal memuat logbook untuk validasi');
  }

  static Future<bool> updateValidationStatus(
    int id,
    String status, {
    String? note,
  }) async {
    final token = _getToken();
    if (token == null) throw Exception('Token tidak ditemukan.');

    final response = await http.put(
      Uri.parse('$_baseUrl/logbooks/validasi/$id'),
      headers: _headers(token),
      body: jsonEncode({
        'status': status,
        'note': note,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    }

    final Map<String, dynamic>? data =
        jsonDecode(response.body) as Map<String, dynamic>?;
    throw Exception(data?['message'] ?? 'Gagal memperbarui status validasi');
  }
}
