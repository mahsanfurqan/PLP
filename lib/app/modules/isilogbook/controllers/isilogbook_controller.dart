import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:plp/app/modules/formlogbook/controllers/formlogbook_controller.dart';
import 'package:plp/app/modules/formlogbook/views/formlogbook_view.dart';
import 'package:plp/models/logbook_model.dart';
import 'package:plp/service/logbook_service.dart';
import 'package:intl/intl.dart';

class IsilogbookController extends GetxController {
  var logbookList = <LogbookModel>[].obs;
  var isLoading = false.obs;
  final isIntegrityPactLoading = false.obs;
  final isSubmittingIntegrityPact = false.obs;
  final hasAcceptedIntegrityPact = false.obs;
  final integrityPactChecked = false.obs;
  final isStartButtonPressed = false.obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    initializePage();
  }

  Future<void> initializePage() async {
    isIntegrityPactLoading.value = true;

    try {
      final result = await LogbookService.getIntegrityPactStatus();
      final accepted = result['accepted'] == true;

      hasAcceptedIntegrityPact.value = accepted;
      integrityPactChecked.value = accepted;

      final userData = Map<String, dynamic>.from(box.read('user') ?? {});
      userData['integrity_pact_accepted'] = accepted;
      userData['integrity_pact_accepted_at'] = result['accepted_at'];
      box.write('user', userData);

      if (accepted) {
        await fetchLogbookData();
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat status pakta integritas: $e");
    } finally {
      isIntegrityPactLoading.value = false;
    }
  }

  Future<void> acceptIntegrityPact() async {
    if (!integrityPactChecked.value || isSubmittingIntegrityPact.value) {
      return;
    }

    try {
      isSubmittingIntegrityPact.value = true;
      await LogbookService.acceptIntegrityPact();
      hasAcceptedIntegrityPact.value = true;

      final userData = Map<String, dynamic>.from(box.read('user') ?? {});
      userData['integrity_pact_accepted'] = true;
      userData['integrity_pact_accepted_at'] = DateTime.now().toIso8601String();
      box.write('user', userData);

      await fetchLogbookData();
      Get.snackbar(
        "Berhasil",
        "Pakta integritas disetujui. Anda sekarang dapat mengakses logbook.",
      );
    } catch (e) {
      Get.snackbar("Gagal", e.toString());
    } finally {
      isSubmittingIntegrityPact.value = false;
    }
  }

  /// Navigasi ke form tambah logbook
  void goToTambahLogbook() async {
    final controller = Get.put(FormlogbookController());
    controller.tanggal.value = '';
    controller.keterangan.value = '';
    controller.mulai.value = '';
    controller.selesai.value = '';
    controller.dokumentasi.value = '';
    controller.idLogbook.value = null;

    final result = await Get.to(() => const FormlogbookView());
    if (result == true) {
      fetchLogbookData();
    }
  }

  /// Navigasi ke form edit logbook
  void goToEditLogbook(LogbookModel logbook) async {
    final controller = Get.put(FormlogbookController());

    controller.tanggal.value = logbook.tanggal;
    controller.keterangan.value = logbook.keterangan;
    controller.mulai.value = logbook.mulai;
    controller.selesai.value = logbook.selesai;
    controller.dokumentasi.value = logbook.dokumentasi;
    controller.idLogbook.value = logbook.id;

    final result = await Get.to(() => const FormlogbookView());

    if (result == true) {
      fetchLogbookData();
    }
  }

  bool _isMissingLogbookError(Object error) {
    final message = error.toString().toLowerCase();
    return message.contains('no query results for model') ||
        message.contains('404') ||
        message.contains('tidak ditemukan');
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
      await LogbookService.deleteLogbook(id);
      logbookList.removeWhere((l) => l.id == id);
      Get.snackbar("Sukses", "Logbook berhasil dihapus");
    } catch (e) {
      if (_isMissingLogbookError(e)) {
        await fetchLogbookData();
        Get.snackbar(
          "Info",
          "Data logbook sudah berubah di server. Daftar dimuat ulang.",
        );
        return;
      }

      Get.snackbar("Error", "Gagal menghapus logbook: $e");
    }
  }

  /// Hitung durasi kegiatan
  String calculateDuration(String mulai, String selesai) {
    try {
      // Support both HH:mm and HH:mm:ss formats
      final format = mulai.split(':').length == 3 ? "HH:mm:ss" : "HH:mm";
      final start = DateFormat(format).parse(mulai);
      final end = DateFormat(format).parse(selesai);
      final durasiJam = end.difference(start).inHours;
      final durasiMenit = end.difference(start).inMinutes % 60;
      return durasiMenit == 0
          ? "$durasiJam jam"
          : "$durasiJam jam $durasiMenit menit";
    } catch (e) {
      return "0 jam";
    }
  }
}
