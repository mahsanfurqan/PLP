import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plp/app/navbar/custom_navbar.dart';
import 'package:plp/models/logbook_model.dart';

import '../controllers/validasilogbook_controller.dart';

class ValidasilogbookView extends GetView<ValidasilogbookController> {
  const ValidasilogbookView({super.key});

  Future<void> _onApproveAllPressed(BuildContext context) async {
    if (controller.isBulkApproving.value) return;

    final pending = controller.pendingCount;
    if (pending == 0) {
      Get.snackbar(
        'Info',
        'Tidak ada logbook pending untuk disetujui.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final confirmed = await _showConfirmDialog(
      context,
      'Setujui semua logbook yang masih pending? ($pending logbook)',
    );

    if (!confirmed) return;

    final result = await controller.approveAllPendingLogbooks();
    if (result.totalTarget == 0) return;

    if (result.failedCount == 0) {
      Get.snackbar(
        'Sukses',
        'Berhasil menyetujui ${result.successCount} logbook.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade300,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Selesai dengan catatan',
        'Sukses: ${result.successCount}, Gagal: ${result.failedCount}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade300,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFF),
        surfaceTintColor: Colors.transparent,
        title: const Text('Validasi Logbook'),
        centerTitle: true,
        elevation: 0,
        actions: [
          Obx(
            () => Padding(
              padding: const EdgeInsets.only(right: 10),
              child: TextButton.icon(
                onPressed:
                    (controller.logbooks.isEmpty ||
                            controller.isBulkApproving.value)
                        ? null
                        : () => _onApproveAllPressed(context),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF2563EB),
                ),
                icon:
                    controller.isBulkApproving.value
                        ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Icon(Icons.done_all),
                label: Text(
                  controller.isBulkApproving.value
                      ? 'Proses...'
                      : 'Setujui Semua',
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x12000000),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        if (controller.logbooks.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Tidak ada logbook untuk divalidasi.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return Column(
          children: [
            if (controller.isBulkApproving.value)
              const LinearProgressIndicator(minHeight: 3),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
              child: _SummaryPanel(
                total: controller.logbooks.length,
                pending: controller.pendingCount,
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                itemCount: controller.logbooks.length,
                itemBuilder: (context, index) {
                  final logbook = controller.logbooks[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _ValidationCard(
                      logbook: logbook,
                      isBusy: controller.isBulkApproving.value,
                      onApprove: () => _onValidatePressed(
                        context,
                        logbook.id,
                        'approved',
                      ),
                      onReject: () => _showRejectDialog(context, logbook),
                      onTap: () => _showLogbookDetailDialog(context, logbook),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: const CustomNavbar(),
    );
  }

  Future<void> _showRejectDialog(
    BuildContext context,
    LogbookModel logbook,
  ) async {
    final noteController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Tolak Logbook'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tuliskan saran perbaikan agar mahasiswa tahu apa yang harus dibenahi.',
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: noteController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText:
                        'Contoh: tambahkan detail kegiatan, perjelas jam, atau sertakan dokumentasi yang relevan.',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final note = noteController.text.trim();
                  if (note.isEmpty) {
                    Get.snackbar(
                      'Catatan wajib',
                      'Isi alasan penolakan terlebih dahulu.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }

                  Navigator.of(ctx).pop();
                  await _onValidatePressed(
                    context,
                    logbook.id,
                    'rejected',
                    note: note,
                  );
                },
                child: const Text('Tolak'),
              ),
            ],
          ),
    );
  }

  Future<void> _onValidatePressed(
    BuildContext context,
    int logbookId,
    String action, {
    String? note,
  }) async {
    final confirmed = await _showConfirmDialog(
      context,
      action == 'approved'
          ? 'Setujui logbook ini?'
          : 'Tolak logbook ini dengan catatan perbaikan?',
    );

    if (!confirmed) return;

    final success = await controller.validateLogbook(
      logbookId,
      action,
      note: note,
    );

    if (success) {
      Get.snackbar(
        'Sukses',
        action == 'approved'
            ? 'Logbook disetujui'
            : 'Logbook ditolak dan catatan tersimpan',
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

  void _showLogbookDetailDialog(BuildContext context, LogbookModel logbook) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Detail Logbook'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mahasiswa: ${logbook.userName ?? '-'}'),
                  Text('Tanggal: ${logbook.tanggal}'),
                  Text('Jam: ${logbook.mulai} - ${logbook.selesai}'),
                  const SizedBox(height: 10),
                  const Text(
                    'Keterangan',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(logbook.keterangan),
                  if (logbook.dokumentasi.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text('Dokumentasi: ${logbook.dokumentasi}'),
                  ],
                  if (logbook.approvers.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    const Text(
                      'Status Semua Validator',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...logbook.approvers.map(
                      (approval) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          '${approval.role} ${approval.name}: ${_statusLabel(approval.status)}${approval.note.isNotEmpty ? '\nCatatan: ${approval.note}' : ''}',
                        ),
                      ),
                    ),
                  ],
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

  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return 'Disetujui';
      case 'rejected':
        return 'Ditolak';
      default:
        return 'Menunggu';
    }
  }
}

class _SummaryPanel extends StatelessWidget {
  const _SummaryPanel({required this.total, required this.pending});

  final int total;
  final int pending;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1D4ED8), Color(0xFF60A5FA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.fact_check_outlined, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Antrian Validasi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$pending logbook masih menunggu tindakan dari Anda.',
                  style: const TextStyle(
                    color: Color(0xFFE8EEFF),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Total',
                style: TextStyle(color: Color(0xFFE8EEFF), fontSize: 12),
              ),
              Text(
                '$total',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ValidationCard extends StatelessWidget {
  const _ValidationCard({
    required this.logbook,
    required this.isBusy,
    required this.onApprove,
    required this.onReject,
    required this.onTap,
  });

  final LogbookModel logbook;
  final bool isBusy;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                color: Color(0x11000000),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E7FF),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.school_outlined,
                      color: Color(0xFF4338CA),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          logbook.userName ?? 'Mahasiswa',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tanggal ${_formatDate(logbook.tanggal)}',
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _ValidatorStatusBadge(status: logbook.yourApprovalStatus),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  logbook.keterangan,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF334155),
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _InfoChip(
                    icon: Icons.schedule_outlined,
                    text: '${logbook.mulai} - ${logbook.selesai}',
                  ),
                  _InfoChip(
                    icon: Icons.people_alt_outlined,
                    text: '${logbook.approvers.length} validator',
                  ),
                ],
              ),
              if (logbook.yourNote.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFFED7AA)),
                  ),
                  child: Text(
                    'Catatan Anda: ${logbook.yourNote}',
                    style: const TextStyle(
                      color: Color(0xFF9A3412),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: isBusy ? null : onReject,
                      icon: const Icon(Icons.close, color: Color(0xFFEF4444)),
                      label: const Text(
                        'Tolak',
                        style: TextStyle(
                          color: Color(0xFFEF4444),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFFCA5A5)),
                        backgroundColor: const Color(0xFFFFFBFB),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: isBusy ? null : onApprove,
                      icon: const Icon(Icons.check),
                      label: const Text('Setujui'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF16A34A),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String value) {
    if (value.contains('-')) {
      final parts = value.split('-');
      if (parts.length == 3) {
        return '${parts[2]}/${parts[1]}/${parts[0]}';
      }
    }
    return value;
  }
}

class _ValidatorStatusBadge extends StatelessWidget {
  const _ValidatorStatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    late final Color bgColor;
    late final Color textColor;
    late final String label;

    switch (status.toLowerCase()) {
      case 'approved':
        bgColor = const Color(0xFFDCFCE7);
        textColor = const Color(0xFF166534);
        label = 'Anda setujui';
        break;
      case 'rejected':
        bgColor = const Color(0xFFFFE4E6);
        textColor = const Color(0xFFBE123C);
        label = 'Anda tolak';
        break;
      default:
        bgColor = const Color(0xFFFFF7ED);
        textColor = const Color(0xFF9A3412);
        label = 'Menunggu';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF475569)),
          const SizedBox(width: 7),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF334155),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
