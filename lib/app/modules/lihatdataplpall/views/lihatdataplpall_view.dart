import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/lihatdataplpall_controller.dart';

class LihatdataplpallView extends GetView<LihatdataplpallController> {
  const LihatdataplpallView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lihat Logbook Mahasiswa'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.pendaftaranList.isEmpty) {
            return const Center(child: Text("Belum ada data pendaftaran."));
          }

          return ListView.builder(
            itemCount: controller.pendaftaranList.length,
            itemBuilder: (context, index) {
              final pendaftaran = controller.pendaftaranList[index];
              return GestureDetector(
                onTap: () {
                  _showDetailDialog(context, pendaftaran);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("user_id : ${pendaftaran.userId}"),
                            Text("keminatan_id : ${pendaftaran.keminatanId}"),
                            Text("nilai plp 1 : ${pendaftaran.nilaiPlp1}"),
                            Text(
                              "nilai micro teaching : ${pendaftaran.nilaiMicroTeaching}",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  void _showDetailDialog(BuildContext context, var pendaftaran) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Detail Pendaftaran'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ID: ${pendaftaran.id}"),
                  Text("User ID: ${pendaftaran.userId}"),
                  Text("Keminatan ID: ${pendaftaran.keminatanId}"),
                  Text("Nilai PLP 1: ${pendaftaran.nilaiPlp1}"),
                  Text(
                    "Nilai Micro Teaching: ${pendaftaran.nilaiMicroTeaching}",
                  ),
                  Text("Pilihan SMK 1: ${pendaftaran.pilihanSmk1}"),
                  Text("Pilihan SMK 2: ${pendaftaran.pilihanSmk2}"),
                  Text("Penempatan: ${pendaftaran.penempatan ?? '-'}"),
                  Text(
                    "Dosen Pembimbing: ${pendaftaran.dosenPembimbing ?? '-'}",
                  ),
                  Text("Created At: ${pendaftaran.createdAt}"),
                  Text("Updated At: ${pendaftaran.updatedAt}"),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Tutup'),
                onPressed: () => Get.back(),
              ),
            ],
          ),
    );
  }
}
