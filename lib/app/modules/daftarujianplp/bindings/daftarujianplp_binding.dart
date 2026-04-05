import 'package:get/get.dart';

import '../controllers/daftarujianplp_controller.dart';

class DaftarujianplpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DaftarujianplpController>(
      () => DaftarujianplpController(),
    );
  }
}
