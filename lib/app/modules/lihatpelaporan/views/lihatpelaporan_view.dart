import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plp/app/navbar/custom_navbar.dart';

import '../controllers/lihatpelaporan_controller.dart';

class LihatpelaporanView extends GetView<LihatpelaporanController> {
  const LihatpelaporanView({super.key});

  DateTime? _parseDate(String raw) {
    try {
      return DateTime.parse(raw).toLocal();
    } catch (_) {
      return null;
    }
  }

  String _formatDate(String raw) {
    final parsed = _parseDate(raw);
    if (parsed == null) return raw;
    return DateFormat('dd MMM yyyy').format(parsed);
  }

  String _formatDateTime(String raw) {
    final parsed = _parseDate(raw);
    if (parsed == null) return raw;
    return DateFormat('dd MMM yyyy, HH:mm').format(parsed);
  }

  void _showImagePreview(BuildContext context, Uint8List imageBytes) {
    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            insetPadding: const EdgeInsets.all(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 4,
                child: Image.memory(imageBytes, fit: BoxFit.contain),
              ),
            ),
          ),
    );
  }

  Widget _buildMessageState({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onRetry,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: Colors.black38),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba lagi'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEvidenceSection({
    required BuildContext context,
    required int reportId,
    required String imageUrl,
  }) {
    return Obx(() {
      final imageBytes = controller.evidenceImageBytes[reportId];
      final isLoading = controller.loadingEvidenceIds.contains(reportId);
      final hasFailed = controller.failedEvidenceIds.contains(reportId);

      if (imageBytes != null) {
        return InkWell(
          onTap: () => _showImagePreview(context, imageBytes),
          borderRadius: BorderRadius.circular(10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.memory(
                    imageBytes,
                    fit: BoxFit.cover,
                    gaplessPlayback: true,
                  ),
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.zoom_in, size: 14, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'Lihat bukti',
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      if (!isLoading && !hasFailed) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.loadEvidenceImage(reportId, imageUrl);
        });
      }

      if (isLoading) {
        return AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.2),
            ),
          ),
        );
      }

      if (hasFailed) {
        return AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Gagal memuat gambar bukti'),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed:
                      () => controller.loadEvidenceImage(
                        reportId,
                        imageUrl,
                        forceRefresh: true,
                      ),
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Coba lagi'),
                ),
              ],
            ),
          ),
        );
      }

      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2.2),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4FA),
      appBar: AppBar(
        title: const Text('Lihat Pelaporan'),
        centerTitle: true,
        backgroundColor: const Color(0xFFF5F4FA),
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.laporanList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty &&
            controller.laporanList.isEmpty) {
          return _buildMessageState(
            icon: Icons.error_outline,
            title: 'Gagal memuat pelaporan',
            subtitle: controller.errorMessage.value,
            onRetry: controller.fetchLaporan,
          );
        }

        if (controller.laporanList.isEmpty) {
          return _buildMessageState(
            icon: Icons.inbox_outlined,
            title: 'Belum ada laporan',
            subtitle: 'Saat ini belum ada laporan masuk.',
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchLaporan,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: controller.laporanList.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final laporan = controller.laporanList[index];
              final isProcessing = controller.markingReadIds.contains(
                laporan.id,
              );
              final incidentDate = _formatDate(laporan.incidentDate);
              final createdAt = _formatDateTime(laporan.createdAt);
              final evidenceImageUrl = laporan.evidenceImageUrl;

              return Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                shadowColor: const Color(0x14000000),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF1EC),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.report_problem_rounded,
                              color: Color(0xFFE95D2A),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              laporan.studentName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  laporan.isRead
                                      ? const Color(0xFFE9EDF5)
                                      : const Color(0xFFFFE7CE),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              laporan.isRead ? 'Dibaca' : 'Baru',
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                    laporan.isRead
                                        ? const Color(0xFF46536A)
                                        : const Color(0xFFCA6613),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6F8FC),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.event_outlined,
                              size: 16,
                              color: Color(0xFF64748B),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Tanggal kejadian: $incidentDate',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF334155),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        laporan.incidentDescription,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.4,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      if (evidenceImageUrl != null &&
                          evidenceImageUrl.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildEvidenceSection(
                          context: context,
                          reportId: laporan.id,
                          imageUrl: evidenceImageUrl,
                        ),
                      ],
                      const SizedBox(height: 10),
                      Text(
                        'Masuk: $createdAt',
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      if (!laporan.isRead) ...[
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: const Color(0xFFEEF2FF),
                              foregroundColor: const Color(0xFF4F46E5),
                              disabledBackgroundColor: const Color(0xFFE5E7EB),
                              disabledForegroundColor: const Color(0xFF6B7280),
                              padding: const EdgeInsets.symmetric(vertical: 11),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed:
                                isProcessing
                                    ? null
                                    : () => controller.tandaiDibaca(laporan.id),
                            icon:
                                isProcessing
                                    ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : const Icon(Icons.done_all, size: 18),
                            label: Text(
                              isProcessing ? 'Memproses...' : 'Tandai dibaca',
                            ),
                          ),
                        ),
                      ] else ...[
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                            Icon(
                              Icons.verified_rounded,
                              size: 16,
                              color: Color(0xFF16A34A),
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Sudah dibaca',
                              style: TextStyle(
                                color: Color(0xFF16A34A),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
      bottomNavigationBar: const CustomNavbar(),
    );
  }
}
