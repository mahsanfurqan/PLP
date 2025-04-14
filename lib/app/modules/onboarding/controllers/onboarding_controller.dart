import 'package:get/get.dart';

class OnboardingController extends GetxController {
  var isStartButtonPressed = false.obs;
  var isLoginButtonPressed = false.obs;

  void triggerStartButton() {
    isStartButtonPressed.value = true;
    Future.delayed(Duration(milliseconds: 100), () {
      isStartButtonPressed.value = false;
    });
  }

  void triggerLoginButton() {
    isLoginButtonPressed.value = true;
    Future.delayed(Duration(milliseconds: 100), () {
      isLoginButtonPressed.value = false;
    });
  }

  void goToHome() {
    Get.toNamed('/createprofile');
  }

  void goToLogin() {
    Get.toNamed('/login');
  }
}
