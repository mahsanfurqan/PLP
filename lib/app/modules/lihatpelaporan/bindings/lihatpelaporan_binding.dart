import 'package:get/get.dart';

import '../controllers/lihatpelaporan_controller.dart';

class LihatpelaporanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LihatpelaporanController>(() => LihatpelaporanController());
  }
}
