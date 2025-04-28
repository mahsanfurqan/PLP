import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plp/app/navbar/custom_navbar.dart';
import 'package:plp/widget/custom_button_action.dart';
import '../controllers/keminatan_controller.dart';

class KeminatanView extends GetView<KeminatanController> {
  const KeminatanView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(KeminatanController());

    return Scaffold(
      appBar: AppBar(title: const Text('List Keminatan'), centerTitle: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Expanded(
              child:
                  controller.keminatanList.isEmpty
                      ? const Center(child: Text('Belum ada data Keminatan'))
                      : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        itemCount: controller.keminatanList.length,
                        itemBuilder: (context, index) {
                          final keminatan = controller.keminatanList[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 80,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      right: BorderSide(color: Colors.black),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "ID",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        keminatan['id'].toString().padLeft(
                                          3,
                                          '0',
                                        ),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    child: RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                        children: [
                                          const TextSpan(
                                            text: "Keminatan : ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: keminatan['name'] ?? '',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
            ),
            const Divider(height: 1, thickness: 1),
            Obx(() {
              return controller.isSubmitting.value
                  ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Center(child: CircularProgressIndicator()),
                  )
                  : Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: CustomButtonAction(
                      text: 'TAMBAH KEMINATAN',
                      color: const Color(0xFF6DD400),
                      shadowColor: const Color(0xFF5CB500),
                      onPressed: () {
                        _showAddKeminatanDialog(context, controller);
                      },
                      isPressed: false,
                    ),
                  );
            }),
            const SizedBox(height: 8),
          ],
        );
      }),
      bottomNavigationBar: CustomNavbar(),
    );
  }

  void _showAddKeminatanDialog(
    BuildContext context,
    KeminatanController controller,
  ) {
    final namaKeminatanC = TextEditingController();

    Get.defaultDialog(
      title: "Tambah Keminatan Baru",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: namaKeminatanC,
            decoration: const InputDecoration(
              labelText: "Nama Keminatan",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          Obx(
            () => CustomButtonAction(
              text: 'SIMPAN',
              color: const Color(0xFFF6AA1C),
              shadowColor: const Color(0xFFD68718),
              onPressed: () {
                if (namaKeminatanC.text.trim().isEmpty) {
                  Get.snackbar('Gagal', 'Nama keminatan tidak boleh kosong.');
                  return;
                }

                controller.namaKeminatanBaru.value = namaKeminatanC.text.trim();

                // Langsung tutup dialog
                Get.back();

                // Tunggu 1 frame biar aman
                Future.delayed(Duration.zero, () async {
                  controller.isSubmitting(true); // Tunjukkan loading di luar
                  await controller.tambahKeminatan();
                  controller.isSubmitting(
                    false,
                  ); // Matikan loading setelah selesai
                });
              },

              isPressed: controller.isSubmitting.value,
            ),
          ),
        ],
      ),
    );
  }
}
