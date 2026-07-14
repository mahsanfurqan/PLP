import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plp/app/navbar/custom_navbar.dart';
import 'package:plp/models/logbook_group_model.dart';
import 'package:plp/models/logbook_model.dart';

import '../controllers/lihatlogbookall_controller.dart';
import '../widget/logbook_card.dart';
import '../widget/logbook_detail_bottom_sheet.dart';

class LihatlogbookallView extends GetView<LihatlogbookallController> {
  const LihatlogbookallView({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = controller;

    return Obx(() {
      final activeGroup = pageController.selectedGroup.value;
      final filteredGroups = pageController.filteredGroups;
      final filteredLogbooks = pageController.filteredSelectedGroupLogbooks;

      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFF),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF8FAFF),
          surfaceTintColor: Colors.transparent,
          leading:
              activeGroup != null
                  ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: pageController.backToGroupList,
                  )
                  : null,
          title: Text(
            activeGroup == null ? 'Lihat Logbook Mahasiswa' : activeGroup.name,
          ),
          centerTitle: true,
        ),
        body:
            pageController.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                  onRefresh: pageController.fetchGroups,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    children: [
                      _SearchBar(
                        controller: pageController,
                        activeGroup: activeGroup,
                      ),
                      const SizedBox(height: 14),
                      if (activeGroup == null)
                        _GroupListSection(
                          groups: filteredGroups,
                          searchQuery: pageController.searchQuery.value,
                          onTap: pageController.openGroup,
                        )
                      else
                        SizedBox(
                          height:
                              MediaQuery.of(context).size.height -
                              kToolbarHeight -
                              220,
                          child: _GroupDetailSection(
                            group: activeGroup,
                            logbooks: filteredLogbooks,
                            searchQuery: pageController.searchQuery.value,
                            onTapLogbook: (logbook) {
                              _showLogbookDetail(
                                context,
                                logbook,
                                logbook.userName ?? 'Mahasiswa',
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
        bottomNavigationBar: const CustomNavbar(),
      );
    });
  }

  void _showLogbookDetail(
    BuildContext context,
    LogbookModel logbook,
    String userName,
  ) {
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

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.activeGroup});

  final LihatlogbookallController controller;
  final LogbookGroupModel? activeGroup;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller.searchController,
      decoration: InputDecoration(
        hintText:
            activeGroup == null
                ? 'Cari kelompok, pembimbing, guru, atau mahasiswa...'
                : 'Cari mahasiswa, kegiatan, tanggal, atau status logbook...',
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

class _GroupListSection extends StatelessWidget {
  const _GroupListSection({
    required this.groups,
    required this.searchQuery,
    required this.onTap,
  });

  final List<LogbookGroupModel> groups;
  final String searchQuery;
  final ValueChanged<LogbookGroupModel> onTap;

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) {
      return _EmptySearchState(
        title:
            searchQuery.isEmpty
                ? 'Belum ada kelompok logbook'
                : 'Kelompok tidak ditemukan',
        description:
            searchQuery.isEmpty
                ? 'Data kelompok akan muncul setelah mahasiswa memiliki penugasan dan logbook.'
                : 'Coba gunakan kata kunci lain seperti nama kelompok, pembimbing, guru, atau mahasiswa.',
      );
    }

    return Column(
      children: List.generate(groups.length, (index) {
        final group = groups[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _GroupCard(group: group, onTap: () => onTap(group)),
        );
      }),
    );
  }
}

class _GroupDetailSection extends StatelessWidget {
  const _GroupDetailSection({
    required this.group,
    required this.logbooks,
    required this.searchQuery,
    required this.onTapLogbook,
  });

  final LogbookGroupModel group;
  final List<LogbookModel> logbooks;
  final String searchQuery;
  final ValueChanged<LogbookModel> onTapLogbook;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _GroupHeader(group: group),
        const SizedBox(height: 16),
        const Text(
          'Daftar Logbook Kelompok',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child:
              logbooks.isEmpty
                  ? _EmptySearchState(
                    title:
                        searchQuery.isEmpty
                            ? 'Belum ada logbook'
                            : 'Logbook tidak ditemukan',
                    description:
                        searchQuery.isEmpty
                            ? 'Kelompok ini belum memiliki logbook yang bisa ditampilkan.'
                            : 'Coba gunakan kata kunci lain seperti nama mahasiswa, tanggal, status, atau isi kegiatan.',
                  )
                  : ListView.builder(
                    itemCount: logbooks.length,
                    itemBuilder: (context, index) {
                      final logbook = logbooks[index];
                      return LogbookCard(
                        logbook: logbook,
                        userName: logbook.userName ?? 'Mahasiswa',
                        index: index,
                        onTap: () => onTapLogbook(logbook),
                      );
                    },
                  ),
        ),
      ],
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  const _EmptySearchState({required this.title, required this.description});

  final String title;
  final String description;

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
      child: Column(
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 40,
            color: Color(0xFF94A3B8),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Color(0xFF0F172A),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF64748B), height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({required this.group, required this.onTap});

  final LogbookGroupModel group;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
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
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E7FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.groups_2_outlined,
                      color: Color(0xFF4338CA),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          group.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${group.studentCount} mahasiswa • ${group.logbookCount} logbook',
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF94A3B8),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _InfoPanel(
                title: 'Dosen Pembimbing',
                value: group.dosenPembimbing.name,
                icon: Icons.school_outlined,
                iconColor: const Color(0xFF2563EB),
                panelColor: const Color(0xFFEFF6FF),
              ),
              const SizedBox(height: 10),
              _InfoPanel(
                title: 'Guru Pamong',
                value: group.guruPamong.name,
                icon: Icons.badge_outlined,
                iconColor: const Color(0xFFEA580C),
                panelColor: const Color(0xFFFFF7ED),
              ),
              const SizedBox(height: 14),
              const Text(
                'Anggota Kelompok',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF334155),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    group.students
                        .map(
                          (student) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              student.name,
                              style: const TextStyle(
                                color: Color(0xFF475569),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({required this.group});

  final LogbookGroupModel group;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1D4ED8), Color(0xFF60A5FA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            group.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${group.studentCount} mahasiswa • ${group.logbookCount} logbook',
            style: const TextStyle(
              color: Color(0xFFE8EEFF),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _HeaderMiniCard(
                  title: 'Pembimbing',
                  value: group.dosenPembimbing.name,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _HeaderMiniCard(
                  title: 'Guru',
                  value: group.guruPamong.name,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderMiniCard extends StatelessWidget {
  const _HeaderMiniCard({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Color(0xFFE8EEFF), fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.panelColor,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color panelColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: panelColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF0F172A),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
