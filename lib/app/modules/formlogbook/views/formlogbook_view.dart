import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plp/widget/custom_button.dart';
import 'package:plp/widget/custom_button_action.dart';
import 'package:plp/widget/custom_text_field.dart';
import 'package:plp/widget/input_formatters.dart';

import '../controllers/formlogbook_controller.dart';

class FormlogbookView extends GetView<FormlogbookController> {
  const FormlogbookView({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller Text Field
    final tanggalC = TextEditingController();
    final mulaiC = TextEditingController();
    final selesaiC = TextEditingController();
    final keteranganC = TextEditingController();
    final dokumentasiC = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Logbook Anda',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tanggal Kegiatan'),
            const SizedBox(height: 8),
            CustomTextField(
              controller: tanggalC,
              hintText: 'dd/MM/yyyy',
              inputFormatters: [DateInputFormatter()],
            ),
            const SizedBox(height: 16),

            const Text('Jam mulai'),
            const SizedBox(height: 8),
            CustomTextField(
              controller: mulaiC,
              hintText: 'HH:mm',
              inputFormatters: [TimeInputFormatter()],
            ),
            const SizedBox(height: 16),

            const Text('Jam Selesai'),
            const SizedBox(height: 8),
            CustomTextField(
              controller: selesaiC,
              hintText: 'HH:mm',
              inputFormatters: [TimeInputFormatter()],
            ),
            const SizedBox(height: 16),

            const Text('Keterangan'),
            const SizedBox(height: 8),
            CustomTextField(
              hintText: 'Deskripsikan kegiatanmu...',
              controller: keteranganC,
              maxLines: 6,
            ),
            const SizedBox(height: 16),

            const Text('Link Foto'),
            const SizedBox(height: 8),
            CustomTextField(
              hintText: 'Link Foto Anda',
              controller: dokumentasiC,
            ),
            const SizedBox(height: 32),

            Obx(
              () =>
                  controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : CustomButtonAction(
                        text: 'SIMPAN',
                        color: Color(0xFFF6AA1C),
                        shadowColor: Color(0xFFD68718),
                        onPressed: () {
                          controller.tanggal.value = tanggalC.text;
                          controller.mulai.value = mulaiC.text;
                          controller.selesai.value = selesaiC.text;
                          controller.keterangan.value = keteranganC.text;
                          controller.dokumentasi.value = dokumentasiC.text;
                          controller.submitLogbook();
                        },
                        isPressed: false,
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
