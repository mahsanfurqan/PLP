import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plp/app/routes/app_pages.dart';
import 'package:plp/service/pendaftaran_plp_service.dart';

class PendaftaranplpController extends GetxController {
  final keminatanIdController = TextEditingController();
  final nilaiPlp1Controller = TextEditingController();
  final nilaiMicroController = TextEditingController();
  final pilihanSmk1Controller = TextEditingController();
  final pilihanSmk2Controller = TextEditingController();

  final isSubmitting = false.obs;

  // ✅ Tambahan untuk dropdown data
  var keminatanList = <Map<String, dynamic>>[].obs;
  var smkList = <Map<String, dynamic>>[].obs;

  var selectedKeminatanId = RxnInt();
  var selectedSmk1Id = RxnInt();
  var selectedSmk2Id = RxnInt();
  var selectedNilaiPlp1 = ''.obs;
  var selectedNilaiMicro = ''.obs;

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

  void submitPendaftaran() async {
    isSubmitting.value = true;

    try {
      final pendaftaran = await PendaftaranPlpService.submitPendaftaranPlp(
        keminatanId: selectedKeminatanId.value ?? 0,
        nilaiPlp1: selectedNilaiPlp1.value,
        nilaiMicroTeaching: selectedNilaiMicro.value,
        pilihanSmk1: selectedSmk1Id.value ?? 0,
        pilihanSmk2: selectedSmk2Id.value ?? 0,
      );

      Get.snackbar(
        "Sukses",
        "Pendaftaran berhasil dengan ID ${pendaftaran.id}",
      );
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      Get.snackbar("Gagal", e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchDummyDropdowns(); // bisa diganti fetch dari API
  }

  void fetchDummyDropdowns() {
    keminatanList.value = [
      {'id': 1, 'nama': 'Keminatan A'},
      {'id': 2, 'nama': 'Keminatan B'},
    ];
    smkList.value = [
      {'id': 101, 'nama': 'SMK Negeri 1'},
      {'id': 102, 'nama': 'SMK Negeri 2'},
    ];
  }

  @override
  void onClose() {
    keminatanIdController.dispose();
    nilaiPlp1Controller.dispose();
    nilaiMicroController.dispose();
    pilihanSmk1Controller.dispose();
    pilihanSmk2Controller.dispose();
    super.onClose();
  }
}
