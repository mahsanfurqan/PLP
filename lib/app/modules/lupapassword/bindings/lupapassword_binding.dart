import 'package:get/get.dart';

import '../controllers/lupapassword_controller.dart';

class LupapasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LupapasswordController>(
      () => LupapasswordController(),
    );
  }
}
