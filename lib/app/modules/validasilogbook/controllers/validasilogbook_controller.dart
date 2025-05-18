import 'package:get/get.dart';
import 'package:plp/models/logbook_model.dart';
import 'package:plp/service/logbook_service.dart';

class ValidasilogbookController extends GetxController {
  var logbooks = <LogbookModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLogbooksValidasi();
  }

  Future<void> fetchLogbooksValidasi() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await LogbookService.getLogbooksForValidation();

      // Debug print jumlah data yang diterima
      print('Jumlah logbook yang diterima: ${result.length}');

      if (result.isEmpty) {
        errorMessage.value = 'Tidak ada logbook untuk divalidasi.';
      }
      logbooks.value = result;
    } catch (e) {
      errorMessage.value = 'Gagal memuat data logbook: $e';
      logbooks.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // Contoh method validasi logbook, PUT /api/logbooks/validasi/{id}
  Future<bool> validateLogbook(int id, String status) async {
    try {
      final success = await LogbookService.updateValidationStatus(id, status);
      if (success) {
        // refresh data setelah update
        await fetchLogbooksValidasi();
        return true;
      }
      return false;
    } catch (e) {
      errorMessage.value = 'Gagal validasi logbook: $e';
      return false;
    }
  }
}
