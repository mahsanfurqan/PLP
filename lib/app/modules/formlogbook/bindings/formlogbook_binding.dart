import 'package:get/get.dart';

import '../controllers/formlogbook_controller.dart';

class FormlogbookBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FormlogbookController>(
      () => FormlogbookController(),
    );
  }
}
