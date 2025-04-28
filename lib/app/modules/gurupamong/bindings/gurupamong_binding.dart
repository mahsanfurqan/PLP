import 'package:get/get.dart';

import '../controllers/gurupamong_controller.dart';

class GurupamongBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GurupamongController>(
      () => GurupamongController(),
    );
  }
}
