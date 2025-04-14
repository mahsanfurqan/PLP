import 'package:get/get.dart';

import '../controllers/selengkapnya_controller.dart';

class SelengkapnyaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelengkapnyaController>(
      () => SelengkapnyaController(),
    );
  }
}
