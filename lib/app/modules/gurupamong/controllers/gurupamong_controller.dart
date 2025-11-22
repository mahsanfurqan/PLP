import 'package:get/get.dart';
import 'package:plp/service/guru_service.dart';
import 'package:plp/models/user_model.dart';

class GurupamongController extends GetxController {
  var guruList = <UserModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGuruList();
  }

  /// Ambil semua data guru pamong dari server
  Future<void> fetchGuruList() async {
    try {
      isLoading.value = true;
      final result = await GuruPamongService.getAllGuruPamong();
      guruList.assignAll(result.map((e) => UserModel.fromJson(e)).toList());
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data guru pamong:\n${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
