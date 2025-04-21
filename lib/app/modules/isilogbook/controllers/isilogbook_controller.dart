import 'package:get/get.dart';
import 'package:plp/models/logbook_model.dart';
import 'package:plp/service/logbook_service.dart';
import 'package:intl/intl.dart';

class IsilogbookController extends GetxController {
  var logbookList = <LogbookModel>[].obs;
  var isLoading = false.obs;
  final isStartButtonPressed = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLogbookData();
  }

  /// Navigasi ke halaman tambah logbook
  void goToTambahLogbook() {
    Get.toNamed('/formlogbook');
  }

  /// READ - Ambil data logbook dari backend
  Future<void> fetchLogbookData() async {
    isLoading.value = true;
    try {
      final data = await LogbookService.getLogbooks();
      logbookList.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat data logbook: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// CREATE - Tambah logbook baru
  Future<void> createLogbook(LogbookModel newLogbook) async {
    isLoading.value = true;
    try {
      final createdLogbook = await LogbookService.createLogbook(newLogbook);
      logbookList.add(createdLogbook);
      Get.back(); // Kembali ke halaman sebelumnya
      Get.snackbar("Sukses", "Logbook berhasil ditambahkan");
    } catch (e) {
      Get.snackbar("Error", "Gagal menambahkan logbook: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// UPDATE - Edit logbook
  Future<void> updateLogbook(int id, LogbookModel updatedLogbook) async {
    isLoading.value = true;
    try {
      final updated = await LogbookService.updateLogbook(id, updatedLogbook);
      final index = logbookList.indexWhere((l) => l.id == id);
      if (index != -1) {
        logbookList[index] = updated;
      }
      Get.back();
      Get.snackbar("Sukses", "Logbook berhasil diperbarui");
    } catch (e) {
      Get.snackbar("Error", "Gagal memperbarui logbook: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// DELETE - Hapus logbook
  Future<void> deleteLogbook(int id) async {
    try {
      await LogbookService.deleteLogbook(id);
      logbookList.removeWhere((l) => l.id == id);
      Get.snackbar("Sukses", "Logbook berhasil dihapus");
    } catch (e) {
      Get.snackbar("Error", "Gagal menghapus logbook: $e");
    }
  }

  /// Dapatkan durasi dalam format "X jam Y menit"
  String calculateDuration(String mulai, String selesai) {
    final start = DateFormat("HH:mm:ss").parse(mulai);
    final end = DateFormat("HH:mm:ss").parse(selesai);
    final durasiJam = end.difference(start).inHours;
    final durasiMenit = end.difference(start).inMinutes % 60;
    return durasiMenit == 0
        ? "$durasiJam jam"
        : "$durasiJam jam $durasiMenit menit";
  }
}
