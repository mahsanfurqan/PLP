import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plp/app/navbar/custom_navbar.dart';
import 'package:plp/models/logbook_model.dart';
import 'package:plp/widget/custom_button.dart';

import '../controllers/isilogbook_controller.dart';
import 'package:plp/widget/app_snackbar.dart';

class IsilogbookView extends GetView<IsilogbookController> {
  const IsilogbookView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFF),
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Logbook Anda',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Obx(() {
            if (controller.isIntegrityPactLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!controller.hasAcceptedIntegrityPact.value) {
              return _IntegrityPactView(controller: controller);
            }

            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.logbookList.isEmpty) {
              return const Center(child: Text('Belum ada logbook'));
            }

            final filteredLogbooks = controller.filteredLogbookList;

            return RefreshIndicator(
              onRefresh: controller.fetchLogbookData,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
                children: [
                  _SearchBar(controller: controller),
                  const SizedBox(height: 14),
                  if (filteredLogbooks.isEmpty)
                    const _EmptySearchState()
                  else
                    ...List.generate(filteredLogbooks.length, (index) {
                      final logbook = filteredLogbooks[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _LogbookCard(
                          logbook: logbook,
                          durationText: controller.calculateDuration(
                            logbook.mulai,
                            logbook.selesai,
                          ),
                          onDelete: () {
                            Get.defaultDialog(
                              title: 'Konfirmasi',
                              middleText: 'Hapus logbook ini?',
                              textConfirm: 'Ya',
                              textCancel: 'Tidak',
                              onConfirm: () {
                                Get.back();
                                controller.deleteLogbook(logbook.id);
                              },
                            );
                          },
                          onEdit: () => controller.goToEditLogbook(logbook),
                        ),
                      );
                    }),
                ],
              ),
            );
          }),
          Obx(
            () =>
                controller.hasAcceptedIntegrityPact.value
                    ? Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Divider(height: 1, thickness: 1),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                12,
                                16,
                                24,
                              ),
                              child: Obx(
                                () => CustomButton(
                                  text: 'TAMBAH LOGBOOK',
                                  color: const Color(0xFF58CC02),
                                  shadowColor: Colors.green.shade700,
                                  onTap: () {
                                    controller.isStartButtonPressed.value =
                                        true;
                                    controller.goToTambahLogbook();
                                  },
                                  isPressed:
                                      controller.isStartButtonPressed.value,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    : const SizedBox.shrink(),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavbar(),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller});

  final IsilogbookController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller.searchController,
      decoration: InputDecoration(
        hintText: 'Cari kegiatan, tanggal, status, atau catatan...',
        prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B)),
        suffixIcon: Obx(
          () =>
              controller.searchQuery.value.isNotEmpty
                  ? IconButton(
                    onPressed: () {
                      controller.searchController.clear();
                      controller.searchQuery.value = '';
                    },
                    icon: const Icon(Icons.close, color: Color(0xFF64748B)),
                  )
                  : const SizedBox.shrink(),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
        ),
      ),
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  const _EmptySearchState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: const Column(
        children: [
          Icon(Icons.search_off_rounded, size: 40, color: Color(0xFF94A3B8)),
          SizedBox(height: 12),
          Text(
            'Logbook tidak ditemukan',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Color(0xFF0F172A),
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Coba gunakan kata kunci lain seperti tanggal, status, atau isi kegiatan.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF64748B), height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _IntegrityPactView extends StatelessWidget {
  const _IntegrityPactView({required this.controller});

  final IsilogbookController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1D4ED8), Color(0xFF60A5FA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 22,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.verified_user_outlined,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Pakta Integritas Logbook PLP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Mahasiswa wajib membaca dan menyetujui pakta integritas sebelum mengakses halaman logbook.',
                  style: TextStyle(color: Color(0xFFE8EEFF), height: 1.45),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x10000000),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _PactSectionTitle(
                  title: 'Pernyataan',
                  icon: Icons.gavel_outlined,
                ),
                SizedBox(height: 12),
                Text(
                  'Saya menyatakan bahwa selama kegiatan PLP berlangsung, saya tidak memiliki hubungan keluarga, kedekatan pribadi yang menimbulkan konflik kepentingan, atau hubungan lain yang dapat memengaruhi objektivitas saya dengan siswa di tempat saya melaksanakan PLP.',
                  style: TextStyle(height: 1.6, color: Color(0xFF334155)),
                ),
                SizedBox(height: 18),
                _PactSectionTitle(
                  title: 'Komitmen Mahasiswa',
                  icon: Icons.fact_check_outlined,
                ),
                SizedBox(height: 12),
                _PactBullet(
                  text:
                      'Menjaga profesionalitas selama observasi, praktik mengajar, dan seluruh kegiatan PLP.',
                ),
                _PactBullet(
                  text:
                      'Tidak memanfaatkan hubungan pribadi dengan siswa untuk kepentingan di luar kegiatan akademik.',
                ),
                _PactBullet(
                  text:
                      'Siap menerima konsekuensi akademik apabila pernyataan ini tidak benar.',
                ),
                SizedBox(height: 18),
                _PactSectionTitle(
                  title: 'Catatan',
                  icon: Icons.warning_amber_rounded,
                ),
                SizedBox(height: 12),
                Text(
                  'Persetujuan ini dicatat per akun dan hanya perlu dilakukan satu kali, kecuali ada kebijakan baru dari program PLP.',
                  style: TextStyle(height: 1.6, color: Color(0xFF334155)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Obx(
              () => CheckboxListTile(
                value: controller.integrityPactChecked.value,
                onChanged:
                    (value) =>
                        controller.integrityPactChecked.value = value ?? false,
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Saya telah membaca, memahami, dan menyetujui pakta integritas ini.',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Obx(
            () =>
                controller.isSubmittingIntegrityPact.value
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                      text: 'SAYA SETUJU',
                      color: const Color(0xFF2563EB),
                      shadowColor: const Color(0xFF1D4ED8),
                      onTap: () {
                        if (!controller.integrityPactChecked.value) {
                          AppSnackbar.show(
                            'Perhatian',
                            'Centang persetujuan terlebih dahulu.',
                          );
                          return;
                        }

                        controller.acceptIntegrityPact();
                      },
                      isPressed: false,
                    ),
          ),
        ],
      ),
    );
  }
}

