import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plp/app/modules/lupapassword/controllers/lupapassword_controller.dart';
import 'package:plp/widget/custom_button.dart';
import 'package:plp/widget/custom_text_field.dart';

class LupapasswordView extends GetView<LupapasswordController> {
  const LupapasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          double paddingHorizontal = width > 600 ? 80 : 24;

          return Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 500,
                  minHeight: constraints.maxHeight * 0.6,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                      const Center(
                        child: Text(
                          "Ubah Password?",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Center(
                        child: Text(
                          "Masukkan alamat email yang terhubung\ndengan akun Anda",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        hintText: "Email atau username",
                        controller:
                            controller
                                .emailController, // Gunakan controller di sini
                      ),
                      const SizedBox(height: 20),
                      Obx(
                        () => CustomButton(
                          text: "BERIKAN CODE OTP",
                          color: Colors.blue,
                          shadowColor: Colors.blue.shade700,
                          onTap: controller.sendOTP,
                          isPressed: controller.isSendingOTP.value,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
