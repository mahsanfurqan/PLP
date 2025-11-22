import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:plp/service/auth_service.dart';
import 'package:plp/config/email_config.dart';

class LupapasswordController extends GetxController {
  var emailController = TextEditingController();
  var isSendingOTP = false.obs;
  var email = "".obs;
  var otp = "".obs;
  var otpExpiry = DateTime.now();

  // Generate a 6-digit OTP
  String _generateOTP() {
    Random random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  // Send OTP via email
  Future<void> _sendOTPEmail(String email, String otp) async {
    final smtpServer = SmtpServer(
      EmailConfig.mailHost,
      username: EmailConfig.mailUsername,
      password: EmailConfig.mailPassword,
      port: EmailConfig.mailPort,
      ssl: false,
      allowInsecure: true,
    );

    // Create email message
    final message =
        Message()
          ..from = Address(
            EmailConfig.mailFromAddress,
            EmailConfig.mailFromName,
          )
          ..recipients.add(email)
          ..subject = 'Reset Password - Kode OTP Anda'
          ..html = EmailConfig.getPasswordResetEmail(email.split('@')[0], otp);

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport.toString()}');
    } on MailerException catch (e) {
      print('Message not sent. Error: ${e.toString()}');
      rethrow;
    }
  }

  void sendOTP() async {
    if (emailController.text.isEmpty) {
      Get.snackbar("Error", "Email tidak boleh kosong");
      return;
    }

    if (!emailController.text.endsWith('ub.ac.id')) {
      Get.snackbar(
        "Error",
        "Hanya email dengan domain .ub.ac.id yang diperbolehkan!",
      );
      return;
    }

    email.value = emailController.text.trim();
    otp.value = _generateOTP();
    otpExpiry = DateTime.now().add(
      const Duration(minutes: 10),
    ); // OTP valid for 10 minutes

    isSendingOTP.value = true;

    try {
      // First, request password reset from the API
      final response = await AuthService.requestPasswordReset(
        email: email.value,
      );

      if (response.statusCode == 200) {
        // If API call is successful, send OTP via email
        await _sendOTPEmail(email.value, otp.value);

        Get.snackbar("Berhasil", "Kode OTP telah dikirim ke email Anda");

        // Navigate to OTP verification screen with email and OTP
        Get.toNamed(
          '/otp',
          arguments: {
            'email': email.value,
            'otp': otp.value,
            'otpExpiry': otpExpiry.toIso8601String(),
          },
        );
      } else {
        final error = jsonDecode(response.body);
        Get.snackbar(
          "Gagal",
          error['message'] ?? 'Terjadi kesalahan saat mengirim OTP',
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal mengirim OTP. Silakan coba lagi nanti.");
    } finally {
      isSendingOTP.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
