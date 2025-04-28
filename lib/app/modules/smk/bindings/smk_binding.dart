import 'package:get/get.dart';

import '../controllers/smk_controller.dart';

class SmkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SmkController>(
      () => SmkController(),
    );
  }
}
