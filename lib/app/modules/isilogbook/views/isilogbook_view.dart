import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plp/app/navbar/custom_navbar.dart';
import 'package:plp/widget/custom_button.dart';
import '../controllers/isilogbook_controller.dart';

class IsilogbookView extends GetView<IsilogbookController> {
  const IsilogbookView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Logbook Anda',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.logbookList.isEmpty) {
              return const Center(child: Text("Belum ada logbook"));
            }

            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 100),
              itemCount: controller.logbookList.length,
              itemBuilder: (context, index) {
                final logbook = controller.logbookList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Column untuk tombol delete dan edit
                            Column(
                              children: [
                                // Tombol delete
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    Get.defaultDialog(
                                      title: "Konfirmasi",
                                      middleText: "Hapus logbook ini?",
                                      textConfirm: "Ya",
                                      textCancel: "Tidak",
                                      onConfirm: () {
                                        Get.back();
                                        controller.deleteLogbook(logbook.id);
                                      },
                                    );
                                  },
                                ),
                                // Tombol edit di bawah delete
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    controller.goToEditLogbook(logbook);
                                  },
                                ),
                              ],
                            ),
                            // Data logbook
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 4,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "ID ${logbook.id}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text("Mulai : ${logbook.mulai}"),
                                    Text("Selesai : ${logbook.selesai}"),
                                    Text("Keterangan : ${logbook.keterangan}"),
                                    Text(
                                      "Dokumentasi : ${logbook.dokumentasi}",
                                    ),
                                    Text(
                                      "Tanggal Kegiatan : ${logbook.tanggal}",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
          // Tombol tambah logbook
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(height: 1, thickness: 1),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    child: Obx(
                      () => CustomButton(
                        text: "TAMBAH LOGBOOK",
                        color: const Color(0xFF58CC02),
                        shadowColor: Colors.green.shade700,
                        onTap: () {
                          controller.isStartButtonPressed.value = true;
                          controller.goToTambahLogbook();
                        },
                        isPressed: controller.isStartButtonPressed.value,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavbar(),
    );
  }
}
