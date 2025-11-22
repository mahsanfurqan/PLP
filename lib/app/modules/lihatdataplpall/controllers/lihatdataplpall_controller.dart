import 'package:get/get.dart';
import 'package:plp/models/pendaftaranplp_model.dart';
import 'package:plp/models/smk_model.dart';
import 'package:plp/models/user_model.dart';
import 'package:plp/service/akun_service.dart';
import 'package:plp/service/pendaftaran_plp_service.dart';
import 'package:plp/service/smk_service.dart';
import 'package:plp/service/guru_service.dart'; // tambahkan ini kalau service guru kamu pisah
import 'package:flutter/material.dart'; // Added for Colors

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
      print('🔄 Fetching dropdown data...');

      // Fetch SMK data
      final smkData = await SmkService.getSmks();
      smkList.assignAll(smkData);
      print('📚 SMK data loaded: ${smkList.length} items');

      // Fetch Dosen Pembimbing data
      final dospemData = await AkunService.getAllUsersByRole(
        "Dosen Pembimbing",
      );
      dospems.assignAll(dospemData);
      print('👨‍🏫 Dosen Pembimbing data loaded: ${dospems.length} items');

      // Fetch Guru Pamong data
      await fetchGuruPamong();

      print('✅ All dropdown data loaded successfully');
    } catch (e) {
      print('❌ Error fetching dropdown data: $e');
      Get.snackbar("Error", "Gagal memuat data dropdown:\n${e.toString()}");
    }
  }

  /// 👨‍🏫 Fetch data Guru Pamong
  Future<void> fetchGuruPamong() async {
    try {
      final result = await GuruPamongService.getAllGuruPamong();
      guruPamongs.assignAll(result.map((e) => UserModel.fromJson(e)).toList());
      print('👨‍🏫 Guru Pamong data loaded: ${guruPamongs.length} items');
    } catch (e) {
      print('❌ Error fetching guru pamong: $e');
      Get.snackbar("Error", "Gagal memuat data guru pamong:\n${e.toString()}");
    }
  }

  /// 🏫 Helper method untuk mendapatkan nama SMK berdasarkan ID
  String getNamaSmk(int? smkId) {
    if (smkId == null) return '-';
    try {
      final smk = smkList.firstWhere((smk) => smk.id == smkId);
      return smk.nama;
    } catch (e) {
      return 'SMK ID: $smkId';
    }
  }

  /// 👨‍🏫 Helper method untuk mendapatkan nama Dosen Pembimbing berdasarkan ID
  String getNamaDospem(int? dospemId) {
    if (dospemId == null) return '-';
    try {
      final dospem = dospems.firstWhere((user) => user.id == dospemId);
      return dospem.name;
    } catch (e) {
      return 'Dospem ID: $dospemId';
    }
  }

  /// 👨‍🏫 Helper method untuk mendapatkan nama Guru Pamong berdasarkan ID
  String getNamaGuruPamong(int? guruPamongId) {
    if (guruPamongId == null) return '-';
    try {
      final guruPamong = guruPamongs.firstWhere(
        (user) => user.id == guruPamongId,
      );
      return guruPamong.name;
    } catch (e) {
      return 'Guru Pamong ID: $guruPamongId';
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
      print('🔄 Starting assignment for pendaftaran ID: $pendaftaranId');
      print('🔄 Assigning SMK: $idSmk, Dospem: $idDospem, Guru: $idGuruPamong');

      await PendaftaranPlpService.assignPenempatanDospem(
        pendaftaranId: pendaftaranId,
        idSmk: idSmk,
        idDospem: idDospem,
        idGuruPamong: idGuruPamong,
      );

      print('✅ Assignment successful, refreshing data...');

      // Temporary fix: Update the local data manually since API doesn't return the fields
      final registrationIndex = pendaftaranList.indexWhere(
        (item) => item.id == pendaftaranId,
      );
      if (registrationIndex != -1) {
        final currentRegistration = pendaftaranList[registrationIndex];

        // Create updated registration with assignment data
        final updatedRegistration = PendaftaranPlpModel(
          id: currentRegistration.id,
          userId: currentRegistration.userId,
          keminatanId: currentRegistration.keminatanId,
          nilaiPlp1: currentRegistration.nilaiPlp1,
          nilaiMicroTeaching: currentRegistration.nilaiMicroTeaching,
          pilihanSmk1: currentRegistration.pilihanSmk1,
          pilihanSmk2: currentRegistration.pilihanSmk2,
          penempatan: idSmk, // Use the assigned SMK
          dosenPembimbing: idDospem, // Use the assigned Dospem
          guruPamong: idGuruPamong, // Use the assigned Guru
          createdAt: currentRegistration.createdAt,
          updatedAt: currentRegistration.updatedAt,
        );

        // Update the list
        pendaftaranList[registrationIndex] = updatedRegistration;

        print('✅ Manually updated local data with assignment');
        print('🔍 Updated registration details:');
        print('   - ID: ${updatedRegistration.id}');
        print('   - SMK: ${updatedRegistration.penempatan}');
        print('   - Dospem: ${updatedRegistration.dosenPembimbing}');
        print('   - Guru: ${updatedRegistration.guruPamong}');

        // Show success message with details
        Get.snackbar(
          "Sukses",
          "Berhasil meng-assign:\n• SMK: ${getNamaSmk(idSmk)}\n• Dosen: ${getNamaDospem(idDospem)}\n• Guru: ${getNamaGuruPamong(idGuruPamong)}",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }

      print('✅ Data refreshed after assignment');
      print('📊 Current pendaftaran list length: ${pendaftaranList.length}');
    } catch (e) {
      print('❌ Assignment error: $e');

      // Check if the error message actually indicates success
      final errorMessage = e.toString().toLowerCase();
      if (errorMessage.contains('berhasil') ||
          errorMessage.contains('success')) {
        print('✅ Detected success message in error, treating as success');

        Get.snackbar(
          "Sukses",
          "Berhasil meng-assign penempatan, dospem, dan guru.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        // Refresh data setelah assign
        await fetchAllPendaftaran();

        // Apply the same temporary fix for error case
        final registrationIndex = pendaftaranList.indexWhere(
          (item) => item.id == pendaftaranId,
        );
        if (registrationIndex != -1) {
          final currentRegistration = pendaftaranList[registrationIndex];

          final updatedRegistration = PendaftaranPlpModel(
            id: currentRegistration.id,
            userId: currentRegistration.userId,
            keminatanId: currentRegistration.keminatanId,
            nilaiPlp1: currentRegistration.nilaiPlp1,
            nilaiMicroTeaching: currentRegistration.nilaiMicroTeaching,
            pilihanSmk1: currentRegistration.pilihanSmk1,
            pilihanSmk2: currentRegistration.pilihanSmk2,
            penempatan: idSmk,
            dosenPembimbing: idDospem,
            guruPamong: idGuruPamong,
            createdAt: currentRegistration.createdAt,
            updatedAt: currentRegistration.updatedAt,
          );

          pendaftaranList[registrationIndex] = updatedRegistration;

          print('✅ Manually updated local data with assignment (from error)');

          // Show success message with details
          Get.snackbar(
            "Sukses",
            "Berhasil meng-assign:\n• SMK: ${getNamaSmk(idSmk)}\n• Dosen: ${getNamaDospem(idDospem)}\n• Guru: ${getNamaGuruPamong(idGuruPamong)}",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 4),
          );
        }

        print('✅ Data refreshed after assignment (success from error)');
      } else {
        Get.snackbar(
          "Error",
          "Gagal meng-assign:\n${e.toString()}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      isAssigning.value = false;
    }
  }
}
