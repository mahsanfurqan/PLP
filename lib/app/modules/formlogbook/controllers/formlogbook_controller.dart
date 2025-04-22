import 'package:get/get.dart';
import 'package:plp/service/logbook_service.dart';

class FormlogbookController extends GetxController {
  final tanggal = ''.obs;
  final keterangan = ''.obs;
  final mulai = ''.obs;
  final selesai = ''.obs;
  final dokumentasi = ''.obs;

  final isLoading = false.obs;

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
      Get.back();
      Get.snackbar('Berhasil', 'Logbook berhasil ditambahkan');
    } catch (e) {
      Get.snackbar('Gagal', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
