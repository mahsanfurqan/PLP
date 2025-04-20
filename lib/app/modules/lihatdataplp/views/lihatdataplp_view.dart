import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plp/app/navbar/custom_navbar.dart';
import '../controllers/lihatdataplp_controller.dart';

class LihatdataplpView extends GetView<LihatdataplpController> {
  const LihatdataplpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Data PLP',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(child: Text(controller.errorMessage.value));
          }

          if (controller.dataPendaftaran.isEmpty) {
            return const Center(child: Text("Belum ada data pendaftaran."));
          }

          final data = controller.dataPendaftaran.first;

          return Container(
            width: double.infinity,
            height: 410,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.indigo[900]!, width: 2),
              borderRadius: BorderRadius.circular(25),
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildItem("Nama", controller.nama.value),
                buildItem("NIM", controller.nim.value),
                buildItem(
                  "BIDANG",
                  controller.getNamaKeminatan(data.keminatanId),
                ),
                buildItem("ANGKATAN", controller.angkatan.value),
                buildItem("Nilai PLP 1", data.nilaiPlp1 ?? "-"),
                buildItem("Nilai Micro", data.nilaiMicroTeaching ?? "-"),
                buildItem("SMK 1", controller.getNamaSmk(data.pilihanSmk1)),
                buildItem("SMK 2", controller.getNamaSmk(data.pilihanSmk2)),
              ],
            ),
          );
        }),
      ),
      bottomNavigationBar: CustomNavbar(),
    );
  }

  Widget buildItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.indigo[900], size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$label: $value',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
