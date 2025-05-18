import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/validasilogbook_controller.dart';

class ValidasilogbookView extends GetView<ValidasilogbookController> {
  const ValidasilogbookView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validasi Logbook'),
        centerTitle: true,
        elevation: 1,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        }

        if (controller.logbooks.isEmpty) {
          return const Center(
            child: Text(
              'Tidak ada logbook untuk divalidasi.',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          itemCount: controller.logbooks.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final logbook = controller.logbooks[index];

            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                title: Text(
                  logbook.keterangan,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tanggal: ${logbook.tanggal}'),
                      const SizedBox(height: 4),
                      _buildStatusRow(
                        label: 'Status Anda',
                        status: logbook.status,
                        approvalStatus: logbook.yourApprovalStatus,
                      ),
                    ],
                  ),
                ),
                trailing: Wrap(
                  spacing: 4,
                  children: [
                    IconButton(
                      tooltip: 'Setujui logbook',
                      icon: const Icon(Icons.check_circle, color: Colors.green),
                      onPressed:
                          () => _onValidatePressed(
                            context,
                            logbook.id,
                            'approved',
                          ),
                    ),
                    IconButton(
                      tooltip: 'Tolak logbook',
                      icon: const Icon(Icons.cancel, color: Colors.red),
                      onPressed:
                          () => _onValidatePressed(
                            context,
                            logbook.id,
                            'rejected',
                          ),
                    ),
                  ],
                ),
                onTap: () {
                  _showLogbookDetailDialog(context, logbook);
                },
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildStatusRow({
    required String label,
    required String status,
    required String approvalStatus,
  }) {
    Color statusColor;
    String statusText;

    // Logika status visualisasi bisa kamu sesuaikan dengan skema status di backend
    if (approvalStatus.toLowerCase() == 'approved') {
      statusColor = Colors.green;
      statusText = 'Disetujui';
    } else if (approvalStatus.toLowerCase() == 'rejected') {
      statusColor = Colors.red;
      statusText = 'Ditolak';
    } else {
      statusColor = Colors.orange;
      statusText = 'Menunggu';
    }

    return Row(
      children: [
        Text('$label: '),
        Text(
          statusText,
          style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Future<void> _onValidatePressed(
    BuildContext context,
    int logbookId,
    String action,
  ) async {
    final confirmed = await _showConfirmDialog(
      context,
      action == 'approved' ? 'Setujui logbook ini?' : 'Tolak logbook ini?',
    );

    if (confirmed) {
      final success = await controller.validateLogbook(logbookId, action);
      if (success) {
        Get.snackbar(
          'Sukses',
          action == 'approved' ? 'Logbook disetujui' : 'Logbook ditolak',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade300,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Gagal',
          action == 'approved'
              ? 'Gagal menyetujui logbook'
              : 'Gagal menolak logbook',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade300,
          colorText: Colors.white,
        );
      }
    }
  }

  Future<bool> _showConfirmDialog(BuildContext context, String message) async {
    return (await showDialog<bool>(
          context: context,
          builder:
              (ctx) => AlertDialog(
                title: const Text('Konfirmasi'),
                content: Text(message),
                actions: [
                  TextButton(
                    child: const Text('Batal'),
                    onPressed: () => Navigator.of(ctx).pop(false),
                  ),
                  ElevatedButton(
                    child: const Text('Ya'),
                    onPressed: () => Navigator.of(ctx).pop(true),
                  ),
                ],
              ),
        )) ??
        false;
  }

  void _showLogbookDetailDialog(BuildContext context, logbook) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Detail Logbook'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text('Tanggal: ${logbook.tanggal}'),
                  Text('Keterangan: ${logbook.keterangan}'),
                  Text('Status Guru: ${logbook.status}'),
                  Text(
                    'Status Dosen Pembimbing: ${logbook.yourApprovalStatus}',
                  ),
                  if (logbook.mulai != null)
                    Text('Jam Mulai: ${logbook.mulai}'),
                  if (logbook.selesai != null)
                    Text('Jam Selesai: ${logbook.selesai}'),
                  if (logbook.dokumentasi != null)
                    Text('Link Dokumentasi: ${logbook.dokumentasi}'),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Tutup'),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
    );
  }
}
