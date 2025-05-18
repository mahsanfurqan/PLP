import 'package:get/get.dart';
import 'package:plp/models/pendaftaranplp_model.dart';
import 'package:plp/models/smk_model.dart';
import 'package:plp/models/user_model.dart';
import 'package:plp/service/akun_service.dart';
import 'package:plp/service/pendaftaran_plp_service.dart';
import 'package:plp/service/smk_service.dart';
import 'package:plp/service/guru_service.dart'; // tambahkan ini kalau service guru kamu pisah

class LihatdataplpallController extends GetxController {
  // 📌 State untuk data pendaftaran PLP
  var pendaftaranList = <PendaftaranPlpModel>[].obs;

  // 📌 State untuk data SMK, Dospem, dan Guru Pamong
  var smkList = <SmkModel>[].obs;
  var dospems = <UserModel>[].obs;
  var guruPamongs = <UserModel>[].obs;

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

  /// 🔄 Ambil data SMK, Dospem & Guru Pamong untuk dropdown
  Future<void> fetchDropdownData() async {
    try {
      smkList.assignAll(await SmkService.getSmks());
      dospems.assignAll(
        await AkunService.getAllUsersByRole("Dosen Pembimbing"),
      );
      await fetchGuruPamong(); // panggil juga data guru pamong
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat data dropdown:\n${e.toString()}");
    }
  }

  /// 👨‍🏫 Fetch data Guru Pamong
  Future<void> fetchGuruPamong() async {
    try {
      final result = await GuruPamongService.getAllGuruPamong();
      guruPamongs.assignAll(result.map((e) => UserModel.fromJson(e)).toList());
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat data guru pamong:\n${e.toString()}");
    }
  }

  /// ✅ Assign SMK, Dospem, dan Guru Pamong untuk pendaftar tertentu
  Future<void> assignPenempatanDanDospem({
    required int pendaftaranId,
    required int idSmk,
    required int idDospem,
    required int idGuruPamong,
  }) async {
    isAssigning.value = true;
    try {
      await PendaftaranPlpService.assignPenempatanDospem(
        pendaftaranId: pendaftaranId,
        idSmk: idSmk,
        idDospem: idDospem,
        idGuruPamong: idGuruPamong,
      );

      Get.snackbar(
        "Sukses",
        "Berhasil meng-assign penempatan, dospem, dan guru.",
      );
      fetchAllPendaftaran(); // refresh data setelah assign
    } catch (e) {
      Get.snackbar("Error", "Gagal meng-assign:\n${e.toString()}");
    } finally {
      isAssigning.value = false;
    }
  }
}
