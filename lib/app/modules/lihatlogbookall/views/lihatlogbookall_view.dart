import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/lihatlogbookall_controller.dart';
import '../widget/logbook_card.dart';
import '../widget/logbook_detail_bottom_sheet.dart';

class LihatlogbookallView extends GetView<LihatlogbookallController> {
  const LihatlogbookallView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LihatlogbookallController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lihat Logbook Mahasiswa'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.logbookList.isEmpty) {
            return const Center(child: Text('Tidak ada data logbook.'));
          }

          return ListView.builder(
            itemCount: controller.logbookList.length,
            itemBuilder: (context, index) {
              final logbook = controller.logbookList[index];
              final userName = controller.getUserName(logbook.userId);

              return LogbookCard(
                logbook: logbook,
                userName: userName,
                index: index,
                onTap: () {
                  _showLogbookDetail(context, logbook, userName);
                },
              );
            },
          );
        }),
      ),
    );
  }

  void _showLogbookDetail(BuildContext context, logbook, String userName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder:
                (context, scrollController) => LogbookDetailBottomSheet(
                  logbook: logbook,
                  userName: userName,
                ),
          ),
    );
  }
}
