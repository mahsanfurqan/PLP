import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plp/widget/custom_button.dart';
import 'package:plp/widget/custom_text_field.dart';
import '../controllers/createprofile_controller.dart';

class CreateprofileView extends GetView<CreateprofileController> {
  const CreateprofileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateprofileController());

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Create your profile",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4B4B4B),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Nama Lengkap
            CustomTextField(
              hintText: "Nama Lengkap",
              controller: controller.nameController,
            ),
            const SizedBox(height: 10),

            // Email
            CustomTextField(
              hintText: "Email",
              controller: controller.emailController,
            ),
            const SizedBox(height: 10),

            // Password
            Obx(
              () => TextField(
                controller: controller.passwordController,
                obscureText: !controller.isPasswordVisible.value,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: const TextStyle(color: Colors.black12),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black12,
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black12,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black54,
                      width: 2,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.blue,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Konfirmasi Password
            Obx(
              () => TextField(
                controller: controller.confirmPasswordController,
                obscureText: !controller.isPasswordVisible.value,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  hintText: "Konfirmasi Password",
                  hintStyle: const TextStyle(color: Colors.black12),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black12,
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black12,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black54,
                      width: 2,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.blue,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            Obx(
              () => CustomButton(
                text: "CREATE ACCOUNT",
                color: Colors.blue,
                shadowColor: Colors.blue.shade700,
                onTap: () {
                  controller.createAccount();
                },
                isPressed: controller.isCreateAccountPressed.value,
              ),
            ),
            const SizedBox(height: 18),

            Center(
              child: GestureDetector(
                onTap: controller.goToLogin,
                child: const Text.rich(
                  TextSpan(
                    text: "Sudah punya akun? ",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: "LOG IN",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