class _PactSectionTitle extends StatelessWidget {
  const _PactSectionTitle({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF2563EB), size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}

class _PactBullet extends StatelessWidget {
  const _PactBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF2563EB),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(height: 1.55, color: Color(0xFF334155)),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogbookCard extends StatelessWidget {
  const _LogbookCard({
    required this.logbook,
    required this.durationText,
    required this.onDelete,
    required this.onEdit,
  });

  final LogbookModel logbook;
  final String durationText;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final rejectedApprovals =
        logbook.approvers
            .where((approval) => approval.status.toLowerCase() == 'rejected')
            .toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              gradient: LinearGradient(
                colors: _headerGradient(logbook.status),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        _headerIcon(logbook.status),
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _formatStatusHeadline(logbook.status),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _statusDescription(logbook.status),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFFE8EEFF),
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    _StatusBadge(status: logbook.status, compact: true),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        size: 18,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Tanggal kegiatan: ${_formatDate(logbook.tanggal)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Text(
                    logbook.keterangan,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _InfoChip(
                      icon: Icons.schedule_outlined,
                      text: '${logbook.mulai} - ${logbook.selesai}',
                    ),
                    _InfoChip(
                      icon: Icons.timelapse_outlined,
                      text: 'Durasi $durationText',
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const _SectionTitle(
                  icon: Icons.fact_check_outlined,
                  title: 'Status Validasi',
                ),
                const SizedBox(height: 12),
                if (logbook.approvers.isNotEmpty)
                  ...logbook.approvers.map(
                    (approval) => _ApprovalTile(approval: approval),
                  ),
                if (logbook.approvers.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'Belum ada pembimbing atau guru yang terhubung ke logbook ini.',
                      style: TextStyle(color: Color(0xFF64748B)),
                    ),
                  ),
                if (rejectedApprovals.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF1F2),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFFECDD3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.edit_note,
                              color: Color(0xFFBE123C),
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Perlu Perbaikan',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFBE123C),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ...rejectedApprovals.map(
                          (approval) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              '${approval.role} ${approval.name}: ${approval.note.isEmpty ? 'Belum ada catatan.' : approval.note}',
                              style: const TextStyle(
                                color: Color(0xFF881337),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Silakan perbaiki logbook lalu kirim ulang sesuai saran di atas.',
                          style: TextStyle(
                            color: Color(0xFF9F1239),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (logbook.dokumentasi.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  const _SectionTitle(
                    icon: Icons.link_outlined,
                    title: 'Dokumentasi',
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Text(
                      logbook.dokumentasi,
                      style: const TextStyle(
                        color: Color(0xFF475569),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onDelete,
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Color(0xFFEF4444),
                        ),
                        label: const Text(
                          'Hapus',
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
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: onEdit,
                        icon: Icon(
                          logbook.canEdit ? Icons.edit_note : Icons.edit,
                        ),
                        label: Text(
                          logbook.canEdit ? 'Perbaiki Logbook' : 'Edit Logbook',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
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
        ],
      ),
    );
  }

  List<Color> _headerGradient(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return const [Color(0xFF16A34A), Color(0xFF22C55E)];
      case 'rejected':
        return const [Color(0xFFE11D48), Color(0xFFFB7185)];
      default:
        return const [Color(0xFF1D4ED8), Color(0xFF60A5FA)];
    }
  }

  IconData _headerIcon(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Icons.verified_rounded;
      case 'rejected':
        return Icons.rule_folder_outlined;
      default:
        return Icons.hourglass_top_rounded;
    }
  }

  String _formatStatusHeadline(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return 'Logbook Sudah Divalidasi';
      case 'rejected':
        return 'Logbook Perlu Diperbaiki';
      default:
        return 'Logbook Menunggu Validasi';
    }
  }

  String _statusDescription(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return 'Kegiatan ini sudah diterima oleh semua validator.';
      case 'rejected':
        return 'Ada catatan revisi dari validator yang perlu ditindaklanjuti.';
      default:
        return 'Logbook sedang menunggu pengecekan dari pembimbing dan guru pamong.';
    }
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

class _ApprovalTile extends StatelessWidget {
  const _ApprovalTile({required this.approval});

  final LogbookApprovalModel approval;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E7FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.person_outline, color: Color(0xFF4F46E5)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  approval.role,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  approval.name,
                  style: const TextStyle(color: Color(0xFF64748B)),
                ),
                if (approval.note.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Catatan: ${approval.note}',
                    style: const TextStyle(
                      color: Color(0xFF475569),
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          _StatusBadge(status: approval.status),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status, this.compact = false});

  final String status;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    late final Color bgColor;
    late final Color textColor;
    late final String label;

    switch (status.toLowerCase()) {
      case 'approved':
        bgColor = const Color(0xFFDCFCE7);
        textColor = const Color(0xFF166534);
        label = 'Disetujui';
        break;
      case 'rejected':
        bgColor = const Color(0xFFFFE4E6);
        textColor = const Color(0xFFBE123C);
        label = 'Ditolak';
        break;
      default:
        bgColor = const Color(0xFFFFF7ED);
        textColor = const Color(0xFF9A3412);
        label = 'Menunggu';
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 11,
        vertical: compact ? 6 : 7,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w700,
          fontSize: compact ? 12 : 11.5,
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF334155)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}
