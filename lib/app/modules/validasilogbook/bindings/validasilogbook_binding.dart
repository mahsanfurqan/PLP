import 'package:get/get.dart';

import '../controllers/validasilogbook_controller.dart';

class ValidasilogbookBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ValidasilogbookController>(
      () => ValidasilogbookController(),
    );
  }
}
