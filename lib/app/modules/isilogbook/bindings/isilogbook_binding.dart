import 'package:get/get.dart';

import '../controllers/isilogbook_controller.dart';

class IsilogbookBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IsilogbookController>(
      () => IsilogbookController(),
    );
  }
}
