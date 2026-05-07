import 'package:get/get.dart';
import 'package:plp/app/routes/app_pages.dart';

class OnboardingController extends GetxController {
  var isStartButtonPressed = false.obs;
  var isLoginButtonPressed = false.obs;
  var isReportButtonPressed = false.obs;

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

  void triggerReportButton() {
    isReportButtonPressed.value = true;
    Future.delayed(Duration(milliseconds: 100), () {
      isReportButtonPressed.value = false;
    });
  }

  void goToHome() {
    Get.toNamed(Routes.CREATEPROFILE);
  }

  void goToLogin() {
    Get.toNamed(Routes.LOGIN);
  }

  void goToAnonymousReport() {
    Get.toNamed(Routes.LAPORANANONIM);
  }
}
