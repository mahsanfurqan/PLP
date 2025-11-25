import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:plp/models/logbook_model.dart';
import 'package:plp/config/app_config.dart';

class LogbookService {
  static const String _baseUrl = AppConfig.baseUrl;
  static final box = GetStorage();

  /// 🔐 Ambil token dari storage
  static String? _getToken() {
    return box.read('token');
  }

  /// 📋 GET - Ambil semua logbook user
  static Future<List<LogbookModel>> getLogbooks() async {
    final token = _getToken();
    if (token == null) throw Exception('Token tidak ditemukan.');

    final response = await http.get(
      Uri.parse('$_baseUrl/logbooks'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => LogbookModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat logbook');
    }
  }

  /// ➕ POST - Tambah logbook baru
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
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'tanggal': tanggal,
        'keterangan': keterangan,
        'mulai': mulai,
        'selesai': selesai,
        'dokumentasi': dokumentasi,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Gagal menambahkan logbook');
    }
  }

  /// ✏️ PUT - Update logbook
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
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'tanggal': tanggal,
        'keterangan': keterangan,
        'mulai': mulai,
        'selesai': selesai,
        'dokumentasi': dokumentasi,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Gagal memperbarui logbook');
    }
  }

  /// 🗑️ DELETE - Hapus logbook
  static Future<void> deleteLogbook(int id) async {
    final token = _getToken();
    if (token == null) throw Exception('Token tidak ditemukan.');

    final response = await http.delete(
      Uri.parse('$_baseUrl/logbooks/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Gagal menghapus logbook');
    }
  }

  /// 📚 GET - Ambil semua logbook mahasiswa (untuk koordinator)
  static Future<List<LogbookModel>> getAllLogbooks() async {
    final token = _getToken();
    if (token == null) throw Exception('Token tidak ditemukan.');

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/logbooks/all'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => LogbookModel.fromJson(e)).toList();
      } else if (response.statusCode == 403) {
        // Unauthorized - throw specific error to trigger fallback
        throw Exception('Unauthorized access');
      } else {
        final errorMsg =
            jsonDecode(response.body)['message'] ??
            'Gagal memuat semua logbook mahasiswa';
        throw Exception(errorMsg);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// ✅ GET - Ambil logbook untuk validasi (Guru & Dosen Pembimbing)
  static Future<List<LogbookModel>> getLogbooksForValidation() async {
    final token = _getToken();
    if (token == null) throw Exception('Token tidak ditemukan.');

    final response = await http.get(
      Uri.parse('$_baseUrl/logbooks/validasi'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => LogbookModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat logbook untuk validasi');
    }
  }

  /// ✔️ PUT - Update status validasi logbook
  static Future<bool> updateValidationStatus(int id, String status) async {
    final token = _getToken();
    if (token == null) throw Exception('Token tidak ditemukan.');

    final response = await http.put(
      Uri.parse('$_baseUrl/logbooks/validasi/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Gagal memperbarui status validasi');
    }
  }
}
