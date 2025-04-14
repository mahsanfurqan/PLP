import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:plp/models/simple_login_response.dart';
import 'package:plp/service/auth_service.dart';

class LoginController extends GetxController {
  var isPasswordVisible = false.obs;
  var isLoginPressed = false.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final box = GetStorage();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Email dan password wajib diisi!");
      return;
    }

    isLoginPressed.value = true;

    try {
      final response = await AuthService.login(
        email: email,
        password: password,
      );

      isLoginPressed.value = false;

      if (response.statusCode == 200) {
        log("📥 Response Body Mentah: ${response.body}");

        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final result = SimpleLoginResponse.fromJson(jsonResponse);

        final name = jsonResponse['name'] ?? '';
        final role = jsonResponse['role'] ?? 'Observer';

        // Simpan token dan user ke local storage
        box.write('token', result.token);
        box.write('user', {
          'id': result.id,
          'name': name,
          'email': result.email,
          'role': role,
        });

        log("✅ Token tersimpan: ${result.token}");
        log("✅ Role tersimpan: $role");

        Get.snackbar("Berhasil", result.status);
        Get.toNamed('/home');
      } else {
        final json = jsonDecode(response.body);
        final message = json['message'] ?? 'Login gagal';
        Get.snackbar("Gagal", message);
      }
    } catch (e) {
      isLoginPressed.value = false;
      Get.snackbar("Error", "Terjadi kesalahan: $e");
    }
  }

  void goToRegister() {
    Get.toNamed('/createprofile');
  }

  void forgotPassword() {
    Get.toNamed('/lupapassword');
  }
}
