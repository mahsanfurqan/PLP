import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:plp/app/routes/app_pages.dart';
import 'package:plp/models/laporan_anonim_model.dart';
import 'package:plp/service/laporan_anonim_service.dart';
import 'package:plp/widget/app_snackbar.dart';

class LihatpelaporanController extends GetxController {
  static const int _evidenceAutoRetryCount = 3;

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final laporanList = <LaporanAnonimModel>[].obs;
  final markingReadIds = <int>{}.obs;
  final evidenceImageBytes = <int, Uint8List>{}.obs;
  final loadingEvidenceIds = <int>{}.obs;
  final failedEvidenceIds = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _guardRoleAndLoad();
  }

  Future<void> _guardRoleAndLoad() async {
    final userData = GetStorage().read('user');
    final role = userData?['role']?.toString() ?? 'Observer';

    if (role != 'Dosen Koordinator' && role != 'Kaprodi') {
      AppSnackbar.show(
        'Akses Ditolak',
        'Hanya Dosen Koordinator dan Kaprodi yang dapat melihat halaman ini.',
        snackPosition: SnackPosition.TOP,
      );
      Get.offAllNamed(Routes.HOME);
      return;
    }

    await fetchLaporan();
  }

  Future<void> fetchLaporan() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = await LaporanAnonimService.getLaporanAnonimForCoordinator();
      laporanList.assignAll(data);
      _syncEvidenceState(data);
      _prefetchEvidenceImages(data);

      if (data.isEmpty) {
        errorMessage.value = 'Belum ada pelaporan masuk.';
      }
    } catch (e) {
      laporanList.clear();
      errorMessage.value = 'Gagal memuat data pelaporan: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void _syncEvidenceState(List<LaporanAnonimModel> data) {
    final activeIds = data.map((item) => item.id).toSet();

    evidenceImageBytes.removeWhere((key, _) => !activeIds.contains(key));
    loadingEvidenceIds.removeWhere((id) => !activeIds.contains(id));
    failedEvidenceIds.removeWhere((id) => !activeIds.contains(id));
  }

  void _prefetchEvidenceImages(List<LaporanAnonimModel> data) {
    for (final report in data) {
      final imageUrl = report.evidenceImageUrl;
      if (imageUrl == null || imageUrl.isEmpty) continue;
      loadEvidenceImage(report.id, imageUrl);
    }
  }

  Future<void> loadEvidenceImage(
    int reportId,
    String imageUrl, {
    bool forceRefresh = false,
  }) async {
    if (loadingEvidenceIds.contains(reportId)) return;
    if (!forceRefresh && evidenceImageBytes.containsKey(reportId)) return;

    try {
      loadingEvidenceIds.add(reportId);
      failedEvidenceIds.remove(reportId);
      if (forceRefresh) {
        evidenceImageBytes.remove(reportId);
      }

      Uint8List? bytes;
      Object? lastError;

      for (var attempt = 0; attempt < _evidenceAutoRetryCount; attempt++) {
        try {
          bytes = await LaporanAnonimService.fetchEvidenceImageBytes(reportId);
          break;
        } catch (error) {
          lastError = error;
          if (attempt < _evidenceAutoRetryCount - 1) {
            await Future.delayed(const Duration(milliseconds: 900));
          }
        }
      }

      if (bytes != null) {
        evidenceImageBytes[reportId] = bytes;
        failedEvidenceIds.remove(reportId);
        return;
      }

      throw lastError ?? Exception('Gagal memuat gambar bukti.');
    } catch (_) {
      failedEvidenceIds.add(reportId);
    } finally {
      loadingEvidenceIds.remove(reportId);
    }
  }

  Future<void> tandaiDibaca(int reportId) async {
    if (markingReadIds.contains(reportId)) return;

    try {
      markingReadIds.add(reportId);
      await LaporanAnonimService.markLaporanAsRead(reportId);

      final index = laporanList.indexWhere((item) => item.id == reportId);
      if (index != -1) {
        final old = laporanList[index];
        laporanList[index] = LaporanAnonimModel(
          id: old.id,
          studentName: old.studentName,
          incidentDescription: old.incidentDescription,
          incidentDate: old.incidentDate,
          source: old.source,
          evidenceImageUrl: old.evidenceImageUrl,
          createdAt: old.createdAt,
          isRead: true,
        );
      }

      AppSnackbar.show(
        'Sukses',
        'Laporan ditandai sebagai dibaca.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      AppSnackbar.show(
        'Gagal',
        'Tidak dapat menandai laporan: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      markingReadIds.remove(reportId);
    }
  }
}
