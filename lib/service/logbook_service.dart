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

  /// POST create logbook (RAW input sesuai API docs)
  static Future<void> createLogbookRaw({
    required String tanggal,
    required String keterangan,
    required String mulai,
    required String selesai,
    required String dokumentasi,
  }) async {
    final token = box.read('token');

    final response = await http.post(
      Uri.parse(baseUrl),
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

  /// PUT update logbook (UPDATE)
  static Future<void> updateLogbook(
    int id, {
    required String tanggal,
    required String keterangan,
    required String mulai,
    required String selesai,
    required String dokumentasi,
  }) async {
    final token = box.read('token');

    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
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

  /// DELETE logbook (DELETE)
  static Future<void> deleteLogbook(int id) async {
    final token = box.read('token');

    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      // Cetak isi response untuk debugging
      print("Error response body: ${response.body}");
      throw Exception('Gagal menghapus logbook');
    } else {
      print('Logbook berhasil dihapus');
    }
  }

  /// 🔍 Ambil semua logbook mahasiswa untuk koordinator
  static Future<List<LogbookModel>> getAllLogbooks() async {
    final token = box.read('token');
    if (token == null) throw Exception('Token tidak ditemukan.');

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/logbooks/all'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print("Status Code (All Logbooks): ${response.statusCode}");
      print("Response Body (All Logbooks): ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => LogbookModel.fromJson(e)).toList();
      } else {
        throw Exception('Gagal memuat semua logbook mahasiswa');
      }
    } catch (e) {
      print("🛑 Error saat mengambil semua logbook: $e");
      rethrow;
    }
  }

  // Ambil list logbook untuk validasi khusus Guru & Dosen Pembimbing
  static Future<List<LogbookModel>> getLogbooksForValidation() async {
    final token = box.read('token');

    final response = await http.get(
      Uri.parse('$baseUrl/validasi'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    print("Status Code (Logbooks Validasi): ${response.statusCode}");
    print("Response Body (Logbooks Validasi): ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => LogbookModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat logbook untuk validasi');
    }
  }

  // PUT validasi logbook
  static Future<bool> updateValidationStatus(int id, String status) async {
    final token = box.read('token') ?? '';

    final response = await http.put(
      Uri.parse('$baseUrl/validasi/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({'status': status}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Gagal memperbarui status validasi');
    }
  }
}
