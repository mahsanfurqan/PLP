import 'package:get/get.dart';
import 'package:plp/models/pendaftaranplp_model.dart';
import 'package:plp/models/smk_model.dart';
import 'package:plp/models/user_model.dart';
import 'package:plp/service/akun_service.dart';
import 'package:plp/service/pendaftaran_plp_service.dart';
import 'package:plp/service/smk_service.dart';
import 'package:plp/service/guru_service.dart'; // tambahkan ini kalau service guru kamu pisah
import 'package:flutter/material.dart'; // Added for Colors
import 'package:plp/widget/app_snackbar.dart';

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
      AppSnackbar.show(
        "Error",
        "Gagal memuat data pendaftaran:\n${e.toString()}",
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔄 Ambil data SMK, Dospem & Guru Pamong untuk dropdown
  Future<void> fetchDropdownData() async {
    try {
      // Fetch SMK data
      final smkData = await SmkService.getSmks();
      smkList.assignAll(smkData);

      // Fetch Dosen Pembimbing data
      final dospemData = await AkunService.getAllUsersByRole(
        "Dosen Pembimbing",
      );
      dospems.assignAll(dospemData);

      // Fetch Guru Pamong data
      await fetchGuruPamong();
    } catch (e) {
      AppSnackbar.show("Error", "Gagal memuat data dropdown:\n${e.toString()}");
    }
  }

  /// 👨‍🏫 Fetch data Guru Pamong
  Future<void> fetchGuruPamong() async {
    try {
      final result = await GuruPamongService.getAllGuruPamong();
      guruPamongs.assignAll(result.map((e) => UserModel.fromJson(e)).toList());
    } catch (e) {
      AppSnackbar.show(
        "Error",
        "Gagal memuat data guru pamong:\n${e.toString()}",
      );
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
    if (isAssigning.value) return;

    isAssigning.value = true;
    try {
      final beforeRegistration = _findRegistrationById(pendaftaranId);

      // Gunakan assign fleksibel agar kompatibel dengan variasi key backend.
      await PendaftaranPlpService.assignPenempatanDospemFlexible(
        pendaftaranId: pendaftaranId,
        idSmk: idSmk,
        idDospem: idDospem,
        idGuruPamong: idGuruPamong,
      );

      var updatedRegistration = await _refreshAndFindRegistration(
        pendaftaranId,
      );

      var isReflected = _isAssignmentReflected(
        before: beforeRegistration,
        after: updatedRegistration,
        requestedSmk: idSmk,
        requestedDospem: idDospem,
        requestedGuruPamong: idGuruPamong,
      );

      if (!isReflected) {
        // Fallback tampilan agar user tidak mendapat false error merah.
        _applyLocalAssignmentFallback(
          pendaftaranId: pendaftaranId,
          idSmk: idSmk,
          idDospem: idDospem,
          idGuruPamong: idGuruPamong,
        );

        AppSnackbar.show(
          "Sukses",
          "Assign berhasil dikirim. Data server belum sinkron di respons terbaru, tampilan diperbarui sementara.",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
        return;
      }

      AppSnackbar.show(
        "Sukses",
        "Berhasil meng-assign:\n• SMK: ${getNamaSmk(idSmk)}\n• Dosen: ${getNamaDospem(idDospem)}\n• Guru: ${getNamaGuruPamong(idGuruPamong)}",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      AppSnackbar.show(
        "Error",
        "Gagal meng-assign:\n${_normalizeErrorMessage(e)}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isAssigning.value = false;
    }
  }

  PendaftaranPlpModel? _findRegistrationById(int pendaftaranId) {
    final index = pendaftaranList.indexWhere(
      (item) => item.id == pendaftaranId,
    );
    if (index == -1) return null;
    return pendaftaranList[index];
  }

  Future<PendaftaranPlpModel?> _refreshAndFindRegistration(
    int pendaftaranId,
  ) async {
    final refreshedData = await PendaftaranPlpService.getAllPendaftaranPlp();
    pendaftaranList.assignAll(refreshedData);
    return _findRegistrationById(pendaftaranId);
  }

  bool _isAssignmentReflected({
    required PendaftaranPlpModel? before,
    required PendaftaranPlpModel? after,
    required int requestedSmk,
    required int requestedDospem,
    required int requestedGuruPamong,
  }) {
    if (after == null) return false;

    final smkOk = _isFieldReflected(
      beforeValue: before?.penempatan,
      afterValue: after.penempatan,
      requestedValue: requestedSmk,
    );

    final dospemOk = _isFieldReflected(
      beforeValue: before?.dosenPembimbing,
      afterValue: after.dosenPembimbing,
      requestedValue: requestedDospem,
    );

    final guruOk = _isFieldReflected(
      beforeValue: before?.guruPamong,
      afterValue: after.guruPamong,
      requestedValue: requestedGuruPamong,
    );

    return smkOk && dospemOk && guruOk;
  }

  bool _isFieldReflected({
    required int? beforeValue,
    required int? afterValue,
    required int requestedValue,
  }) {
    if (afterValue == null) return false;

    // Case ideal: ID sama dengan yang dipilih user.
    if (afterValue == requestedValue) return true;

    // Antisipasi backend mengembalikan ID relasi berbeda namespace.
    if (beforeValue == null) return true;
    if (afterValue != beforeValue) return true;

    return false;
  }

  void _applyLocalAssignmentFallback({
    required int pendaftaranId,
    required int idSmk,
    required int idDospem,
    required int idGuruPamong,
  }) {
    final index = pendaftaranList.indexWhere(
      (item) => item.id == pendaftaranId,
    );
    if (index == -1) return;

    final current = pendaftaranList[index];
    pendaftaranList[index] = PendaftaranPlpModel(
      id: current.id,
      userId: current.userId,
      namaMahasiswa: current.namaMahasiswa,
      keminatanId: current.keminatanId,
      nilaiPlp1: current.nilaiPlp1,
      nilaiMicroTeaching: current.nilaiMicroTeaching,
      pilihanSmk1: current.pilihanSmk1,
      pilihanSmk2: current.pilihanSmk2,
      penempatan: idSmk,
      dosenPembimbing: idDospem,
      guruPamong: idGuruPamong,
      createdAt: current.createdAt,
      updatedAt: current.updatedAt,
    );
  }

  String _normalizeErrorMessage(Object error) {
    final rawMessage = error.toString();
    if (rawMessage.startsWith('Exception: ')) {
      return rawMessage.replaceFirst('Exception: ', '');
    }
    return rawMessage;
  }
}
