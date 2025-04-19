import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:plp/app/navbar/navbar_popup_helper.dart';
import 'dart:developer';

class NavbarController extends GetxController {
  final selectedIndex = 0.obs;
  final role = 'Observer'.obs;

  @override
  void onInit() {
    super.onInit();
    final userData = GetStorage().read('user');
    log('📦 Data user di local storage: $userData');
    role.value = userData?['role'] ?? 'Observer';
    log('📌 Role user terdeteksi: ${role.value}');
  }

  void onTabTapped(int index) {
    selectedIndex.value = index;

    switch (index) {
      case 1:
        _handleLogbook();
        break;
      case 2:
        _handlePendaftaran();
        break;
      default:
        break;
    }
  }

  void _handleLogbook() {
    if (role.value == 'Mahasiswa' || role.value == 'Observer') {
      Get.bottomSheet(LogbookBottomSheet(role.value), isScrollControlled: true);
    } else {
      Get.bottomSheet(
        const AdminLogbookValidationSheet(),
        isScrollControlled: true,
      );
    }
  }

  void _handlePendaftaran() {
    if (role.value == 'Mahasiswa') {
      Get.bottomSheet(
        const MahasiswaPendaftaranSheet(),
        isScrollControlled: true,
      );
    } else if (role.value == 'Observer') {
      Get.snackbar(
        "Akses Terbatas",
        "Anda masuk sebagai observer. Silakan buat akun terlebih dahulu.",
        snackPosition: SnackPosition.TOP,
      );
    } else {
      Get.bottomSheet(
        const AdminLihatKelengkapanSheet(),
        isScrollControlled: true,
      );
    }
  }
}
