import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  final box = GetStorage();
  final namaAkun = 'Pengguna'.obs;
  final emailAkun = '-'.obs;
  final roleAkun = 'Observer'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserProfile();
  }

  void _loadUserProfile() {
    final user = box.read('user');

    if (user is Map) {
      final rawName =
          _asCleanString(user['name']) ?? _asCleanString(user['nama']);
      final rawEmail = _asCleanString(user['email']);
      final rawRole = _asCleanString(user['role']);

      emailAkun.value = rawEmail ?? '-';
      roleAkun.value = rawRole ?? 'Observer';

      if (rawName != null) {
        namaAkun.value = rawName;
      } else if (rawEmail != null && rawEmail.contains('@')) {
        namaAkun.value = rawEmail.split('@').first;
      } else {
        namaAkun.value = 'Pengguna';
      }
    } else {
      namaAkun.value = 'Pengguna';
      emailAkun.value = '-';
      roleAkun.value = 'Observer';
    }
  }

  String? _asCleanString(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    if (text.isEmpty || text == 'null' || text == '-') return null;
    return text;
  }
}
