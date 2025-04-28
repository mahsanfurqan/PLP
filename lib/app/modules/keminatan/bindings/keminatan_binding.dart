import 'package:get/get.dart';

import '../controllers/keminatan_controller.dart';

class KeminatanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KeminatanController>(
      () => KeminatanController(),
    );
  }
}
