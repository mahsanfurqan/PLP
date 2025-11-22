import 'package:get/get.dart';
import '../controllers/buatakun_controller.dart';

class BuatakunBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuatakunController>(() => BuatakunController());
  }
}
