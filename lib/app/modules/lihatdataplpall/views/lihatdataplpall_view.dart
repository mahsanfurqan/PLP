import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plp/models/pendaftaranplp_model.dart';
import 'package:plp/models/smk_model.dart';
import 'package:plp/models/user_model.dart';
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

  void _showDetailDialog(
    BuildContext context,
    PendaftaranPlpModel pendaftaran,
  ) {
    final Rxn<SmkModel> selectedSmk = Rxn<SmkModel>();
    final Rxn<UserModel> selectedDospem = Rxn<UserModel>();

    controller.fetchDropdownData();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Detail Pendaftaran'),
            content: Obx(
              () => SingleChildScrollView(
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
                    const SizedBox(height: 16),
                    Text(
                      "Penempatan Saat Ini: ${pendaftaran.penempatan ?? '-'}",
                    ),
                    Text(
                      "Dosen Pembimbing: ${pendaftaran.dosenPembimbing ?? '-'}",
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<SmkModel>(
                      value: selectedSmk.value,
                      hint: const Text("Pilih SMK Penempatan"),
                      items:
                          controller.smkList.map((smk) {
                            return DropdownMenuItem(
                              value: smk,
                              child: Text(smk.nama),
                            );
                          }).toList(),
                      onChanged: (value) {
                        selectedSmk.value = value;
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<UserModel>(
                      value: selectedDospem.value,
                      hint: const Text("Pilih Dosen Pembimbing"),
                      items:
                          controller.dospems.map((user) {
                            return DropdownMenuItem(
                              value: user,
                              child: Text(user.name),
                            );
                          }).toList(),
                      onChanged: (value) {
                        selectedDospem.value = value;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Batal'),
                onPressed: () => Get.back(),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (selectedSmk.value == null ||
                      selectedDospem.value == null) {
                    Get.snackbar(
                      "Validasi",
                      "Mohon pilih SMK dan Dosen Pembimbing",
                    );
                    return;
                  }
                  await controller.assignPenempatanDanDospem(
                    pendaftaranId: pendaftaran.id!,
                    idSmk: selectedSmk.value!.id!,
                    idDospem: selectedDospem.value!.id!,
                  );
                  Get.back(); // Tutup dialog
                },
                child: const Text('Assign'),
              ),
            ],
          ),
    );
  }
}
