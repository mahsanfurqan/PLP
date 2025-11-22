import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:plp/models/pendaftaranplp_model.dart';
import 'package:plp/config/app_config.dart';

class PendaftaranPlpService {
  static const String _baseUrl = AppConfig.baseUrl;

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

      final isSuccess =
          response.statusCode == 200 || response.statusCode == 201;

      if (isSuccess) {
        // Gunakan field yang tersedia di respons
        final data = json['data'] ?? json['pendaftaran_plp'];
        if (data != null) {
          return PendaftaranPlpModel.fromJson(data);
        }
      }

      final message = json['message'] ?? 'Gagal mendaftar PLP.';
      throw Exception(message);
    } catch (e) {
      print("🛑 Error di submitPendaftaranPlp: $e");
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

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        print("Response JSON: $decoded");

        return decoded is List && decoded.isNotEmpty;
      } else {
        throw Exception(
          "Gagal mengecek status pendaftaran. Status: ${response.statusCode}, Body: ${response.body}",
        );
      }
    } catch (e) {
      print("🛑 Error saat mengecek status pendaftaran: $e");
      throw Exception("Gagal mengecek status pendaftaran.");
    }
  }

  /// 📄 Ambil data pendaftaran PLP untuk ditampilkan
  static Future<List<PendaftaranPlpModel>> getPendaftaranPlpData() async {
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);

        if (decoded is List) {
          return decoded
              .map((item) => PendaftaranPlpModel.fromJson(item))
              .toList();
        } else {
          throw Exception("Format respons tidak sesuai (bukan List)");
        }
      } else {
        throw Exception(
          "Gagal mengambil data pendaftaran. Status: ${response.statusCode}, Body: ${response.body}",
        );
      }
    } catch (e) {
      print("🛑 Error saat mengambil data pendaftaran: $e");
      rethrow;
    }
  }

  /// 📋 Koordinator: Ambil semua pendaftaran PLP
  static Future<List<PendaftaranPlpModel>> getAllPendaftaranPlp() async {
    final token = getToken();
    if (token == null) throw Exception("Token tidak ditemukan.");

    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/pendaftaran-plp/all"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("🟢 Status Code: ${response.statusCode}");
      print("🟢 Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);

        if (decoded is List) {
          // Debug: Analyze the first item in the list
          if (decoded.isNotEmpty) {
            print('🔍 First registration item analysis:');
            final firstItem = decoded.first as Map<String, dynamic>;
            firstItem.forEach((key, value) {
              print('   - $key: $value');
            });

            // Check if required fields exist
            final hasDosenPembimbing = firstItem.containsKey(
              'dosen_pembimbing',
            );
            final hasGuruPamong = firstItem.containsKey('guru_pamong');
            print('🔍 Field check:');
            print('   - dosen_pembimbing exists: $hasDosenPembimbing');
            print('   - guru_pamong exists: $hasGuruPamong');
          }

          return decoded
              .map((item) => PendaftaranPlpModel.fromJson(item))
              .toList();
        } else {
          throw Exception("Format respons tidak sesuai (bukan List)");
        }
      } else {
        throw Exception(
          "Gagal mengambil semua pendaftaran. Status: ${response.statusCode}",
        );
      }
    } catch (e) {
      print("🛑 Error saat getAllPendaftaranPlp: $e");
      rethrow;
    }
  }

  /// 📌 Assign penempatan dan dosen pembimbing oleh koordinator
  static Future<void> assignPenempatanDospem({
    required int pendaftaranId,
    required int idSmk,
    required int idDospem,
    int? idGuruPamong,
  }) async {
    final token = getToken();
    if (token == null) throw Exception("Token tidak ditemukan.");

    // Prepare request body
    final requestBody = {
      "penempatan": idSmk,
      "dosen_pembimbing": idDospem,
      "guru_pamong": idGuruPamong, // Always send guru_pamong, even if null
    };

    print('🟠 Request Body: ${jsonEncode(requestBody)}');
    print('🟠 Pendaftaran ID: $pendaftaranId');
    print('🟠 SMK ID: $idSmk');
    print('🟠 Dospem ID: $idDospem');
    print('🟠 Guru ID: $idGuruPamong');

    final response = await http.patch(
      Uri.parse("$_baseUrl/pendaftaran-plp/$pendaftaranId"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(requestBody),
    );

    print('🟠 PATCH Assign: ${response.statusCode}');
    print('🟠 Response: ${response.body}');

    final json = jsonDecode(response.body);

    // Debug: Analyze the response JSON structure
    print('🔍 Response JSON analysis:');
    json.forEach((key, value) {
      print('   - $key: $value');
    });

    // Check if response is successful (200, 201, or 202)
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      // Success - don't throw exception
      print('✅ Assignment successful (status code: ${response.statusCode})');

      // Additional validation: check if the response contains updated data
      if (json.containsKey('data') || json.containsKey('pendaftaran_plp')) {
        final data = json['data'] ?? json['pendaftaran_plp'];
        print('✅ Response contains updated data: $data');
      }

      return;
    } else {
      // Check if the response message indicates success despite non-200 status
      final message = json['message'] ?? '';
      print('🟡 Response message: $message');

      if (message.toLowerCase().contains('berhasil') ||
          message.toLowerCase().contains('success')) {
        print('✅ Assignment successful (based on message)');
        return;
      }

      // If not successful, throw exception
      print('❌ Assignment failed: ${json['message']}');
      throw Exception(json['message'] ?? 'Gagal assign penempatan/dospem');
    }
  }
}
