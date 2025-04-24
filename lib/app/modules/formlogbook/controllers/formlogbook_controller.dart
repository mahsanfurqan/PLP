import 'package:get/get.dart';
import 'package:plp/service/logbook_service.dart';

class FormlogbookController extends GetxController {
  final tanggal = ''.obs;
  final keterangan = ''.obs;
  final mulai = ''.obs;
  final selesai = ''.obs;
  final dokumentasi = ''.obs;

  final isLoading = false.obs;

  String formatTanggal(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> submitLogbook() async {
    isLoading.value = true;

    try {
      await LogbookService.createLogbookRaw(
        tanggal: tanggal.value,
        keterangan: keterangan.value,
        mulai: mulai.value,
        selesai: selesai.value,
        dokumentasi: dokumentasi.value,
      );

      Get.back(result: true); // ⬅️ Kirim sinyal ke halaman sebelumnya
      Get.snackbar('Berhasil', 'Logbook berhasil ditambahkan');
    } catch (e) {
      Get.snackbar('Gagal', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  String convertTanggalToIso(String input) {
    try {
      final date = DateTime.parse(
        '${input.substring(6)}-${input.substring(3, 5)}-${input.substring(0, 2)}',
      );
      return date.toIso8601String().split('T').first;
    } catch (_) {
      return input;
    }
  }

  String formatJam(String input) {
    try {
      final parts = input.split(':');
      if (parts.length == 2) {
        final jam = parts[0].padLeft(2, '0');
        final menit = parts[1].padLeft(2, '0');
        return '$jam:$menit:00'; // format yang backend butuh
      }
    } catch (_) {}
    return input; // fallback
  }
}
