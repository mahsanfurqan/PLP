import 'package:get/get.dart';
import 'package:plp/models/pendaftaranplp_model.dart';
import 'package:plp/service/pendaftaran_plp_service.dart';

class LihatdataplpallController extends GetxController {
  // Data list pendaftaran
  var pendaftaranList = <PendaftaranPlpModel>[].obs;

  // Loading state
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllPendaftaran();
  }

  /// 🔥 Fetch semua pendaftaran dari API
  Future<void> fetchAllPendaftaran() async {
    isLoading.value = true;
    try {
      final data = await PendaftaranPlpService.getAllPendaftaranPlp();
      pendaftaranList.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat data pendaftaran:\n${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }
}
