import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:plp/models/pendaftaranplp_model.dart';

class PendaftaranPlpService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api';

  /// 🔐 Ambil token dari storage
  static String? getToken() {
    final box = GetStorage();
    return box.read("token");
  }

  /// ✅ Submit data pendaftaran PLP
  static Future<PendaftaranPlpModel> submitPendaftaranPlp({
    required int keminatanId,
    required String nilaiPlp1,
    required String nilaiMicroTeaching,
    required int pilihanSmk1,
    required int pilihanSmk2,
  }) async {
    final token = getToken();
    if (token == null) throw Exception("Token tidak ditemukan.");

    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/pendaftaran-plp"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'keminatan_id': keminatanId,
          'nilai_plp_1': nilaiPlp1,
          'nilai_micro_teaching': nilaiMicroTeaching,
          'pilihan_smk_1': pilihanSmk1,
          'pilihan_smk_2': pilihanSmk2,
        }),
      );

      final json = jsonDecode(response.body);
      print("🟡 Status: ${response.statusCode}");
      print("🟡 Response: $json");

      // Asumsikan kalau message-nya sukses tapi status code bukan 200
      if (json['status'] == 'success' && json['data'] != null) {
        return PendaftaranPlpModel.fromJson(json['data']);
      }

      // Kalau status gagal
      final message = json['message'] ?? 'Gagal mendaftar PLP.';
      throw Exception(message);
    } catch (e) {
      // Biarkan exception tetap ditampilkan seperti aslinya
      rethrow;
    }
  }

  /// 🔍 Cek apakah user sudah pernah mendaftar
  static Future<bool> cekSudahDaftar() async {
    final token = getToken();
    if (token == null) throw Exception("Token tidak ditemukan.");

    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/pendaftaran-plp"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print("Response JSON: $json"); // Log response body untuk debug

        // Periksa apakah data pendaftaran ada
        if (json['data'] != null && json['data'].isNotEmpty) {
          return true; // Sudah terdaftar
        } else {
          return false; // Belum terdaftar
        }
      } else {
        throw Exception(
          "Gagal mengecek status pendaftaran. Status: ${response.statusCode}, Body: ${response.body}",
        );
      }
    } catch (e) {
      print("Error saat mengecek status pendaftaran: $e");
      throw Exception("Gagal mengecek status pendaftaran: $e");
    }
  }
}
