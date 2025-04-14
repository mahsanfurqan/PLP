import 'package:get/get.dart';

import '../controllers/createprofile_controller.dart';

class CreateprofileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateprofileController>(
      () => CreateprofileController(),
    );
  }
}
