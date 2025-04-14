import 'package:get/get.dart';
import 'package:flutter/material.dart';

class GantipasswordController extends GetxController {
  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  var isConfirming = false.obs;

  TextEditingController newPasswordController =
      TextEditingController(); // Tambahkan ini
  TextEditingController confirmPasswordController = TextEditingController();

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  void confirmPassword() {
    if (newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar("Error", "Password tidak boleh kosong");
      return;
    }
    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar("Error", "Password tidak cocok");
      return;
    }

    isConfirming.value = true;
    Future.delayed(const Duration(seconds: 2), () {
      isConfirming.value = false;
      Get.snackbar("Success", "Password berhasil diubah");
      Get.toNamed('/login');
    });
  }
}
