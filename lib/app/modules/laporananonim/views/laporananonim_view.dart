import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plp/widget/custom_button_action.dart';
import 'package:plp/widget/custom_text_field.dart';
import 'package:plp/widget/input_formatters.dart';

import '../controllers/laporananonim_controller.dart';

class LaporananonimView extends GetView<LaporananonimController> {
  const LaporananonimView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pelaporan Anonim'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Form ini dapat diisi tanpa akun. Laporan akan diproses oleh sistem dan diteruskan ke Dosen Koordinator.',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 20),

            const Text('Nama Mahasiswa'),
            const SizedBox(height: 8),
            CustomTextField(
              hintText: 'Masukkan nama mahasiswa',
              controller: controller.studentNameController,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            const Text('Tanggal Kejadian'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );

                if (pickedDate != null) {
                  controller.incidentDateController.text = controller
                      .formatTanggal(pickedDate);
                }
              },
              child: AbsorbPointer(
                child: CustomTextField(
                  hintText: 'dd/MM/yyyy',
                  controller: controller.incidentDateController,
                  inputFormatters: [DateInputFormatter()],
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text('Deskripsi Kejadian'),
            const SizedBox(height: 8),
            CustomTextField(
              hintText: 'Jelaskan kejadian yang dilaporkan',
              controller: controller.incidentDescriptionController,
              maxLines: 6,
              textInputAction: TextInputAction.newline,
            ),
            const SizedBox(height: 28),

            const Text('Bukti Foto (Opsional)'),
            const SizedBox(height: 8),
            Obx(() {
              final selectedImage = controller.selectedEvidenceImage.value;
              final selectedImageBytes =
                  controller.selectedEvidenceImageBytes.value;

              if (selectedImage == null) {
                return InkWell(
                  onTap: controller.pickEvidenceImage,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.add_photo_alternate_outlined, size: 30),
                        SizedBox(height: 6),
                        Text('Pilih foto dari galeri'),
                      ],
                    ),
                  ),
                );
              }

              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                      child:
                          selectedImageBytes == null
                              ? Container(
                                width: double.infinity,
                                height: 180,
                                color: Colors.black12,
                                alignment: Alignment.center,
                                child: const Text('Preview tidak tersedia'),
                              )
                              : Image.memory(
                                selectedImageBytes,
                                width: double.infinity,
                                height: 180,
                                fit: BoxFit.cover,
                              ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              selectedImage.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: controller.removeEvidenceImage,
                            icon: const Icon(Icons.delete_outline),
                            label: const Text('Hapus'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 28),

            Obx(
              () =>
                  controller.isSubmitting.value
                      ? const Center(child: CircularProgressIndicator())
                      : CustomButtonAction(
                        text: 'KIRIM',
                        color: const Color(0xFF58CC02),
                        shadowColor: Colors.green.shade700,
                        onPressed: () {
                          controller.triggerSubmitButton();
                          controller.submitAnonymousReport();
                        },
                        isPressed: controller.isSubmitButtonPressed.value,
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
