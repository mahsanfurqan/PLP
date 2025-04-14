import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:plp/models/auth_response_model.dart';
import 'package:plp/service/auth_service.dart';

class CreateprofileController extends GetxController {
  var isPasswordVisible = false.obs;
  var isCreateAccountPressed = false.obs;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final box = GetStorage();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> createAccount() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if ([name, email, password, confirmPassword].any((e) => e.isEmpty)) {
      Get.snackbar("Error", "Semua field harus diisi!");
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar("Error", "Password dan konfirmasi tidak cocok!");
      return;
    }

    isCreateAccountPressed.value = true;

    try {
      final response = await AuthService.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: confirmPassword,
      );

      isCreateAccountPressed.value = false;

      if (response.statusCode == 201 || response.statusCode == 200) {
        final result = AuthResponseModel.fromJson(response.body);

        box.write('token', result.data?.token);
        box.write('user', {
          'id': result.data?.user.id,
          'name': result.data?.user.name,
          'email': result.data?.user.email,
          'role': result.data?.user.role,
        });

        print("✅ Token register: ${result.data?.token}");

        Get.snackbar("Berhasil", result.message);
        Get.toNamed('/login'); // langsung ke home
      } else {
        final result = AuthResponseModel.fromJson(response.body);
        Get.snackbar("Gagal", result.message);
      }
    } catch (e) {
      isCreateAccountPressed.value = false;
      Get.snackbar("Error", "Terjadi kesalahan: $e");
    }
  }

  void goToLogin() {
    Get.toNamed('/login');
  }
}
