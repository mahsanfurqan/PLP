import 'package:get/get.dart';
import 'package:plp/service/keminatan_service.dart';

class KeminatanController extends GetxController {
  var keminatanList = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var isSubmitting = false.obs;
  var namaKeminatanBaru = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchKeminatan();
  }

  /// Ambil semua data keminatan dari server
  Future<void> fetchKeminatan() async {
    try {
      isLoading.value = true;
      final keminatans = await KeminatanService.getKeminatan();
      keminatanList.assignAll(keminatans);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data keminatan:\n${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Menambahkan keminatan baru ke server
  Future<void> tambahKeminatan() async {
    if (namaKeminatanBaru.value.isEmpty) {
      Get.snackbar('Gagal', 'Nama keminatan tidak boleh kosong.');
      return;
    }

    try {
      isSubmitting.value = true;
      await KeminatanService.addKeminatan(namaKeminatanBaru.value);

      Get.snackbar('Sukses', 'Keminatan berhasil ditambahkan.');
      fetchKeminatan(); // Refresh list setelah tambah
      namaKeminatanBaru.value = ''; // Reset input
    } catch (e) {
      Get.snackbar('Gagal', 'Gagal menambahkan keminatan:\n${e.toString()}');
    } finally {
      isSubmitting.value = false;
    }
  }
}
