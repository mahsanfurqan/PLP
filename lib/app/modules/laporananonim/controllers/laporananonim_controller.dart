import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plp/service/laporan_anonim_service.dart';
import 'dart:typed_data';

class LaporananonimController extends GetxController {
  final studentNameController = TextEditingController();
  final incidentDateController = TextEditingController();
  final incidentDescriptionController = TextEditingController();

  final isSubmitting = false.obs;
  final isSubmitButtonPressed = false.obs;
  final selectedEvidenceImage = Rxn<XFile>();
  final selectedEvidenceImageBytes = Rxn<Uint8List>();
  final ImagePicker _imagePicker = ImagePicker();

  void triggerSubmitButton() {
    isSubmitButtonPressed.value = true;
    Future.delayed(const Duration(milliseconds: 100), () {
      isSubmitButtonPressed.value = false;
    });
  }

  String formatTanggal(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String convertTanggalToIso(String input) {
    try {
      final date = DateTime.parse(
        '${input.substring(6)}-${input.substring(3, 5)}-${input.substring(0, 2)}',
      );
      return date.toIso8601String().split('T').first;
    } catch (_) {
      return input;
    }
  }

  Future<void> pickEvidenceImage() async {
    try {
      final picked = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (picked != null) {
        final bytes = await picked.readAsBytes();
        selectedEvidenceImage.value = picked;
        selectedEvidenceImageBytes.value = bytes;
      } else {
        Get.snackbar('Info', 'Pemilihan gambar dibatalkan');
      }
    } catch (e) {
      final message = e.toString();
      if (message.toLowerCase().contains('permission')) {
        Get.snackbar(
          'Gagal',
          'Izin galeri belum diberikan. Aktifkan izin Foto/Galeri di pengaturan aplikasi.',
        );
        return;
      }
      Get.snackbar('Gagal', 'Tidak dapat mengakses galeri perangkat: $message');
    }
  }

  void removeEvidenceImage() {
    selectedEvidenceImage.value = null;
    selectedEvidenceImageBytes.value = null;
  }

  Future<void> submitAnonymousReport() async {
    final studentName = studentNameController.text.trim();
    final incidentDateRaw = incidentDateController.text.trim();
    final incidentDescription = incidentDescriptionController.text.trim();

    if (studentName.isEmpty ||
        incidentDateRaw.isEmpty ||
        incidentDescription.isEmpty) {
      Get.snackbar('Gagal', 'Lengkapi semua field terlebih dahulu');
      return;
    }

    isSubmitting.value = true;

    try {
      final incidentDateIso = convertTanggalToIso(incidentDateRaw);

      await LaporanAnonimService.submitLaporanAnonim(
        studentName: studentName,
        incidentDescription: incidentDescription,
        incidentDate: incidentDateIso,
        evidenceImageBytes: selectedEvidenceImageBytes.value,
        evidenceImageFileName: selectedEvidenceImage.value?.name,
      );

      studentNameController.clear();
      incidentDateController.clear();
      incidentDescriptionController.clear();
      selectedEvidenceImage.value = null;
      selectedEvidenceImageBytes.value = null;

      Get.snackbar(
        'Sukses',
        'Laporan berhasil dikirim.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    studentNameController.dispose();
    incidentDateController.dispose();
    incidentDescriptionController.dispose();
    super.onClose();
  }
}
