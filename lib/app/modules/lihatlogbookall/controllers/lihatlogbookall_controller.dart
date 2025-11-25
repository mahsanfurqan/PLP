import 'package:get/get.dart';
import 'package:plp/service/logbook_service.dart';
import 'package:plp/service/akun_service.dart';
import 'package:plp/models/logbook_model.dart';
import 'package:plp/models/user_model.dart';

class LihatlogbookallController extends GetxController {
  var isLoading = false.obs;
  var logbookList = <LogbookModel>[].obs;
  var userNames = <int, String>{}.obs; // Map to store user names by ID
  var allUsers = <UserModel>[].obs; // Store all users

  @override
  void onInit() {
    super.onInit();
    fetchAllData();
  }

  /// 📝 Ambil semua logbook mahasiswa
  Future<void> fetchAllLogbooks() async {
    try {
      isLoading.value = true;
      final result = await LogbookService.getAllLogbooks();
      logbookList.assignAll(result);

      // Fetch user names for all logbooks
      await _fetchUserNames();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat logbook: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔄 Fetch semua data (logbook + users)
  Future<void> fetchAllData() async {
    try {
      isLoading.value = true;

      // Try to fetch all logbooks, fallback to validation endpoint if unauthorized
      List<LogbookModel> logbooks;
      try {
        logbooks = await LogbookService.getAllLogbooks();
      } catch (e) {
        // If getAllLogbooks fails (unauthorized), try validation endpoint
        logbooks = await LogbookService.getLogbooksForValidation();
      }

      final users = await AkunService.getAllUsers();

      logbookList.assignAll(logbooks);
      allUsers.assignAll(users);

      // Create user name map
      _createUserNameMap();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// 👤 Create user name map from all users
  void _createUserNameMap() {
    userNames.clear();
    for (final user in allUsers) {
      userNames[user.id] = user.name;
    }
  }

  /// 👤 Fetch user names for all logbooks (old method - keeping for backup)
  Future<void> _fetchUserNames() async {
    try {
      for (final logbook in logbookList) {
        if (!userNames.containsKey(logbook.userId)) {
          final userName = await AkunService.getUserNameById(logbook.userId);
          userNames[logbook.userId] = userName;
        }
      }
    } catch (e) {
      print('Error fetching user names: $e');
    }
  }

  /// 👤 Get user name by ID
  String getUserName(int userId) {
    return userNames[userId] ?? 'User ID: $userId';
  }
}
