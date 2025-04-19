import 'package:get/get.dart';
import 'package:plp/app/routes/app_pages.dart';
import 'package:plp/service/pendaftaran_plp_service.dart';
import 'package:plp/service/keminatan_service.dart';
import 'package:plp/service/smk_service.dart';

class PendaftaranplpController extends GetxController {
  final isSubmitting = false.obs;

  // Data Dropdown
  var keminatanList = <Map<String, dynamic>>[].obs;
  var smkList = <Map<String, dynamic>>[].obs;

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
    cekStatusPendaftaran(); // Pastikan ini hanya dipanggil sekali saat inisialisasi
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

  // Mengecek status pendaftaran apakah sudah pernah mendaftar
  Future<void> cekStatusPendaftaran() async {
    try {
      final status = await PendaftaranPlpService.cekSudahDaftar();
      if (status) {
        sudahDaftar.value = true;
        // Menampilkan notifikasi hanya sekali saat sudah terdaftar
        Get.snackbar("Info", "Anda sudah terdaftar untuk PLP.");
      } else {
        sudahDaftar.value = false;
      }
    } catch (e) {
      Get.log("🔴 Gagal cek status pendaftaran: $e", isError: true);
      Get.snackbar("Error", "Gagal cek status pendaftaran.");
    }
  }

  // Mengirim data pendaftaran
  void submitPendaftaran() async {
    isSubmitting.value = true;

    // Validasi input sebelum kirim
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

    // Mengecek apakah sudah pernah mendaftar
    if (sudahDaftar.value) {
      // Jika sudah terdaftar, tidak perlu kirim pendaftaran lagi
      isSubmitting.value = false;
      Get.snackbar("Info", "Anda sudah terdaftar untuk PLP.");
      return;
    }

    try {
      // Melakukan pengiriman pendaftaran PLP
      final pendaftaran = await PendaftaranPlpService.submitPendaftaranPlp(
        keminatanId: selectedKeminatanId.value!,
        nilaiPlp1: selectedNilaiPlp1.value,
        nilaiMicroTeaching: selectedNilaiMicro.value,
        pilihanSmk1: selectedSmk1Id.value!,
        pilihanSmk2: selectedSmk2Id.value!,
      );

      // Mengecek jika respons berhasil dan data tersedia
      if (pendaftaran != null) {
        // Menampilkan notifikasi sukses jika pendaftaran berhasil
        Get.snackbar(
          "Sukses",
          "Pendaftaran berhasil dengan ID ${pendaftaran.id}",
        );
        Get.offAllNamed(Routes.HOME);
      } else {
        // Menangani kegagalan jika respons kosong atau tidak valid
        Get.snackbar("Gagal", "Pendaftaran gagal. Silakan coba lagi.");
      }
    } catch (e) {
      // Menangani error dengan lebih detail
      print("Error during submitPendaftaran: $e"); // Log error untuk debug
      Get.snackbar("Gagal", "Pendaftaran gagal:\n${e.toString()}");
    } finally {
      isSubmitting.value = false;
    }
  }
}
