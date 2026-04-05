import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plp/app/navbar/custom_navbar.dart';
import 'package:plp/widget/custom_button_action.dart';
import '../controllers/smk_controller.dart';
import 'package:plp/app/navbar/navbar_controller.dart';

class SmkView extends GetView<SmkController> {
  const SmkView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SmkController());
    final role = Get.find<NavbarController>().role.value;

    return Scaffold(
      appBar: AppBar(title: const Text('List SMK'), centerTitle: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Expanded(
              child:
                  controller.smkList.isEmpty
                      ? const Center(child: Text('Belum ada data SMK'))
                      : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        itemCount: controller.smkList.length,
                        itemBuilder: (context, index) {
                          final smk = controller.smkList[index];
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
                                        smk.id.toString().padLeft(3, '0'),
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
                                            text: "SMK : ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(text: smk.nama),
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
              if (role == 'Dosen Pembimbing') {
                return const SizedBox.shrink();
              }
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
                      text: 'TAMBAH SMK',
                      color: const Color(0xFF6DD400),
                      shadowColor: const Color(0xFF5CB500),
                      onPressed: () {
                        _showAddSmkDialog(context, controller);
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

  void _showAddSmkDialog(BuildContext context, SmkController controller) {
    final namaSmkC = TextEditingController();

    Get.defaultDialog(
      title: "Tambah SMK Baru",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: namaSmkC,
            decoration: const InputDecoration(
              labelText: "Nama SMK",
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
                if (namaSmkC.text.trim().isEmpty) {
                  Get.snackbar('Gagal', 'Nama SMK tidak boleh kosong.');
                  return;
                }

                controller.namaSmkBaru.value = namaSmkC.text.trim();

                Get.back();

                Future.delayed(Duration.zero, () async {
                  controller.isSubmitting(true);
                  await controller.tambahSmk();
                  controller.isSubmitting(false);
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
