import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plp/app/navbar/custom_navbar.dart';
import '../controllers/gurupamong_controller.dart';

class GurupamongView extends GetView<GurupamongController> {
  const GurupamongView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GurupamongController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Guru Pamong'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Expanded(
              child:
                  controller.guruList.isEmpty
                      ? const Center(child: Text('Belum ada data Guru Pamong'))
                      : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        itemCount: controller.guruList.length,
                        itemBuilder: (context, index) {
                          final guru = controller.guruList[index];
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
                                        guru.id.toString().padLeft(3, '0'),
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
                                            text: "Nama Guru : ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(text: guru.name ?? ''),
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
            const SizedBox(height: 8),
          ],
        );
      }),
      bottomNavigationBar: CustomNavbar(),
    );
  }
}
