import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plp/models/pendaftaranplp_model.dart';
import '../controllers/lihatdataplpall_controller.dart';
import '../widget/registration_card.dart';
import '../widget/registration_detail_bottom_sheet.dart';

class LihatdataplpallView extends GetView<LihatdataplpallController> {
  const LihatdataplpallView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lihat Data Pendaftaran PLP'),
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

              return RegistrationCard(
                registration: pendaftaran,
                index: index,
                onTap: () {
                  _showRegistrationDetail(context, pendaftaran);
                },
              );
            },
          );
        }),
      ),
    );
  }

  void _showRegistrationDetail(
    BuildContext context,
    PendaftaranPlpModel pendaftaran,
  ) async {
    // Ensure dropdown data is available
    if (controller.smkList.isEmpty ||
        controller.dospems.isEmpty ||
        controller.guruPamongs.isEmpty) {
      await controller.fetchDropdownData();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.8,
            minChildSize: 0.6,
            maxChildSize: 0.95,
            builder:
                (context, scrollController) => RegistrationDetailBottomSheet(
                  registration: pendaftaran,
                  smkList: controller.smkList,
                  dospems: controller.dospems,
                  guruPamongs: controller.guruPamongs,
                  onAssign: (
                    pendaftaranId,
                    idSmk,
                    idDospem,
                    idGuruPamong,
                  ) async {
                    await controller.assignPenempatanDanDospem(
                      pendaftaranId: pendaftaranId,
                      idSmk: idSmk,
                      idDospem: idDospem,
                      idGuruPamong: idGuruPamong,
                    );
                  },
                ),
          ),
    );
  }
}
