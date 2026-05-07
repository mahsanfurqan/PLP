import 'package:get/get.dart';
import 'package:plp/models/logbook_group_model.dart';
import 'package:plp/service/logbook_service.dart';

class LihatlogbookallController extends GetxController {
  final isLoading = false.obs;
  final groups = <LogbookGroupModel>[].obs;
  final selectedGroup = Rxn<LogbookGroupModel>();

  @override
  void onInit() {
    super.onInit();
    fetchGroups();
  }

  Future<void> fetchGroups() async {
    try {
      isLoading.value = true;
      final result = await LogbookService.getLogbookGroups();
      groups.assignAll(result);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat kelompok logbook: $e');
      groups.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void openGroup(LogbookGroupModel group) {
    selectedGroup.value = group;
  }

  void backToGroupList() {
    selectedGroup.value = null;
  }
}
