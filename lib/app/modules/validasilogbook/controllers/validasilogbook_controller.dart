import 'package:get/get.dart';
import 'package:plp/models/logbook_model.dart';
import 'package:plp/service/logbook_service.dart';

class BulkValidationResult {
  final int totalTarget;
  final int successCount;
  final int failedCount;

  const BulkValidationResult({
    required this.totalTarget,
    required this.successCount,
    required this.failedCount,
  });
}

class ValidasilogbookController extends GetxController {
  var logbooks = <LogbookModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isBulkApproving = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLogbooksValidasi();
  }

  Future<void> fetchLogbooksValidasi() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final logbooksResult = await LogbookService.getLogbooksForValidation();

      if (logbooksResult.isEmpty) {
        errorMessage.value = 'Tidak ada logbook untuk divalidasi.';
      }
      logbooks.value = logbooksResult;
    } catch (e) {
      errorMessage.value = 'Gagal memuat data logbook: $e';
      logbooks.clear();
    } finally {
      isLoading.value = false;
    }
  }

  bool _isPendingForCurrentApprover(LogbookModel logbook) {
    return logbook.yourApprovalStatus.toLowerCase() == 'pending';
  }

  int get pendingCount => logbooks.where(_isPendingForCurrentApprover).length;

  Future<bool> _validateLogbookWithoutRefresh(
    int id,
    String status, {
    String? note,
  }) async {
    try {
      return await LogbookService.updateValidationStatus(
        id,
        status,
        note: note,
      );
    } catch (e) {
      errorMessage.value = 'Gagal validasi logbook: $e';
      return false;
    }
  }

  Future<bool> validateLogbook(int id, String status, {String? note}) async {
    final success = await _validateLogbookWithoutRefresh(
      id,
      status,
      note: note,
    );
    if (success) {
      await fetchLogbooksValidasi();
    }
    return success;
  }

  Future<BulkValidationResult> approveAllPendingLogbooks() async {
    if (isBulkApproving.value) {
      return const BulkValidationResult(
        totalTarget: 0,
        successCount: 0,
        failedCount: 0,
      );
    }

    final targets =
        logbooks.where(_isPendingForCurrentApprover).map((e) => e.id).toList();

    if (targets.isEmpty) {
      return const BulkValidationResult(
        totalTarget: 0,
        successCount: 0,
        failedCount: 0,
      );
    }

    isBulkApproving.value = true;
    int success = 0;
    int failed = 0;

    try {
      for (final id in targets) {
        final ok = await _validateLogbookWithoutRefresh(id, 'approved');
        if (ok) {
          success++;
        } else {
          failed++;
        }
      }
      await fetchLogbooksValidasi();
      return BulkValidationResult(
        totalTarget: targets.length,
        successCount: success,
        failedCount: failed,
      );
    } finally {
      isBulkApproving.value = false;
    }
  }
}
