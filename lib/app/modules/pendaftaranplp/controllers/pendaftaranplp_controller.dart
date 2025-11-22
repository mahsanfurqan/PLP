import 'package:get/get.dart';
import 'package:plp/app/routes/app_pages.dart';
import 'package:plp/service/pendaftaran_plp_service.dart';
import 'package:plp/service/keminatan_service.dart';
import 'package:plp/service/smk_service.dart';
import 'package:plp/models/smk_model.dart'; // Tambahkan import SmkModel

class PendaftaranplpController extends GetxController {
  final isSubmitting = false.obs;

  // Data Dropdown
  var keminatanList = <Map<String, dynamic>>[].obs;
  var smkList = <SmkModel>[].obs; // ✅ GANTI jadi list of SmkModel

  // Selected values
  var selectedKeminatanId = RxnInt();
  var selectedSmk1Id = RxnInt();
  var selectedSmk2Id = RxnInt();
  var selectedNilaiPlp1 = ''.obs;
  var selectedNilaiMicro = ''.obs;

  // Cek apakah sudah daftar sebelumnya
  var sudahDaftar = false.obs;

  final List<String> nilaiOptions = [
    'A',
    'B+',
    'B',
    'C+',
    'C',
    'D',
    'E',
    'Belum',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchDropdownData();
    cekStatusPendaftaran();
  }

  // Mengambil data dropdown keminatan dan SMK
  Future<void> fetchDropdownData() async {
    try {
      final keminatans = await KeminatanService.getKeminatan();
      keminatanList.assignAll(keminatans);

      final smks = await SmkService.getSmks();
      smkList.assignAll(smks);
    } catch (e) {
      Get.log("🔴 Error saat fetchDropdownData: $e", isError: true);
      Get.snackbar("Error", "Gagal memuat data dropdown:\n${e.toString()}");
    }
  }

  Future<void> cekStatusPendaftaran() async {
    try {
      final status = await PendaftaranPlpService.cekSudahDaftar();
      if (status) {
        sudahDaftar.value = true;
        Get.snackbar("Info", "Anda sudah terdaftar untuk PLP.");
      } else {
        sudahDaftar.value = false;
      }
    } catch (e) {
      final errorMsg = e.toString();
      if (errorMsg.contains("berhasil dibuat")) {
        Get.snackbar("Sukses", "Pendaftaran berhasil.");
        Get.offAllNamed(Routes.HOME);
      } else {
        print("Error during cekStatusPendaftaran: $e");
        Get.snackbar("Gagal", "Gagal mengecek pendaftaran:\n$errorMsg");
      }
    }
  }

  // Mengirim data pendaftaran
  void submitPendaftaran() async {
    isSubmitting.value = true;

    if (selectedKeminatanId.value == null) {
      Get.snackbar("Error", "Keminatan belum dipilih.");
      isSubmitting.value = false;
      return;
    }

    if (selectedNilaiPlp1.value.isEmpty || selectedNilaiMicro.value.isEmpty) {
      Get.snackbar("Error", "Nilai PLP 1 dan Micro Teaching harus diisi.");
      isSubmitting.value = false;
      return;
    }

    if (selectedSmk1Id.value == null || selectedSmk2Id.value == null) {
      Get.snackbar("Error", "Silakan pilih dua SMK.");
      isSubmitting.value = false;
      return;
    }

    if (sudahDaftar.value) {
      isSubmitting.value = false;
      Get.snackbar("Info", "Anda sudah terdaftar untuk PLP.");
      return;
    }

    try {
      final pendaftaran = await PendaftaranPlpService.submitPendaftaranPlp(
        keminatanId: selectedKeminatanId.value!,
        nilaiPlp1: selectedNilaiPlp1.value,
        nilaiMicroTeaching: selectedNilaiMicro.value,
        pilihanSmk1: selectedSmk1Id.value!,
        pilihanSmk2: selectedSmk2Id.value!,
      );

      if (pendaftaran != null) {
        Get.snackbar(
          "Sukses",
          "Pendaftaran berhasil dengan ID ${pendaftaran.id}",
        );
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.snackbar("Gagal", "Pendaftaran gagal. Silakan coba lagi.");
      }
    } catch (e) {
      print("Error during submitPendaftaran: $e");
      Get.snackbar("Gagal", "Pendaftaran gagal:\n${e.toString()}");
    } finally {
      isSubmitting.value = false;
    }
  }
}
