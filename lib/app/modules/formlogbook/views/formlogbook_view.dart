import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            GestureDetector(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  tanggalC.text = controller.formatTanggal(
                    pickedDate,
                  ); // dd/MM/yyyy
                }
              },
              child: AbsorbPointer(
                child: CustomTextField(
                  controller: tanggalC,
                  hintText: 'dd/MM/yyyy',
                  inputFormatters: [DateInputFormatter()],
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text('Jam Mulai'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  mulaiC.text =
                      '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
                }
              },
              child: AbsorbPointer(
                child: CustomTextField(
                  controller: mulaiC,
                  hintText: 'HH:mm',
                  suffixIcon: const Icon(Icons.access_time, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text('Jam Selesai'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  selesaiC.text =
                      '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
                }
              },
              child: AbsorbPointer(
                child: CustomTextField(
                  controller: selesaiC,
                  hintText: 'HH:mm',
                  suffixIcon: const Icon(Icons.access_time, color: Colors.grey),
                ),
              ),
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
                        color: const Color(0xFFF6AA1C),
                        shadowColor: const Color(0xFFD68718),
                        onPressed: () {
                          controller.tanggal.value = controller
                              .convertTanggalToIso(tanggalC.text);
                          controller.mulai.value = controller.formatJam(
                            mulaiC.text,
                          );
                          controller.selesai.value = controller.formatJam(
                            selesaiC.text,
                          );
                          controller.keterangan.value = keteranganC.text;
                          controller.dokumentasi.value = dokumentasiC.text;

                          // Validasi opsional
                          if (controller.tanggal.value.isEmpty ||
                              controller.mulai.value.isEmpty ||
                              controller.selesai.value.isEmpty ||
                              controller.keterangan.value.isEmpty) {
                            Get.snackbar(
                              'Gagal',
                              'Lengkapi semua field terlebih dahulu',
                            );
                            return;
                          }

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
