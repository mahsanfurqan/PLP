import 'package:get/get.dart';
import 'package:plp/service/smk_service.dart';
import 'package:plp/models/smk_model.dart';

class SmkController extends GetxController {
  final isLoading = false.obs;
  final isSubmitting = false.obs;

  var smkList = <SmkModel>[].obs;

  final namaSmkBaru = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSmkList();
  }

  // 🔵 Ambil semua data SMK
  Future<void> fetchSmkList() async {
    try {
      isLoading.value = true;
      final data = await SmkService.getSmks();
      smkList.assignAll(data);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat daftar SMK:\n${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // 🟢 Tambahkan SMK baru
  Future<void> tambahSmk() async {
    if (namaSmkBaru.value.isEmpty) {
      Get.snackbar('Error', 'Nama SMK tidak boleh kosong.');
      return;
    }

    try {
      isSubmitting.value = true;
      await SmkService.addSmk(namaSmkBaru.value);

      Get.snackbar('Sukses', 'SMK berhasil ditambahkan.');
      namaSmkBaru.value = '';

      fetchSmkList(); // Refresh daftar SMK setelah tambah
    } catch (e) {
      Get.snackbar('Gagal', 'Gagal menambahkan SMK:\n${e.toString()}');
    } finally {
      isSubmitting.value = false;
    }
  }
}
