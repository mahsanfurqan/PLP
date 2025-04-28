import 'package:get/get.dart';

import '../controllers/lihatlogbookall_controller.dart';

class LihatlogbookallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LihatlogbookallController>(
      () => LihatlogbookallController(),
    );
  }
}
