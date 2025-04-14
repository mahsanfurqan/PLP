import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:plp/widget/custom_button.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double imageSize = screenWidth > 600 ? 350 : 450;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/neko.png', height: imageSize),
              const SizedBox(height: 20),
              Text(
                "Mengajar dengan aksi, belajar dengan hati!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth > 600 ? 39 : 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4B4B4B),
                ),
              ),
              const SizedBox(height: 30),
              Obx(
                () => CustomButton(
                  text: "MULAI",
                  color: Color(0xFF58CC02),
                  shadowColor: Colors.green.shade700,
                  onTap: () {
                    controller.triggerStartButton();
                    controller.goToHome();
                  },
                  isPressed: controller.isStartButtonPressed.value,
                ),
              ),

              const SizedBox(height: 10),
              Obx(
                () => CustomButton(
                  text: "SUDAH PUNYA AKUN",
                  color: Colors.white,
                  shadowColor: Colors.black12,
                  borderColor: Colors.black12,
                  textColor: Colors.lightBlue,
                  onTap: () {
                    controller.triggerLoginButton();
                    controller.goToLogin();
                  },
                  isPressed: controller.isLoginButtonPressed.value,
                  borderWidth: 3.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
