import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:plp/widget/app_snackbar.dart';

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
      AppSnackbar.show("Error", "Password tidak boleh kosong");
      return;
    }
    if (newPasswordController.text != confirmPasswordController.text) {
      AppSnackbar.show("Error", "Password tidak cocok");
      return;
    }

    isConfirming.value = true;
    Future.delayed(const Duration(seconds: 2), () {
      isConfirming.value = false;
      AppSnackbar.show("Success", "Password berhasil diubah");
      Get.toNamed('/login');
    });
  }
}
