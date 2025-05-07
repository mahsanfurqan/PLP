import 'package:get/get.dart';
import 'package:plp/models/pendaftaranplp_model.dart';
import 'package:plp/models/smk_model.dart';
import 'package:plp/models/user_model.dart';
import 'package:plp/service/akun_service.dart';
import 'package:plp/service/pendaftaran_plp_service.dart';
import 'package:plp/service/smk_service.dart';

class LihatdataplpallController extends GetxController {
  // 📌 State untuk data pendaftaran PLP
  var pendaftaranList = <PendaftaranPlpModel>[].obs;

  // 📌 State untuk data SMK dan Dosen Pembimbing
  var smkList = <SmkModel>[].obs;
  var dospems = <UserModel>[].obs;

  // 📌 Loading states
  var isLoading = false.obs;
  var isAssigning = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllPendaftaran();
    fetchDropdownData();
  }

  /// 🔥 Fetch semua data pendaftaran PLP
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

  /// 🔄 Ambil data SMK & Dospem untuk dropdown
  Future<void> fetchDropdownData() async {
    try {
      final smks = await SmkService.getSmks();
      final dospems = await AkunService.getAllUsersByRole(
        'Dosen Pembimbing',
      ); // ambil dari AkunService
      smkList.assignAll(smks);
      dospems.assignAll(
        await AkunService.getAllUsersByRole("Dosen Pembimbing"),
      );
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat data dropdown:\n${e.toString()}");
    }
  }

  /// ✅ Assign SMK dan Dospem untuk pendaftar tertentu
  Future<void> assignPenempatanDanDospem({
    required int pendaftaranId,
    required int idSmk,
    required int idDospem,
    int? idGuruPamong, // optional
  }) async {
    isAssigning.value = true; // Show loading indicator
    try {
      // Call the service to assign the SMK and Dospem
      await PendaftaranPlpService.assignPenempatanDospem(
        pendaftaranId: pendaftaranId,
        idSmk: idSmk,
        idDospem: idDospem,
        idGuruPamong: idGuruPamong, // Can be null, handled in the service
      );

      // Show success message
      Get.snackbar("Sukses", "Berhasil meng-assign penempatan & dospem.");

      // Refresh the list of pendaftar
      fetchAllPendaftaran();
    } catch (e) {
      // Handle any errors by displaying the error message
      Get.snackbar(
        "Error",
        "Gagal meng-assign penempatan & dospem:\n${e.toString()}",
      );
    } finally {
      // Hide loading indicator
      isAssigning.value = false;
    }
  }
}
