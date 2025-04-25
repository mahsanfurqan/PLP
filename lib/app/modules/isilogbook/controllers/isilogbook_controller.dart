import 'package:get/get.dart';
import 'package:plp/app/modules/formlogbook/controllers/formlogbook_controller.dart';
import 'package:plp/app/modules/formlogbook/views/formlogbook_view.dart';
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

  /// Navigasi ke form tambah logbook
  void goToTambahLogbook() async {
    Get.lazyPut(() => FormlogbookController());
    final result = await Get.to(() => const FormlogbookView());
    if (result == true) {
      fetchLogbookData();
    }
  }

  /// Navigasi ke form edit logbook
  void goToEditLogbook(LogbookModel logbook) async {
    // Bind controller dan ambil instance-nya
    final controller = Get.put(FormlogbookController());

    // Set nilai-nilai dari logbook ke controller
    controller.tanggal.value = logbook.tanggal;
    controller.keterangan.value = logbook.keterangan;
    controller.mulai.value = logbook.mulai;
    controller.selesai.value = logbook.selesai;
    controller.dokumentasi.value = logbook.dokumentasi;
    controller.idLogbook.value =
        logbook.id; // INI sekarang aman karena idLogbook ada

    final result = await Get.to(() => const FormlogbookView());

    if (result == true) {
      fetchLogbookData();
    }
  }

  /// Ambil data logbook dari backend
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

  /// Hapus logbook
  Future<void> deleteLogbook(int id) async {
    try {
      print("Menghapus logbook dengan ID: $id");
      await LogbookService.deleteLogbook(id);
      logbookList.removeWhere((l) => l.id == id);
      Get.snackbar("Sukses", "Logbook berhasil dihapus");
    } catch (e) {
      print("Error saat menghapus logbook: $e");
      Get.snackbar("Error", "Gagal menghapus logbook: $e");
    }
  }

  /// Hitung durasi kegiatan
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
