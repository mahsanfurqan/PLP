// pendaftaranplp_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plp/widget/custom_text_field.dart';
import 'package:plp/widget/custom_button.dart';
import '../controllers/pendaftaranplp_controller.dart';

class PendaftaranplpView extends GetView<PendaftaranplpController> {
  const PendaftaranplpView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PendaftaranplpController());

    return Scaffold(
      appBar: AppBar(title: const Text('Pendaftaran PLP'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              hintText: "Keminatan ID",
              controller: controller.keminatanIdController,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              hintText: "Nilai PLP 1",
              controller: controller.nilaiPlp1Controller,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              hintText: "Nilai Micro Teaching",
              controller: controller.nilaiMicroController,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              hintText: "Pilihan SMK 1",
              controller: controller.pilihanSmk1Controller,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              hintText: "Pilihan SMK 2",
              controller: controller.pilihanSmk2Controller,
            ),
            const SizedBox(height: 24),
            Obx(
              () => CustomButton(
                text: "DAFTAR",
                color: Colors.blue,
                shadowColor: Colors.blue.shade700,
                onTap: controller.submitPendaftaran,
                isPressed: controller.isSubmitting.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
