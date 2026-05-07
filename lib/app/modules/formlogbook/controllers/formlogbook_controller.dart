import 'package:get/get.dart';
import 'package:plp/app/modules/isilogbook/controllers/isilogbook_controller.dart';
import 'package:plp/service/logbook_service.dart';

class FormlogbookController extends GetxController {
  final tanggal = ''.obs;
  final keterangan = ''.obs;
  final mulai = ''.obs;
  final selesai = ''.obs;
  final dokumentasi = ''.obs;
  final idLogbook = RxnInt();

  final isLoading = false.obs;

  String formatTanggal(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  bool _isMissingLogbookError(Object error) {
    final message = error.toString().toLowerCase();
    return message.contains('no query results for model') ||
        message.contains('404') ||
        message.contains('tidak ditemukan');
  }

  String formatTanggalForField(String rawDate) {
    if (rawDate.contains('-')) {
      final parts = rawDate.split('-');
      if (parts.length == 3) {
        return '${parts[2].padLeft(2, '0')}/${parts[1].padLeft(2, '0')}/${parts[0]}';
      }
    }
    return rawDate;
  }

  Future<void> submitLogbook() async {
    isLoading.value = true;

    try {
      if (idLogbook.value != null) {
        await LogbookService.updateLogbook(
          idLogbook.value!,
          tanggal: tanggal.value,
          keterangan: keterangan.value,
          mulai: mulai.value,
          selesai: selesai.value,
          dokumentasi: dokumentasi.value,
        );
      } else {
        await LogbookService.createLogbookRaw(
          tanggal: tanggal.value,
          keterangan: keterangan.value,
          mulai: mulai.value,
          selesai: selesai.value,
          dokumentasi: dokumentasi.value,
        );
      }

      Get.back(result: true);
    } catch (e) {
      if (_isMissingLogbookError(e)) {
        if (Get.isRegistered<IsilogbookController>()) {
          await Get.find<IsilogbookController>().fetchLogbookData();
        }

        Get.back();
        Get.snackbar(
          'Info',
          'Logbook yang ingin diedit sudah berubah atau tidak ada lagi. Daftar logbook dimuat ulang.',
        );
        return;
      }

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
