import 'package:get/get.dart';

import '../controllers/lihatdataplp_controller.dart';

class LihatdataplpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LihatdataplpController>(
      () => LihatdataplpController(),
    );
  }
}
