import 'package:get/get.dart';
import 'package:plp/service/logbook_service.dart';
import 'package:plp/models/logbook_model.dart';

class LihatlogbookallController extends GetxController {
  var isLoading = false.obs;
  var logbookList = <LogbookModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllLogbooks();
  }

  /// 📝 Ambil semua logbook mahasiswa
  Future<void> fetchAllLogbooks() async {
    try {
      isLoading.value = true;
      final result = await LogbookService.getAllLogbooks();
      logbookList.assignAll(result);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat logbook: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
