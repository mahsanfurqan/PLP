import 'package:get/get.dart';

import '../controllers/lihatdataplpall_controller.dart';

class LihatdataplpallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LihatdataplpallController>(
      () => LihatdataplpallController(),
    );
  }
}
