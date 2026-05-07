import 'package:get/get.dart';

import '../controllers/laporananonim_controller.dart';

class LaporananonimBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LaporananonimController>(() => LaporananonimController());
  }
}
