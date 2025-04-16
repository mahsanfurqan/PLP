import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class IsilogbookController extends GetxController {
  var logbookList = <Map<String, dynamic>>[].obs;
  var isStartButtonPressed = false.obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchLogbookData();
  }

  void goToTambahLogbook() {
    Get.toNamed('/tambah-logbook');
  }

  Future<void> fetchLogbookData() async {
    final token = box.read('token');
    final url = Uri.parse('http://127.0.0.1:8000/api/logbooks');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        logbookList.value =
            data.map((item) {
              final mulai = DateFormat("HH:mm:ss").parse(item['mulai']);
              final selesai = DateFormat("HH:mm:ss").parse(item['selesai']);
              final durasiJam = selesai.difference(mulai).inHours;
              final durasiMenit = selesai.difference(mulai).inMinutes % 60;
              final durasi =
                  durasiMenit == 0
                      ? "$durasiJam jam"
                      : "$durasiJam jam $durasiMenit menit";

              return {
                'id': item['id'].toString(),
                'durasi': durasi,
                'uraian': item['keterangan'] ?? '',
                'tanggal': item['tanggal'],
                'mulai': item['mulai'],
                'selesai': item['selesai'],
                'dokumentasi': item['dokumentasi'],
              };
            }).toList();
      } else {
        Get.snackbar("Error", "Gagal memuat data logbook");
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: $e");
    }
  }
}
