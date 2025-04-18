import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plp/app/navbar/custom_navbar.dart';
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
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dropdown Keminatan
              const Text("Pilih Keminatan"),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value:
                    controller.keminatanList.any(
                          (e) =>
                              e['id'] == controller.selectedKeminatanId.value,
                        )
                        ? controller.selectedKeminatanId.value
                        : null,
                items:
                    controller.keminatanList.map((keminatan) {
                      return DropdownMenuItem<int>(
                        value: keminatan['id'],
                        child: Text(keminatan['nama']),
                      );
                    }).toList(),
                onChanged: (value) {
                  controller.selectedKeminatanId.value = value!;
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Nilai PLP 1
              const Text("Nilai PLP 1"),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value:
                    controller.nilaiOptions.contains(
                          controller.selectedNilaiPlp1.value,
                        )
                        ? controller.selectedNilaiPlp1.value
                        : null,
                items:
                    controller.nilaiOptions.map((nilai) {
                      return DropdownMenuItem<String>(
                        value: nilai,
                        child: Text(nilai),
                      );
                    }).toList(),
                onChanged: (value) {
                  controller.selectedNilaiPlp1.value = value!;
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Nilai Micro Teaching
              const Text("Nilai Micro Teaching"),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value:
                    controller.nilaiOptions.contains(
                          controller.selectedNilaiMicro.value,
                        )
                        ? controller.selectedNilaiMicro.value
                        : null,
                items:
                    controller.nilaiOptions.map((nilai) {
                      return DropdownMenuItem<String>(
                        value: nilai,
                        child: Text(nilai),
                      );
                    }).toList(),
                onChanged: (value) {
                  controller.selectedNilaiMicro.value = value!;
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Dropdown Pilihan SMK 1
              const Text("Pilihan SMK 1"),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value:
                    controller.smkList.any(
                          (e) => e['id'] == controller.selectedSmk1Id.value,
                        )
                        ? controller.selectedSmk1Id.value
                        : null,
                items:
                    controller.smkList.map((smk) {
                      return DropdownMenuItem<int>(
                        value: smk['id'],
                        child: Text(smk['nama']),
                      );
                    }).toList(),
                onChanged: (value) {
                  controller.selectedSmk1Id.value = value!;
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Dropdown Pilihan SMK 2
              const Text("Pilihan SMK 2"),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value:
                    controller.smkList.any(
                          (e) => e['id'] == controller.selectedSmk2Id.value,
                        )
                        ? controller.selectedSmk2Id.value
                        : null,
                items:
                    controller.smkList.map((smk) {
                      return DropdownMenuItem<int>(
                        value: smk['id'],
                        child: Text(smk['nama']),
                      );
                    }).toList(),
                onChanged: (value) {
                  controller.selectedSmk2Id.value = value!;
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
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
      ),
      bottomNavigationBar: CustomNavbar(),
    );
  }
}
