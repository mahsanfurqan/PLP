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

      final isSuccess =
          response.statusCode == 200 || response.statusCode == 201;

      if (isSuccess) {
        final data = json['data'] ?? json['pendaftaran_plp'];
        if (data != null) {
          return PendaftaranPlpModel.fromJson(data);
        }
      }

      final message = json['message'] ?? 'Gagal mendaftar PLP.';
      throw Exception(message);
    } catch (e) {
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

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        return decoded is List && decoded.isNotEmpty;
      } else {
        throw Exception(
          "Gagal mengecek status pendaftaran. Status: ${response.statusCode}, Body: ${response.body}",
        );
      }
    } catch (e) {
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
          "Gagal mengambil semua pendaftaran. Status: ${response.statusCode}",
        );
      }
    } catch (e) {
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
    await _sendAssignRequest(
      pendaftaranId: pendaftaranId,
      requestBody: {
        "penempatan": idSmk,
        "dosen_pembimbing": idDospem,
        "guru_pamong": idGuruPamong,
      },
    );
  }

  static Future<void> assignPenempatanDospemWithIdKeys({
    required int pendaftaranId,
    required int idSmk,
    required int idDospem,
    int? idGuruPamong,
  }) async {
    await _sendAssignRequest(
      pendaftaranId: pendaftaranId,
      requestBody: {
        "penempatan_id": idSmk,
        "dosen_pembimbing_id": idDospem,
        "guru_pamong_id": idGuruPamong,
      },
    );
  }

  static Future<void> assignPenempatanDospemWithLegacyKeys({
    required int pendaftaranId,
    required int idSmk,
    required int idDospem,
    int? idGuruPamong,
  }) async {
    await _sendAssignRequest(
      pendaftaranId: pendaftaranId,
      requestBody: {
        "id_smk": idSmk,
        "id_dosen_pembimbing": idDospem,
        "id_guru_pamong": idGuruPamong,
      },
    );
  }

  /// 📌 Assign fleksibel untuk kompatibilitas variasi key backend
  static Future<void> assignPenempatanDospemFlexible({
    required int pendaftaranId,
    required int idSmk,
    required int idDospem,
    int? idGuruPamong,
  }) async {
    final strategies = [
      {
        "penempatan": idSmk,
        "dosen_pembimbing": idDospem,
        "guru_pamong": idGuruPamong,
      },
      {
        "penempatan_id": idSmk,
        "dosen_pembimbing_id": idDospem,
        "guru_pamong_id": idGuruPamong,
      },
      {
        "id_smk": idSmk,
        "id_dosen_pembimbing": idDospem,
        "id_guru_pamong": idGuruPamong,
      },
    ];

    Exception? lastError;

    for (final payload in strategies) {
      try {
        await _sendAssignRequest(
          pendaftaranId: pendaftaranId,
          requestBody: payload,
        );
        return;
      } catch (e) {
        final message = e.toString().replaceFirst('Exception: ', '');
        lastError = Exception(message);
      }
    }

    throw lastError ?? Exception('Gagal assign penempatan/dospem/guru pamong');
  }

  static Future<void> _sendAssignRequest({
    required int pendaftaranId,
    required Map<String, dynamic> requestBody,
  }) async {
    final token = getToken();
    if (token == null) throw Exception("Token tidak ditemukan.");

    final response = await http.patch(
      Uri.parse("$_baseUrl/pendaftaran-plp/$pendaftaranId"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 403) {
      throw Exception(
        'Akses ditolak. Role Anda tidak memiliki izin untuk assign penempatan. '
        'Silakan gunakan akun Kaprodi atau hubungi administrator.',
      );
    }

    final isSuccessStatus =
        response.statusCode >= 200 && response.statusCode < 300;
    if (isSuccessStatus) {
      return;
    }

    final json = _safeDecodeToMap(response.body);
    final message = _extractErrorMessage(
      json,
      fallback: 'Gagal assign penempatan/dospem/guru pamong',
    );

    throw Exception(message);
  }

  static Map<String, dynamic> _safeDecodeToMap(String body) {
    if (body.trim().isEmpty) return {};

    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return {'data': decoded};
    } catch (_) {
      return {'message': body};
    }
  }

  static String _extractErrorMessage(
    Map<String, dynamic> json, {
    required String fallback,
  }) {
    final errors = json['errors'];
    if (errors is Map) {
      final details = <String>[];

      for (final entry in errors.entries) {
        final value = entry.value;
        if (value is List && value.isNotEmpty) {
          details.add(value.first.toString());
        } else if (value != null) {
          details.add(value.toString());
        }
      }

      if (details.isNotEmpty) {
        return details.join('\n');
      }
    }

    final rawMessage = json['message'] ?? json['error'] ?? json['detail'];
    final message = rawMessage?.toString().trim();

    if (message == null || message.isEmpty) {
      return fallback;
    }

    return message;
  }
}
