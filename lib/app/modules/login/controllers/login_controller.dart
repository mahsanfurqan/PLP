import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:plp/models/simple_login_response.dart';
import 'package:plp/service/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:plp/widget/app_snackbar.dart';

class LoginController extends GetxController {
  var isPasswordVisible = false.obs;
  var isLoginPressed = false.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final box = GetStorage();

  bool isUbEmail(String email) {
    final emailRegex = RegExp(
      r'^[A-Za-z0-9._%+-]+@(?:[A-Za-z0-9-]+\.)*ub\.ac\.id$',
      caseSensitive: false,
    );
    return emailRegex.hasMatch(email.trim());
  }

  String? validateLoginInput({
    required String email,
    required String password,
  }) {
    final trimmedEmail = email.trim();
    final trimmedPassword = password.trim();

    if (trimmedEmail.isEmpty || trimmedPassword.isEmpty) {
      return 'Email dan password wajib diisi!';
    }

    if (!isUbEmail(trimmedEmail)) {
      return 'Hanya email dengan domain .ub.ac.id yang diperbolehkan!';
    }

    return null;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void _showSingleSnackbar(String title, String message) {
    if (AppSnackbar.isShowing) return;
    AppSnackbar.show(title, message);
  }

  Future<void> login() async {
    if (isLoginPressed.value) return;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final validationMessage = validateLoginInput(
      email: email,
      password: password,
    );
    if (validationMessage != null) {
      _showSingleSnackbar("Error", validationMessage);
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
          'integrity_pact_accepted':
              jsonResponse['integrity_pact_accepted'] == true,
          'integrity_pact_accepted_at':
              jsonResponse['integrity_pact_accepted_at'],
        });

        _showSingleSnackbar("Berhasil", result.status);
        Get.offAllNamed('/home');
      } else {
        final json = jsonDecode(response.body);
        final message = json['message'] ?? 'Login gagal';
        _showSingleSnackbar("Gagal", message);
      }
    } catch (e) {
      isLoginPressed.value = false;
      _showSingleSnackbar("Error", "Terjadi kesalahan: $e");
    }
  }

  void goToRegister() {
    Get.toNamed('/createprofile');
  }

  Future<void> forgotPassword() async {
    final url = Uri.parse('http://plp.divisigurutugasduba.com/forgot-password');
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      AppSnackbar.show('Error', 'Tidak dapat membuka halaman lupa password');
    }
  }
}
