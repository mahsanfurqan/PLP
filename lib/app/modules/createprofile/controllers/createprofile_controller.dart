import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:plp/models/auth_response_model.dart';
import 'package:plp/service/auth_service.dart';
import 'package:plp/widget/app_snackbar.dart';

class CreateprofileController extends GetxController {
  var isPasswordVisible = false.obs;
  var isCreateAccountPressed = false.obs;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final box = GetStorage();

  bool isUbEmail(String email) {
    final emailRegex = RegExp(
      r'^[A-Za-z0-9._%+-]+@(?:[A-Za-z0-9-]+\.)*ub\.ac\.id$',
      caseSensitive: false,
    );
    return emailRegex.hasMatch(email.trim());
  }

  String? validateRegistrationInput({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    if ([name, email, password, confirmPassword].any((e) => e.trim().isEmpty)) {
      return 'Semua field harus diisi!';
    }

    if (!isUbEmail(email)) {
      return 'Hanya email dengan domain ub.ac.id yang diperbolehkan!';
    }

    if (password.trim() != confirmPassword.trim()) {
      return 'Password dan konfirmasi tidak cocok!';
    }

    return null;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> createAccount() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    final validationMessage = validateRegistrationInput(
      name: name,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
    if (validationMessage != null) {
      AppSnackbar.show("Error", validationMessage);
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

        AppSnackbar.show("Berhasil", result.message);
        Get.toNamed('/login'); // langsung ke home
      } else {
        final result = AuthResponseModel.fromJson(response.body);
        AppSnackbar.show("Gagal", result.message);
      }
    } catch (e) {
      isCreateAccountPressed.value = false;
      AppSnackbar.show("Error", "Terjadi kesalahan: $e");
    }
  }

  void goToLogin() {
    Get.toNamed('/login');
  }
}
