// pendaftaranplp_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:plp/app/routes/app_pages.dart';

class PendaftaranplpController extends GetxController {
  final keminatanIdController = TextEditingController();
  final nilaiPlp1Controller = TextEditingController();
  final nilaiMicroController = TextEditingController();
  final pilihanSmk1Controller = TextEditingController();
  final pilihanSmk2Controller = TextEditingController();

  final isSubmitting = false.obs;

  final _box = GetStorage();
  final String baseUrl = "http://10.0.2.2:8000/api";

  void submitPendaftaran() async {
    isSubmitting.value = true;

    final token = _box.read("token");
    if (token == null) {
      Get.snackbar("Error", "Token tidak ditemukan, silakan login ulang.");
      isSubmitting.value = false;
      return;
    }

    final response = await http.post(
      Uri.parse("$baseUrl/pendaftaran-plp"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "keminatan_id": int.tryParse(keminatanIdController.text),
        "nilai_plp_1": nilaiPlp1Controller.text,
        "nilai_micro_teaching": nilaiMicroController.text,
        "pilihan_smk_1": int.tryParse(pilihanSmk1Controller.text),
        "pilihan_smk_2": int.tryParse(pilihanSmk2Controller.text),
      }),
    );

    isSubmitting.value = false;

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      Get.snackbar("Sukses", data["message"] ?? "Pendaftaran berhasil");
      Get.offAllNamed(Routes.HOME);
    } else {
      final error = jsonDecode(response.body);
      Get.snackbar("Gagal", error["message"] ?? "Terjadi kesalahan");
    }
  }

  @override
  void onClose() {
    keminatanIdController.dispose();
    nilaiPlp1Controller.dispose();
    nilaiMicroController.dispose();
    pilihanSmk1Controller.dispose();
    pilihanSmk2Controller.dispose();
    super.onClose();
  }
}
