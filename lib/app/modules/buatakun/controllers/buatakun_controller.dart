import 'package:get/get.dart';
import 'package:plp/service/akun_service.dart';
import 'package:flutter/material.dart';
import 'package:plp/widget/app_snackbar.dart';

class BuatakunController extends GetxController {
  // Form fields
  var name = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var passwordConfirmation = ''.obs;
  var selectedRole = 'Observer'.obs;
  var details = <String, dynamic>{}.obs;

  // Loading state
  var isSubmitting = false.obs;

  // Role options
  final roleOptions = [
    'Observer',
    'Kaprodi',
    'Dosen Koordinator',
    'Dosen Pembimbing',
    'Akademik',
    'Mahasiswa',
    'Guru',
    'Admin',
  ];

  // Form validation
  bool get isFormValid {
    final isValid =
        name.value.isNotEmpty &&
        email.value.isNotEmpty &&
        password.value.isNotEmpty &&
        passwordConfirmation.value.isNotEmpty &&
        selectedRole.value.isNotEmpty &&
        password.value == passwordConfirmation.value &&
        _isValidEmail(email.value);

    // Debug logging
    print('🔍 Form validation check:');
    print('   - Name: "${name.value}" (${name.value.isNotEmpty ? "✅" : "❌"})');
    print(
      '   - Email: "${email.value}" (${email.value.isNotEmpty ? "✅" : "❌"})',
    );
    print('   - Email format: ${_isValidEmail(email.value) ? "✅" : "❌"}');
    print(
      '   - Password: "${password.value}" (${password.value.isNotEmpty ? "✅" : "❌"})',
    );
    print(
      '   - Password Confirmation: "${passwordConfirmation.value}" (${passwordConfirmation.value.isNotEmpty ? "✅" : "❌"})',
    );
    print(
      '   - Role: "${selectedRole.value}" (${selectedRole.value.isNotEmpty ? "✅" : "❌"})',
    );
    print(
      '   - Password match: ${password.value == passwordConfirmation.value ? "✅" : "❌"}',
    );
    print('   - Overall valid: $isValid');

    return isValid;
  }

  /// 📧 Email validation helper
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// 📝 Submit pembuatan akun
  Future<void> submitBuatAkun() async {
    print('🔄 Submit button pressed');
    print('📊 Current form values:');
    print('   - Name: "${name.value}"');
    print('   - Email: "${email.value}"');
    print('   - Password: "${password.value}"');
    print('   - Password Confirmation: "${passwordConfirmation.value}"');
    print('   - Role: "${selectedRole.value}"');

    if (!isFormValid) {
      print('❌ Form validation failed');

      // Specific validation messages
      if (name.value.isEmpty) {
        AppSnackbar.show(
          "Validasi",
          "Nama harus diisi",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }
      if (email.value.isEmpty) {
        AppSnackbar.show(
          "Validasi",
          "Email harus diisi",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }
      if (!_isValidEmail(email.value)) {
        AppSnackbar.show(
          "Validasi",
          "Format email tidak valid (contoh: user@example.com)",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }
      if (password.value.isEmpty) {
        AppSnackbar.show(
          "Validasi",
          "Password harus diisi",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }
      if (passwordConfirmation.value.isEmpty) {
        AppSnackbar.show(
          "Validasi",
          "Konfirmasi password harus diisi",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }
      if (selectedRole.value.isEmpty) {
        AppSnackbar.show(
          "Validasi",
          "Role harus dipilih",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      AppSnackbar.show(
        "Validasi",
        "Mohon lengkapi semua field yang diperlukan",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (password.value != passwordConfirmation.value) {
      print('❌ Password confirmation mismatch');
      AppSnackbar.show(
        "Validasi",
        "Password dan konfirmasi password tidak sama",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    print('✅ Form validation passed, proceeding with account creation');
    isSubmitting.value = true;

    try {
      print('🔄 Creating account...');
      print('📝 Name: ${name.value}');
      print('📧 Email: ${email.value}');
      print('🔐 Role: ${selectedRole.value}');
      print('📋 Details: ${details.value}');

      final result = await AkunService.createAccount(
        name: name.value,
        email: email.value,
        password: password.value,
        passwordConfirmation: passwordConfirmation.value,
        role: selectedRole.value,
        details: details.value.isNotEmpty ? details.value : null,
      );

      print('✅ Account created successfully: $result');

      AppSnackbar.show(
        "Sukses",
        "Akun berhasil dibuat!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Reset form
      resetForm();

      // Navigate back to home
      Get.offAllNamed('/home');
    } catch (e) {
      print('❌ Error creating account: $e');
      AppSnackbar.show(
        "Error",
        "Gagal membuat akun:\n${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  /// 🔄 Reset form
  void resetForm() {
    name.value = '';
    email.value = '';
    password.value = '';
    passwordConfirmation.value = '';
    selectedRole.value = 'Observer';
    details.value = {};
  }

  /// 📋 Add detail field
  void addDetail(String key, String value) {
    details[key] = value;
  }

  /// 🗑️ Remove detail field
  void removeDetail(String key) {
    details.remove(key);
  }
}
