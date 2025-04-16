import 'package:get/get.dart';

import '../controllers/pendaftaranplp_controller.dart';

class PendaftaranplpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PendaftaranplpController>(() => PendaftaranplpController());
  }
}
