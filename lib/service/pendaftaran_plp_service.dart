import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:plp/models/pendaftaranplp_model.dart';

class PendaftaranPlpService {
  static const String _baseUrl = "http://127.0.0.1:8000/api";

  static Future<PendaftaranPlpModel> submitPendaftaranPlp({
    required int keminatanId,
    required String nilaiPlp1,
    required String nilaiMicroTeaching,
    required int pilihanSmk1,
    required int pilihanSmk2,
  }) async {
    final box = GetStorage();
    final token = box.read("token");

    if (token == null) throw Exception("Token tidak ditemukan.");

    final response = await http.post(
      Uri.parse("$_baseUrl/pendaftaran-plp"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "keminatan_id": keminatanId,
        "nilai_plp_1": nilaiPlp1,
        "nilai_micro_teaching": nilaiMicroTeaching,
        "pilihan_smk_1": pilihanSmk1,
        "pilihan_smk_2": pilihanSmk2,
      }),
    );

    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return PendaftaranPlpModel.fromJson(json['pendaftaran_plp']);
    } else {
      throw Exception(
        json['message'] ?? 'Terjadi kesalahan saat mendaftar PLP',
      );
    }
  }
}
