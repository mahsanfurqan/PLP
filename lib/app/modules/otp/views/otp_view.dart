import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plp/app/modules/otp/controllers/otp_controller.dart';
import 'package:plp/widget/custom_button.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});

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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "OTP Verification",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () => Text(
                          "Kode 4 digit telah dikirim ke\n${controller.email.value}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Input OTP
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          4,
                          (index) => SizedBox(
                            width: 50,
                            height: 50,
                            child: TextField(
                              controller: controller.otp[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                counterText: "",
                                filled: true,
                                fillColor: Colors.grey.shade300,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty && index < 3) {
                                  FocusScope.of(
                                    context,
                                  ).nextFocus(); // Pindah ke field berikutnya
                                } else if (value.isEmpty && index > 0) {
                                  FocusScope.of(
                                    context,
                                  ).previousFocus(); // Kembali ke field sebelumnya
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Kirim Ulang OTP
                      Center(
                        child: GestureDetector(
                          onTap: controller.resendOTP,
                          child: const Text.rich(
                            TextSpan(
                              text: "Belum meneria kode? ",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text: "Kirim Ulang",
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

                      const SizedBox(height: 20),

                      // Tombol Submit OTP
                      Obx(
                        () => CustomButton(
                          text: "MASUKKAN OTP",
                          color: Colors.blue,
                          shadowColor: Colors.blue.shade700,
                          onTap: controller.validateOtp,
                          isPressed: controller.isVerifying.value,
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
