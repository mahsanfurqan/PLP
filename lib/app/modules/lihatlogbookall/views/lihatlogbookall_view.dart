import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/lihatlogbookall_controller.dart';

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

              return GestureDetector(
                onTap: () {
                  // Saat item ditekan, tampilkan semua detail
                  Get.defaultDialog(
                    title: "Detail Logbook",
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('ID: ${logbook.id}'),
                        Text('User ID: ${logbook.userId}'),
                        Text('Tanggal: ${logbook.tanggal}'),
                        Text('Keterangan: ${logbook.keterangan}'),
                        Text('Mulai: ${logbook.mulai}'),
                        Text('Selesai: ${logbook.selesai}'),
                        Text('Dokumentasi: ${logbook.dokumentasi}'),
                      ],
                    ),
                  );
                },
                child: Card(
                  color: Colors.blueGrey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      'User ID: ${logbook.userId}, Tanggal: ${logbook.tanggal}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Keterangan: ${logbook.keterangan.length > 30 ? logbook.keterangan.substring(0, 30) + '...' : logbook.keterangan}',
                        ),
                        Text('Mulai: ${logbook.mulai}'),
                        Text('Selesai: ${logbook.selesai}'),
                        Text('Dokumentasi: ${logbook.dokumentasi}'),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
