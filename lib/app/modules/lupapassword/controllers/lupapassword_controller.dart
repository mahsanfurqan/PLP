import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LupapasswordController extends GetxController {
  var emailController = TextEditingController();
  var isSendingOTP = false.obs;
  var email = "".obs;

  void sendOTP() {
    if (emailController.text.isEmpty) {
      Get.snackbar("Error", "Email tidak boleh kosong");
      return;
    }

    email.value = emailController.text; // Simpan email yang dimasukkan

    isSendingOTP.value = true;
    Future.delayed(const Duration(seconds: 2), () {
      isSendingOTP.value = false;
      Get.snackbar("Berhasil", "Kode OTP telah dikirim ke email Anda");

      // Navigasi ke halaman OTP dengan membawa email
      Get.toNamed('/otp', arguments: {"email": email.value});
    });
  }
}
