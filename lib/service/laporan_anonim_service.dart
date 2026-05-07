import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:plp/config/app_config.dart';
import 'package:plp/models/laporan_anonim_model.dart';

class LaporanAnonimService {
  static const String _baseUrl = AppConfig.baseUrl;
  static final box = GetStorage();

  static String? _getToken() {
    return box.read('token');
  }

  static Future<Map<String, dynamic>> submitLaporanAnonim({
    required String studentName,
    required String incidentDescription,
    required String incidentDate,
    Uint8List? evidenceImageBytes,
    String? evidenceImageFileName,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$_baseUrl/laporan-anonim'),
    );
    request.headers['Accept'] = 'application/json';
    request.fields['student_name'] = studentName;
    request.fields['incident_description'] = incidentDescription;
    request.fields['incident_date'] = incidentDate;

    if (evidenceImageBytes != null && evidenceImageBytes.isNotEmpty) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'evidence_image',
          evidenceImageBytes,
          filename:
              evidenceImageFileName == null || evidenceImageFileName.isEmpty
                  ? 'evidence.jpg'
                  : evidenceImageFileName,
        ),
      );
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    final decoded = _tryDecode(response.body);

    if (response.statusCode == 201) {
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return {'message': 'Laporan berhasil dikirim.'};
    }

    throw Exception(_extractErrorMessage(decoded));
  }

  static Future<List<LaporanAnonimModel>>
  getLaporanAnonimForCoordinator() async {
    final token = _getToken();
    if (token == null) throw Exception('Token tidak ditemukan.');

    final response = await http.get(
      Uri.parse('$_baseUrl/laporan-anonim'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    final decoded = _tryDecode(response.body);

    if (response.statusCode == 200) {
      if (decoded is List) {
        return decoded
            .whereType<Map<String, dynamic>>()
            .map(LaporanAnonimModel.fromJson)
            .toList();
      }

      throw Exception('Format data laporan tidak valid.');
    }

    throw Exception(_extractErrorMessage(decoded));
  }

  static Future<void> markLaporanAsRead(int reportId) async {
    final token = _getToken();
    if (token == null) throw Exception('Token tidak ditemukan.');

    final response = await http.patch(
      Uri.parse('$_baseUrl/laporan-anonim/$reportId/read'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    final decoded = _tryDecode(response.body);

    if (response.statusCode == 200) {
      return;
    }

    throw Exception(_extractErrorMessage(decoded));
  }

  static String normalizeEvidenceImageUrl(String imageUrl) {
    final uri = Uri.tryParse(imageUrl);
    if (uri == null) return imageUrl;

    if (Platform.isAndroid &&
        (uri.host == 'localhost' || uri.host == '127.0.0.1')) {
      return uri.replace(host: '10.0.2.2').toString();
    }

    return imageUrl;
  }

  static Future<Uint8List> fetchEvidenceImageBytes(String imageUrl) async {
    final response = await http
        .get(Uri.parse(normalizeEvidenceImageUrl(imageUrl)))
        .timeout(Duration(seconds: AppConfig.requestTimeout));

    if (response.statusCode == 200) {
      return response.bodyBytes;
    }

    throw Exception('Gagal memuat gambar bukti.');
  }

  static dynamic _tryDecode(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return body;
    }
  }

  static String _extractErrorMessage(dynamic decoded) {
    if (decoded is Map<String, dynamic>) {
      final errors = decoded['errors'];
      if (errors is Map<String, dynamic> && errors.isNotEmpty) {
        final firstEntry = errors.entries.first.value;
        if (firstEntry is List && firstEntry.isNotEmpty) {
          return firstEntry.first.toString();
        }
      }
      if (decoded['message'] != null) {
        return decoded['message'].toString();
      }
    }

    if (decoded is String && decoded.isNotEmpty) {
      return decoded;
    }

    return 'Gagal mengirim laporan anonim.';
  }
}
