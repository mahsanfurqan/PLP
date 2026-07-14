import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plp/models/logbook_group_model.dart';
import 'package:plp/models/logbook_model.dart';
import 'package:plp/service/logbook_service.dart';
import 'package:plp/widget/app_snackbar.dart';

class LihatlogbookallController extends GetxController {
  final isLoading = false.obs;
  final groups = <LogbookGroupModel>[].obs;
  final selectedGroup = Rxn<LogbookGroupModel>();
  final searchController = TextEditingController();
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      searchQuery.value = searchController.text.trim();
    });
    fetchGroups();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchGroups() async {
    try {
      isLoading.value = true;
      final result = await LogbookService.getLogbookGroups();
      groups.assignAll(result);
    } catch (e) {
      AppSnackbar.show('Error', 'Gagal memuat kelompok logbook: $e');
      groups.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void openGroup(LogbookGroupModel group) {
    selectedGroup.value = group;
  }

  void backToGroupList() {
    selectedGroup.value = null;
    searchController.clear();
    searchQuery.value = '';
  }

  List<LogbookGroupModel> get filteredGroups {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) {
      return groups;
    }

    return groups.where((group) {
      final studentNames = group.students
          .map((student) => student.name)
          .join(' ');
      final searchableText =
          [
            group.name,
            group.dosenPembimbing.name,
            group.guruPamong.name,
            studentNames,
          ].join(' ').toLowerCase();

      return searchableText.contains(query);
    }).toList();
  }

  List<LogbookModel> get filteredSelectedGroupLogbooks {
    final group = selectedGroup.value;
    if (group == null) {
      return const <LogbookModel>[];
    }

    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) {
      return group.logbooks;
    }

    return group.logbooks.where((logbook) {
      final approvalTexts = logbook.approvers
          .map(
            (approval) =>
                '${approval.name} ${approval.role} ${approval.status} ${approval.note}',
          )
          .join(' ');

      final searchableText =
          [
            logbook.userName ?? '',
            logbook.keterangan,
            logbook.tanggal,
            logbook.mulai,
            logbook.selesai,
            logbook.status,
            logbook.dokumentasi,
            approvalTexts,
          ].join(' ').toLowerCase();

      return searchableText.contains(query);
    }).toList();
  }
}
