import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:plp/widget/app_snackbar.dart';

class OtpController extends GetxController {
  var isVerifying = false.obs;
  var email = "".obs;
  var otp = List.generate(4, (index) => TextEditingController()).obs;
  var otpError = ''.obs;

  void validateOtp() {
    String enteredOtp = otp.map((controller) => controller.text).join();

    if (enteredOtp.length < 4) {
      otpError.value = "Masukkan 4 digit OTP";
    } else {
      otpError.value = "";
      AppSnackbar.show("Berhasil", "Silahkan ganti password Anda");
      Get.toNamed('/gantipassword');
    }
  }

  void resendOTP() {
    AppSnackbar.show(
      "OTP Dikirim",
      "Kode OTP baru telah dikirim ke email Anda.",
    );
  }

  void onInit() {
    super.onInit();
    // Ambil email dari argument yang dikirim
    if (Get.arguments != null && Get.arguments["email"] != null) {
      email.value = Get.arguments["email"];
    }
  }
}
